import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:untitled/Screens/Chat/Stories/create/cubit/send_stories/send_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/create/text_position.dart';
import 'package:video_player/video_player.dart';

class CapturedPhotoOrVideoPage extends StatefulWidget {
  const CapturedPhotoOrVideoPage({
    super.key,
    this.isVideo = true,
    required this.file,
  });

  final File file;
  final bool isVideo;

  @override
  State<CapturedPhotoOrVideoPage> createState() =>
      _CapturedPhotoOrVideoPageState();
}

class _CapturedPhotoOrVideoPageState extends State<CapturedPhotoOrVideoPage> {
  ValueNotifier<List<EditableTextItem>> textsNotifier =
      ValueNotifier<List<EditableTextItem>>([]);
  Color selectedColor = Colors.white; // Цвет текста
  final TextEditingController textEditingController = TextEditingController();

  late VideoPlayerController videoPlayerController;

  //
  // StoriesCreateBloc storiesCreateBloc = sl<StoriesCreateBloc>();

  @override
  void dispose() {
    if (widget.isVideo && videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
    if (widget.isVideo) {
      videoPlayerController.dispose();
    }
    super.dispose();
  }

  Future _initVideoPlayer() async {
    videoPlayerController = VideoPlayerController.file(widget.file);
    await videoPlayerController.initialize();
    await videoPlayerController.setLooping(true);
    await videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff181818),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (widget.isVideo)
                      FutureBuilder(
                        future: _initVideoPlayer(),
                        builder: (context, state) {
                          if (state.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return VideoPlayer(videoPlayerController);
                          }
                        },
                      )
                    else
                      Image.file(
                        widget.file,
                        height: 1.sh,
                        width: 1.sw,
                        fit: BoxFit.fill,
                      ),
                    ValueListenableBuilder<List<EditableTextItem>>(
                      valueListenable: textsNotifier,
                      builder: (context, texts, _) {
                        return Stack(
                          children: texts.asMap().entries.map((entry) {
                            final index = entry.key;
                            final textItem = entry.value;
                            return TextPositionOfStory(
                              textItem: textItem,
                              onLongPress: () => _removeText(
                                  index), // Добавляем удаление при долгом нажатии
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: 20.h,
                  right: 24.w,
                  left: 24.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          color: Color(0xff181818),
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            width: 2
                          ),
                        ),
                        child: SvgPicture.asset("assets/icons/arrow_left.svg"),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: _addText,
                    //   child: SvgPicture.asset(
                    //     "assets/icons/text_icon.svg",
                    //     width: 24.w,
                    //     height: 24.h,
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        _showPublishDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 17.5.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: Text(
                          "Далее",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPublishDialog() {
    bool isForFriends =
        false; // Переменная для отслеживания состояния радиокнопки

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                "Вы уверены, что хотите опубликовать эту историю?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff212121),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // При нажатии изменяем состояние
                      setState(() {
                        isForFriends = !isForFriends;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Только для приятелей",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff212121),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Icon(
                          isForFriends
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isForFriends
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Отмена",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<SendStoriesCubit>(context).sendStories(
                        filePath: widget.file.path, isVideo: widget.isVideo);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 11.5.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Text(
                      "Опубликовать",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addText() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController textController = TextEditingController();
        return AlertDialog(
          backgroundColor: Color(0xfffcf7fc),
          title: Text("Введите текст"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Введите ваш текст",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                textsNotifier.value = List.from(textsNotifier.value)
                  ..add(EditableTextItem(
                    text: textController.text,
                    color: selectedColor,
                    left: 50,
                    top: 200,
                    fontSize: 24,
                  ));
                Navigator.of(context).pop();
              },
              child: Text("Добавить"),
            ),
          ],
        );
      },
    );
  }

  void _removeText(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Удалить текст?"),
          content: Text("Вы уверены, что хотите удалить этот текст?"),
          actions: [
            TextButton(
              onPressed: () {
                textsNotifier.value = List.from(textsNotifier.value)
                  ..removeAt(index);
                Navigator.of(context).pop();
              },
              child: Text("Удалить"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Отмена"),
            ),
          ],
        );
      },
    );
  }

  InputDecoration generalTextFieldDecor(
    BuildContext context, {
    String? hintText,
    String? prefixIconPath,
    Color? prefixIconColor,
    EdgeInsetsGeometry? padding,
    bool validated = true,
    Widget? traling,
  }) =>
      InputDecoration(
        fillColor: validated
            ? const Color.fromRGBO(253, 253, 255, 1)
            : const Color(0xffFFF0EE),
        prefixIcon: prefixIconPath == null
            ? null
            : Padding(
                padding: EdgeInsets.only(
                  top: 23.h,
                  bottom: 23.h,
                  left: 16.w,
                  right: 6.w,
                ),
                child: SizedBox(
                  height: 18.r,
                  width: 18.r,
                  child: Image.asset(
                    prefixIconPath,
                    color: validated ? prefixIconColor : Colors.red,
                  ),
                ),
              ),
        hintText: hintText,

        contentPadding: EdgeInsets.symmetric(
          vertical: 23.5.h,
          horizontal: 12.w,
        ),
        suffixIcon: traling,
        filled: true,
        isDense: true,
        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: validated ? const Color(0xffABB7C9) : Colors.red,
            ),
        // Added this
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),
        errorStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red,
            ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: const BorderSide(
            color: Color.fromRGBO(235, 239, 247, 1),
            width: 1.2,
          ),
        ),
        //<-- SEE HERE
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
          borderSide: const BorderSide(
            color: Color.fromRGBO(235, 239, 247, 1),
            width: 1.2,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0.r),
          ),
          borderSide: const BorderSide(
            color: Color.fromRGBO(235, 239, 247, 1),
            width: 1.2,
          ),
        ),
      );
}

class EditableTextItem {
  String text;
  Color color;
  double left;
  double top;
  double fontSize;

  EditableTextItem({
    required this.text,
    required this.color,
    required this.left,
    required this.top,
    this.fontSize = 24, // Начальный размер шрифта
  });
}
