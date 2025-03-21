import 'dart:convert';
import 'dart:developer';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/createdAtCubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/like_story/like_story_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/send_message_to_story/send_message_to_story_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/show_story/show_story_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/models/friends_stories.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';

String getHoursPassed(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt).inHours;
  return "$difference часов назад";
}

class StoryPage extends StatefulWidget {
  const StoryPage({super.key, required this.index, required this.model});

  final int index;
  final FriendsStories model;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  FocusNode formKeyNode = FocusNode();
  int? storyId;
  int? userId;
  DateTime? storyCreatedAt;

  late PageController pageController;
  final storyController = StoryController();

  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    formKeyNode.addListener(() {
      if (formKeyNode.hasFocus) {
        storyController.pause();
        log("has focus and pause story");
      } else {
        log("don't have focus and play story");
        storyController.play();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    storyController.dispose();
    formKeyNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (formKeyNode.hasFocus) {
          formKeyNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff000000),
        body: SafeArea(
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.model.data.length,
            itemBuilder: (context, index) {
              final items = {
                for (var e in widget.model.data[index].stories)
                  e: e.type == 'video'
                      ? StoryItem.pageVideo(
                          e.content!,
                          controller: storyController,
                        )
                      : StoryItem.pageImage(
                          url: e.content!,
                          controller: storyController,
                        )
              };
              return pageViewBloc(
                storyItems: items.values.toList(),
                index: index,
                controller: storyController,
                items: items,
                data: widget.model.data[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget pageViewBloc({
    required List<StoryItem> storyItems,
    required int index,
    required Map<Story, StoryItem> items,
    required StoryController controller,
    required Datum data,
  }) =>
      Stack(
        alignment: Alignment.topCenter,
        children: [
          StoryView(
            storyItems: storyItems,
            controller: controller,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                // sl<StoriesViewBloc>().add(LoadStories());
                Navigator.pop(context);
              }
            },
            //
            onComplete: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linearToEaseOut,
              );
            },
            onStoryShow: (item, asd) {
              items.forEach((key, value) {
                if (value == item) {
                  storyId = key.id;
                  storyCreatedAt = widget.model.data[index].stories
                      .firstWhere(
                        (story) => story.id == storyId,
                      )
                      .createdAt;

                  BlocProvider.of<TextCubit>(context)
                      .updateText(storyCreatedAt!);
                  BlocProvider.of<ShowStoryCubit>(context).showStory(
                    id: storyId!,
                  );
                }
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h, right: 24.w, left: 24.w),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      storyController.pause();
                      await goToUserProfile(
                        context: context,
                        id: widget.model.data[index].usersId!,
                      );
                      storyController.play();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            widget.model.data[index].userProfileUrl[0],
                            errorBuilder: (context, a, d) {
                              return Image.asset(
                                'assets/icons/1111.jpg',
                                width: 46,
                                height: 46,
                              );
                            },
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.model.data[index].usersFirstName ?? " ",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            BlocBuilder<TextCubit, DateTime>(
                              builder: (context, date) {
                                return Text(
                                  getHoursPassed(date),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color(0xffffffff).withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/close2.svg',
                      width: 15.w,
                      height: 15.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child:
                BlocConsumer<SendMessageToStoryCubit, SendMessageToStoryState>(
              bloc: BlocProvider.of<SendMessageToStoryCubit>(context),
              listener: (context, state) {
                if (state is SendMessageToStorySuccess) {
                  log("message sended to story");
                  textEditingController.clear();
                  DelightToastBar(
                    snackbarDuration: Duration(milliseconds: 1500),
                    autoDismiss: true,
                    builder: (context) => const ToastCard(
                      color: Colors.white,
                      leading: Icon(
                        Icons.arrow_back_rounded,
                        size: 25,
                        color: Color(0xff212121),
                      ),
                      title: Text(
                        "Сообщение отправлено",
                        style: TextStyle(
                          color: Color(0xff212121),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).show(context);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     padding: EdgeInsets.all(10),
                  //     backgroundColor: Colors.white.withOpacity(0.8),
                  //     content: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(
                  //           Icons.arrow_back_rounded,
                  //           size: 25,
                  //           color: Color(0xff212121),
                  //         ),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Text(
                  //           "Сообщение отправлено",
                  //           style: TextStyle(
                  //             color: Color(0xff212121),
                  //             fontSize: 16.0,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // );
                }
                if (state is SendMessageToStoryError) {
                  log('message do not sended to story');
                }
              },
              builder: (context, state) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.topCenter,
                    color: Color(0xff181818),
                    height: 112,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 44,
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Stack(
                              children: [
                                TextFormField(
                                  onTap: () {
                                    log("ASDASDSA");
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  readOnly: state is SendMessageToStoryLoading
                                      ? true
                                      : false,
                                  focusNode: formKeyNode,
                                  controller: textEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Отправить сообщением...',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    fillColor: Color(0xff181818),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: state is SendMessageToStoryLoading
                                      ? null
                                      : () {
                                          if (textEditingController
                                              .text.isNotEmpty) {
                                            var text = textEditingController
                                                .text
                                                .trim();

                                            text = text.replaceAll(
                                                RegExp(
                                                    r'((?<=\n)\s+)|((?<=\s)\s+)'),
                                                "");
                                            BlocProvider.of<
                                                        SendMessageToStoryCubit>(
                                                    context)
                                                .sendMessageToStory(
                                              storyId: storyId!,
                                              userId: widget
                                                  .model.data[index].usersId,
                                              message: text,
                                            );
                                          }
                                          formKeyNode.unfocus();
                                        },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                      ),
                                      child: state is SendMessageToStoryLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Image.asset(
                                              'assets/icons/bxs_paper-plane.png',
                                              width: 20,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          BlocConsumer<LikeStoryCubit,
                              Map<int, LikeStoryState>>(
                            bloc: BlocProvider.of<LikeStoryCubit>(context),
                            listener: (context, state) {
                              final storyState = state[storyId];
                              if (storyState is LikeStoryError) {
                                log("Error when liking: ${storyState.message}");
                              }
                            },
                            builder: (context, state) {
                              final storyState = state[storyId];

                              if (storyState is LikeStoryLoading) {
                                return SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (storyState is LikeStorySuccess) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: widget.model.data[index].stories
                                            .firstWhere(
                                              (story) => story.id == storyId,
                                            )
                                            .isLiked ??
                                        false
                                    ? null
                                    : () {
                                        BlocProvider.of<LikeStoryCubit>(context)
                                            .likeStory(
                                          id: storyId!,
                                        );
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: widget.model.data[index].stories
                                              .firstWhere(
                                                (story) => story.id == storyId,
                                              )
                                              .isLiked ??
                                          false
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );

  goToUserProfile({
    required BuildContext context,
    required int id,
  }) async {
    UserProfileData targetUserProfile = UserProfileData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";

    var response = await NetworkService().GetUserInfoByID(accessToken, id);

    if (response.statusCode != 200) {
      return;
    }
    debugPrint("${response.statusCode}");
    debugPrint("${jsonDecode(response.body)}");
    targetUserProfile.jsonToData(jsonDecode(response.body)[0]);

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleUser(anketa: targetUserProfile),
        )).then(
      (_) => {
        setState(
          () {},
        ),
      },
    );
  }
}
