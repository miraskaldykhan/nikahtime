import 'dart:io';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
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
  final int maxItemCount = 9;

  @override
  Widget build(BuildContext context) {
    final int _itemCount = widget.userProfileData.images?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Кнопка "Изменить фотографию"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () => showPhotoActions(0, true),
            icon: const Icon(Icons.edit),
            label: Text(LocaleKeys.profileScreen_settings_change_photo.tr()),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              textStyle:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
              backgroundColor:  Colors.white70,
            ),
          ),
        ),
        // Основная фотография или иконка камеры
        GestureDetector(
          onTap: () async {
            showPhotoActions(0, true);
          },
          onLongPress: () async {
            showPhotoActions(0, true);
          },
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
          onTap: () async {
            showPhotoActions(index, false);
          },
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
      final photoIndex = index - 1; // Смещаем индекс для фотографий
      return GestureDetector(
        onLongPress: () async {
          showPhotoActions(photoIndex, false);
        },
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

  void showPhotoActions(int index, bool main) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(LocaleKeys.common_takePhoto.tr()),
          onTap: () async {
            try {
              XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                preferredCameraDevice: CameraDevice.front,
              );
              if (image != null) {
                setState(() {
                  sendProfileImageOrVideo(
                    File(image.path),
                    "image",
                    index,
                  );
                });
              }
            } catch (err) {
              debugPrint(err.toString());
            }
            widget.callback();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: Text(LocaleKeys.common_getPhoto.tr()),
          onTap: () async {
            try {
              XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                setState(() {
                  sendProfileImageOrVideo(
                    File(image.path),
                    "image",
                    index,
                  );
                });
              }
            } catch (err) {
              debugPrint(err.toString());
            }
            widget.callback();
            Navigator.pop(context);
          },
        ),
        if (!main) ...[
          ListTile(
            leading: const Icon(Icons.videocam),
            title: Text(LocaleKeys.common_takeVide.tr()),
            onTap: () async {
              try {
                XFile? video = await picker.pickVideo(
                  source: ImageSource.camera,
                );
                if (video != null) {
                  await sendProfileImageOrVideo(File(video.path), "video", index);
                }
              } catch (err) {
                debugPrint(err.toString());
              }
              widget.callback();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(LocaleKeys.common_getVideo.tr()),
            onTap: () async {
              try {
                XFile? video = await picker.pickVideo(
                  source: ImageSource.gallery,
                );
                if (video != null) {
                  sendProfileImageOrVideo(File(video.path), "video", index);
                }
              } catch (err) {
                debugPrint(err.toString());
              }
              widget.callback();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(LocaleKeys.common_delete.tr()),
            onTap: () async {
              MyTracker.trackEvent("Delete photo from profile", {});
              setState(() {
                if (widget.userProfileData.images != null && index < widget.userProfileData.images!.length) {
                  widget.userProfileData.images!.removeAt(index);
                }
              });
              widget.callback();
              Navigator.pop(context);
            },
          ),
        ],
      ]),
    );
  }

  Future<void> sendProfileImageOrVideo(File file, String fileType, int index) async {
    if (fileType != "image" && fileType != "video") {
      throw UnsupportedError("Method does not support $fileType as fileType");
    }

    var response = await NetworkService().UploadFileRequest(
      widget.userProfileData.accessToken.toString(),
      file.path,
      fileType,
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) {
      return;
    }
    try {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> valueMap = json.decode(responseBody);
      debugPrint(valueMap.toString());
      debugPrint(index.toString());

      setState(() {
        widget.userProfileData.images ??= <UserProfileImage>[];
        if (index != 0) {
          if (fileType == "image") {
            final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
            if (index < widget.userProfileData.images!.length) {
              widget.userProfileData.images![index] = photo;
            } else {
              widget.userProfileData.images!.add(photo);
            }
          } else if (fileType == "video") {
            final videoLink = valueMap["fileURL"];
            if (index < widget.userProfileData.images!.length) {
              widget.userProfileData.images![index] = UserProfileImage(
                main: videoLink,
                preview: videoLink,
              );
            } else {
              widget.userProfileData.images!.add(UserProfileImage(
                main: videoLink,
                preview: videoLink,
              ));
            }
          }
        } else {
          if (widget.userProfileData.images!.isEmpty) {
            widget.userProfileData.images!.add(UserProfileImage(preview: "", main: ""));
          }
          if (fileType == "image") {
            final photo = UserProfileImage.fromJson(valueMap["photos"][0]);
            widget.userProfileData.images![index] = photo;
          } else if (fileType == "video") {
            final videoLink = valueMap["fileURL"];
            widget.userProfileData.images![index] = UserProfileImage(
              main: videoLink,
              preview: videoLink,
            );
          }
        }
      });
    } catch (error) {
      debugPrint("Error: $error");
    }
  }
}
