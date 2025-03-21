import 'dart:io';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class PhotoPlace extends StatefulWidget {
  const PhotoPlace(this.userProfileData, this.callback, {super.key});

  final VoidCallback callback;
  final UserProfileData userProfileData;

  @override
  State<PhotoPlace> createState() => _PhotoPlaceState();
}

class _PhotoPlaceState extends State<PhotoPlace> {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Кнопка "Изменить фотографию"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () => _changeAvatar(),
            icon: const Icon(Icons.edit),
            label: Text(LocaleKeys.profileScreen_settings_change_photo.tr()),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
              backgroundColor: Colors.white70,
            ),
          ),
        ),
        // Основная фотография или иконка камеры
        GestureDetector(
          onTap: () => _changeAvatar(),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            width: double.infinity,
            height: 254,
            child: widget.userProfileData.hasMainPhoto()
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: displayPhotoOrVideo(
                      context,
                      widget.userProfileData.images![0].main.toString(),
                      items: widget.userProfileData.images!.map((e) => e.main).toList().cast<String>(),
                      initPage: 0,
                      photoOwnerId: widget.userProfileData.id,
                    ),
                  )
                : const Icon(Icons.photo_camera, color: Colors.white, size: 60),
          ),
        ),
        const SizedBox(height: 16),
        // Обертка для фотографий
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(widget.userProfileData.getAdditionalPhotosLength() + 1, (index) {
              if (index == 0) {
                // Кнопка добавления новой фотографии (первый элемент)
                return GestureDetector(
                  onTap: () => _addAdditionalMedia(),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                  ),
                );
              }

              // Отображение существующих фотографий
              final photoIndex = index ; // Смещаем индекс для фотографий
              return GestureDetector(
                onLongPress: () => _showPhotoActions(photoIndex),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 230, 230, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: displayPhotoOrVideo(
                      context,
                      widget.userProfileData.images![photoIndex].preview.toString(),
                      items: widget.userProfileData.images!.map((e) => e.main).toList().cast<String>(),
                      initPage: photoIndex,
                      photoOwnerId: widget.userProfileData.id,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _changeAvatar() {
    _showMediaPicker(isAvatar: true);
  }

  void _addAdditionalMedia() {
    _showMediaPicker(isAvatar: false);
  }

  void _showMediaPicker({required bool isAvatar}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(LocaleKeys.common_takePhoto.tr()),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndUploadMedia(isAvatar: isAvatar, mediaSource: ImageSource.camera, isPhoto: true);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: Text(LocaleKeys.common_getPhoto.tr()),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndUploadMedia(isAvatar: isAvatar, mediaSource: ImageSource.gallery, isPhoto: true);
            },
          ),
          if (!isAvatar) ...[
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(LocaleKeys.common_takeVide.tr()),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadMedia(isAvatar: false, mediaSource: ImageSource.camera, isPhoto: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: Text(LocaleKeys.common_getVideo.tr()),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadMedia(isAvatar: false, mediaSource: ImageSource.gallery, isPhoto: false);
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickAndUploadMedia({
    required bool isAvatar,
    required ImageSource mediaSource,
    required bool isPhoto,
  }) async {
    try {
      XFile? file = isPhoto
          ? await picker.pickImage(source: mediaSource)
          : await picker.pickVideo(source: mediaSource);
      if (file != null) {
        File mediaFile = File(file.path);
        String fileType = isPhoto ? "image" : "video";
        await _uploadMedia(mediaFile, fileType, isAvatar);
      }
    } catch (error) {
      debugPrint("Error picking media: $error");
    }
  }

  Future<void> _uploadMedia(File file, String fileType, bool isAvatar) async {
    try {
      var response = await NetworkService().UploadFileRequest(
        widget.userProfileData.accessToken.toString(),
        file.path,
        fileType,
      );
      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> valueMap = json.decode(responseBody);

        setState(() {
          widget.userProfileData.images ??= <UserProfileImage>[];
          if (isAvatar) {
            final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
            if (widget.userProfileData.images!.isEmpty) {
              widget.userProfileData.images!.add(photo);
            } else {
              widget.userProfileData.images![0] = photo;
            }
          } else {
            if (fileType == "image") {
              final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
              widget.userProfileData.images!.add(photo);
            } else {
              final videoLink = valueMap["fileURL"];
              widget.userProfileData.images!.add(UserProfileImage(main: videoLink, preview: videoLink));
            }
          }
        });
        widget.callback();
      }
    } catch (error) {
      debugPrint("Error uploading media: $error");
    }
  }

  void _showPhotoActions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(LocaleKeys.common_delete.tr()),
            onTap: () {
              setState(() {
                widget.userProfileData.images?.removeAt(index);
              });
              widget.callback();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
