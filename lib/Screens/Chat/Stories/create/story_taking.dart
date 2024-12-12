import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camerawesome/camerawesome_plugin.dart' as cam;
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/Screens/Chat/Stories/create/bottom_button.dart';
import 'package:untitled/Screens/Chat/Stories/create/captured_file_editing.dart';
import 'package:image/image.dart' as img;
import 'package:untitled/Screens/Chat/Stories/create/cubit/send_stories/send_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/get_my_stories/get_my_stories_cubit.dart';

class CustomStoryEditor extends StatefulWidget {
  const CustomStoryEditor({super.key});

  @override
  State<CustomStoryEditor> createState() => _CustomStoryEditorState();
}

class _CustomStoryEditorState extends State<CustomStoryEditor>
    with TickerProviderStateMixin {
  late NavigatorState navigator;

  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  String? path;

  @override
  void initState() {
    super.initState();
    navigator = Navigator.of(context);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff131313),
      body: SafeArea(
        child: BlocConsumer<SendStoriesCubit, SendStoriesState>(
          bloc: BlocProvider.of<SendStoriesCubit>(context),
          listener: (context, state) {
            if (state is SendStoriesError) {
              log("Error:  ${state.message}");
            }
            if (state is SendStoriesSuccess) {
              log("SUCCESS:");
              BlocProvider.of<GetMyStoriesCubit>(context).getMyStories();
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is SendStoriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: cam.CameraAwesomeBuilder.awesome(
                      progressIndicator: const Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      saveConfig: cam.SaveConfig.photoAndVideo(),
                      theme: cam.AwesomeTheme(
                          bottomActionsBackgroundColor: Colors.black),
                      sensorConfig: cam.SensorConfig.single(
                        aspectRatio: cam.CameraAspectRatios.ratio_16_9,
                        flashMode: cam.FlashMode.auto,
                        sensor: cam.Sensor.position(cam.SensorPosition.back),
                        zoom: 0.0,
                      ),
                      topActionsBuilder: (state) => state.captureState !=
                                  null &&
                              state.captureState!.isRecordingVideo
                          ? SizedBox.shrink()
                          : cam.AwesomeTopActions(
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              state: state,
                              children: [
                                cam.AwesomeFlashButton(
                                  state: state,
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/close2.svg",
                                    width: 15.w,
                                    height: 15.h,
                                  ),
                                ),
                              ],
                            ),
                      middleContentBuilder: (state) {
                        return Column(
                          children: [
                            const Spacer(),
                            // Use a Builder to get a BuildContext below AwesomeThemeProvider widget
                            cam.AwesomeCameraModeSelector(
                              state: state,
                            ),
                            StreamBuilder<MediaCapture?>(
                              stream: state.captureState$,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox.shrink();
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final MediaCapture mediaCapture =
                                        snapshot.requireData!;

                                    if (mediaCapture.status ==
                                            MediaCaptureStatus.success &&
                                        mediaCapture.isVideo &&
                                        path !=
                                            mediaCapture.captureRequest.path!) {
                                      path = mediaCapture.captureRequest.path!;
                                      final route = MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (_) =>
                                            CapturedPhotoOrVideoPage(
                                          file: File(mediaCapture
                                              .captureRequest.path!),
                                        ),
                                      );
                                      navigator.push(route);
                                    }
                                    if (mediaCapture.status ==
                                            MediaCaptureStatus.success &&
                                        mediaCapture.isPicture &&
                                        path !=
                                            mediaCapture.captureRequest.path!) {
                                      path = mediaCapture.captureRequest.path!;
                                      final route = MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (_) =>
                                            CapturedPhotoOrVideoPage(
                                          file: File(mediaCapture
                                              .captureRequest.path!),
                                          isVideo: false,
                                        ),
                                      );
                                      navigator.push(route);
                                    }
                                  });
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        );
                      },
                      bottomActionsBuilder: (state) => cam.AwesomeBottomActions(
                        state: state,
                        left: state.captureState != null &&
                                state.captureState!.isRecordingVideo
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  _showBottomSheet();
                                },
                                child: Icon(
                                  Icons.perm_media_outlined,
                                  color: Colors.white,
                                ),
                              ),
                        right: state.captureState != null &&
                                state.captureState!.isRecordingVideo
                            ? SizedBox.shrink()
                            : cam.AwesomeCameraSwitchButton(
                                state: state,
                                scale: 1.0,
                                onSwitchTap: (state) {
                                  state.switchCameraSensor(
                                    aspectRatio: state.sensorConfig.aspectRatio,
                                  );
                                },
                              ),
                      ),
                      onMediaTap: (mediaCapture) {
                        if (mediaCapture.isVideo) {
                          final route = MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => CapturedPhotoOrVideoPage(
                                file: File(mediaCapture.captureRequest.path!)),
                          );
                          navigator.push(route);
                        }
                        if (mediaCapture.isPicture) {
                          final route = MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => CapturedPhotoOrVideoPage(
                              file: File(mediaCapture.captureRequest.path!),
                              isVideo: false,
                            ),
                          );
                          navigator.push(route);
                        }
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Future _showBottomSheet() => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            height: 0.21.sh,
            width: double.infinity,
            child: BottomButton(
              firstOnPressed: () async {
                Navigator.of(context).pop();
                final file = await _takePhotoFromGallery();
                if (file != null) {
                  final route = MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => CapturedPhotoOrVideoPage(
                      file: File(file.path),
                      isVideo: false,
                    ),
                  );
                  navigator.push(route);
                }
              },
              firstText: "Выбрать фото",
              firstIconPath: "assets/icons/gallery.png",
              secondOnPressed: () async {
                Navigator.of(context).pop();
                final file = await _takeVideoFromGallery();
                if (file != null) {
                  final route = MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => CapturedPhotoOrVideoPage(
                      file: File(file.path),
                    ),
                  );
                  navigator.push(route);
                }
              },
              secondText: "Выбрать видео",
              secondIconPath: "isVideo",
              isWhiteBackground: true,
            ),
          );
        },
      );

  Future<XFile?> _takePhotoFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile;
  }

  Future<XFile?> _takeVideoFromGallery() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    return pickedFile;
  }
}
