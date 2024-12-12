import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:photo_view/photo_view.dart';

import 'package:photo_view/photo_view_gallery.dart';
import 'package:untitled/components/widgets/send_claim.dart';
import 'package:untitled/components/widgets/video_player.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageGalleryViewerScreen extends StatefulWidget {
  late List<String> galleryItems;
  late int startPage;
  late int? photoOwnerId;

  ImageGalleryViewerScreen(this.galleryItems,
      {this.startPage = 0, int? photoOwnerId}) {
    this.photoOwnerId = photoOwnerId;
  }

  @override
  State<ImageGalleryViewerScreen> createState() =>
      _ImageGalleryViewerScreenState();
}

class _ImageGalleryViewerScreenState extends State<ImageGalleryViewerScreen> {
  late PageController controller;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.startPage);
    currentPage = widget.startPage;

    controller.addListener(() {
      setState(() {
        currentPage = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 72 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: IconButton(
                    iconSize: 20.0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: buildPopupMenuButton(),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Основная галерея
          Expanded(
            flex: 8,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              loadingBuilder:
                  (BuildContext context, ImageChunkEvent? loadingProgress) {
                return const Center(
                  child: SizedBox(
                    height: 64,
                    width: 64,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              },
              builder: (BuildContext context, int index) {
                if (widget.galleryItems[index].contains(".avi") ||
                    widget.galleryItems[index].contains(".mp4") ||
                    widget.galleryItems[index].contains(".mov")) {
                  return PhotoViewGalleryPageOptions.customChild(
                      child: VideoPlayerScreen(
                    widget.galleryItems[index],
                    photoOwnerId: 0,
                  ));
                }
                return PhotoViewGalleryPageOptions(
                  imageProvider: getImage(widget.galleryItems[index]),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              itemCount: widget.galleryItems.length,
              pageController: controller,
            ),
          ),
          // Горизонтальный список миниатюр
          Container(
            height: 68,
            margin: const EdgeInsets.only( bottom: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.galleryItems.length,
              itemBuilder: (BuildContext context, int index) {
                bool isActive = index == currentPage;
                
                return GestureDetector(
                  onTap: () {
                    controller.jumpToPage(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 68,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isActive ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                          width: 2, // Толщина рамки
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(borderRadius: BorderRadius.circular(8) , child: displayImageOrVideoMiniature(widget.galleryItems[index], Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }



Future<String?> getVideoThumbnail(String videoUrl) async {
  try {
    // Генерация миниатюры
    final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 300, 
      quality: 75,
    );

    // Проверяем, существует ли файл миниатюры
    if (thumbnailPath != null && File(thumbnailPath).existsSync()) {
      return thumbnailPath;
    } else {
      debugPrint("Thumbnail not generated or file does not exist.");
      return null;
    }
  } catch (err) {
    // Выводим ошибку в консоль для отладки
    debugPrint("Error generating video thumbnail: $err");
    return null;
  }
}

FutureBuilder displayImageOrVideoMiniature(String url, Color color) {
  if (url.contains(".mp4") || url.contains(".avi") || url.contains(".mov")) {
    return FutureBuilder<String?>(
      future: getVideoThumbnail(url),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(snapshot.data!),
                cacheHeight: 4000,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Icon(
              Icons.slow_motion_video_outlined,
              color: color,
              size: 60,
            );
          }
        }
        return Center(child: CircularProgressIndicator(color: color));
      },
    );
  } else {
    // Если это изображение, показываем его
    return displayImageMiniature(url, Theme.of(context).colorScheme.secondary);
  }
}


  Widget buildPopupMenuButton() {
    if (widget.photoOwnerId != null) {
      return PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 20,
          ),
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    Future.delayed(
                        const Duration(seconds: 0),
                        () => SendClaim(
                            claimObjectId: widget.photoOwnerId!,
                            type: ClaimType.photo).ShowAlertDialog(this.context));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.block),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        LocaleKeys.chat_report.tr(),
                      )
                    ],
                  ),
                ),
              ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget displayMiniature(String url, Color color) {
    return FutureBuilder<Widget>(
      future: getImageFromUrl(url),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: snapshot.data,
            
          );
        }
        return SizedBox(
          width: 80,
          height: 80,
          child: Center(child: CircularProgressIndicator(color: color,)),
        );
      },
    );
  }
}

ImageProvider getImage(String url) {
  try {
    final File imageFile =
        File('${appDir.path}/${url.substring(url.lastIndexOf('/') + 1)}');
    if (imageFile.existsSync() && (imageFile.lengthSync() != 0)) {
      return Image.file(imageFile, fit: BoxFit.cover).image;
    } else {
      return NetworkImage(url);
    }
  } catch (ex) {
    return NetworkImage(url);
  }
}

Widget displayPhotoOrVideo(BuildContext context, String url,
    {List<String>? items, int? initPage, int? photoOwnerId}) {
  return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ImageGalleryViewerScreen(
              items!.cast<String>(),
              startPage: initPage!,
              photoOwnerId: photoOwnerId,
            ),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      },
      child:
          (url.contains(".mp4") || url.contains(".avi") || url.contains(".mov"))
              ? const Icon(
                  Icons.slow_motion_video_outlined,
                  color: Colors.white,
                  size: 60,
                )
              : displayImageMiniature(url, Theme.of(context).colorScheme.secondary));
}

FutureBuilder displayImageMiniature(String url, Color color) {
  return FutureBuilder<Widget>(
    future: getImageFromUrl(url),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return snapshot.data;
      }
      return Center(child: CircularProgressIndicator(color: color,));
    },
  );
}

Future<Widget> getImageFromUrl(String url) async {
  try {

    if ((url.contains("http://") || url.contains("https://")) == false) {
      final File imageFile = File(url);
      return Image.file(
        imageFile,
        cacheHeight: 4000,
        
      );
    }

    final Directory temp = await getTemporaryDirectory();
    String prefix = (url.contains("preview")) ? "/preview" : "";
    appDir = temp;
    final File imageFile =
        File('${temp.path}$prefix/${url.substring(url.lastIndexOf('/') + 1)}');

    if (imageFile.existsSync() && (imageFile.lengthSync() != 0)) {
      return Image.file(imageFile,
          cacheHeight: 1400,
          //cacheWidth: 256,
          fit: BoxFit.cover,
         );
    } else {
      // Image doesn't exist in cache
      imageFile.create(recursive: true).then((value) => http
          .get(Uri.parse(url))
          .then((response) =>
              imageFile.writeAsBytes(response.bodyBytes, flush: true)));

      return Image.network(
        url,
        
        cacheHeight: 1400,
        //cacheWidth: 256,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
                  color: Theme.of(context).colorScheme.secondary,
            ),
          );
        },
      );
    }
  } catch (err) {
    debugPrint("Can't save image/ Load from network");
    debugPrint(url);
    return Container();
  }
}
Widget displayMedia(BuildContext context, String url,
    {List<String>? items, int? initPage, int? photoOwnerId}) {
  return SizedBox(
    child: (url.contains(".mp4") || url.contains(".avi") || url.contains(".mov"))
        ? const Icon(
            Icons.slow_motion_video_outlined,
            color: Colors.white,
            size: 60,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),
  );
}

late Directory appDir;
