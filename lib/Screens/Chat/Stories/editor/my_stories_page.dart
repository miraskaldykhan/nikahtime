import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/createdAtCubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/delete/delete_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/get_my_stories/get_my_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/get_stories_viewers/stories_viewers_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/models/stories_model.dart';
import 'package:untitled/Screens/Chat/Stories/models/viewers_model.dart';

String getHoursPassed(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt).inHours;
  return "$difference часов назад";
}

class MyStoriesPage extends StatefulWidget {
  const MyStoriesPage({super.key, required this.model});

  final MyStoryResponse model;

  @override
  State<MyStoriesPage> createState() => _MyStoriesPageState();
}

class _MyStoriesPageState extends State<MyStoriesPage> {
  final storyController = StoryController();

  Map<int, StoryItem> items = {};

  int? storyId;
  DateTime? storyCreatedAt;

  @override
  void initState() {
    super.initState();
    for (var item in widget.model.data) {
      items[item.id] = item.type == "video"
          ? StoryItem.pageVideo(
              item.content,
              controller: storyController,
            )
          : StoryItem.pageImage(
              url: item.content,
              duration: Duration(
                seconds: 15,
              ),
              controller: storyController,
            );
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DeleteStoriesCubit, DeleteStoriesState>(
        bloc: BlocProvider.of<DeleteStoriesCubit>(context),
        listener: (context, state) {
          if (state is DeleteStoriesError) {
            log("eror: ${state.message}");
          }
          if (state is DeleteStoriesSuccess) {
            Navigator.of(context).pop();
            BlocProvider.of<GetMyStoriesCubit>(context).getMyStories();
          }
        },
        builder: (context, state) {
          if (state is DeleteStoriesLoading) {
            return SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                StoryView(
                  storyItems: items.values.toList(),
                  controller: storyController,
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      // sl<StoriesViewBloc>().add(LoadStories());
                      Navigator.pop(context);
                    }
                  },
                  //
                  onComplete: () {
                    Navigator.pop(context);
                  },
                  onStoryShow: (item, asd) {
                    items.forEach((key, value) {
                      if (value == item) {
                        storyId = key;
                        storyCreatedAt = widget.model.data
                            .firstWhere(
                              (story) => story.id == storyId,
                            )
                            .createdAt;
                        BlocProvider.of<TextCubit>(context)
                            .updateText(storyCreatedAt!);
                        BlocProvider.of<StoriesViewersCubit>(context)
                            .getStoriesViewers(id: storyId!);
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(
                                widget.model.avatarUrl[0].main,
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
                                  "Ваша история",
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
                                        color:
                                            Color(0xffffffff).withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
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
                  padding:
                      EdgeInsets.only(bottom: 22.h, right: 24.w, left: 24.w),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/icon_report.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            InkWell(
                              onTap: () {
                                showDeleteStoryAlert(() {
                                  if (storyId != null) {
                                    BlocProvider.of<DeleteStoriesCubit>(context)
                                        .deleteStories(id: storyId!);
                                  } else {
                                    log("NOTHIG");
                                  }
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/icons/icon_delete.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ],
                        ),
                        BlocConsumer<StoriesViewersCubit, StoriesViewersState>(
                          bloc: BlocProvider.of<StoriesViewersCubit>(context),
                          listener: (context, state) {
                            if (state is StoriesViewersError) {
                              log("Error: ${state.message}");
                            }
                          },
                          builder: (context, state) {
                            if (state is StoriesViewersLoading) {
                              return SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is StoriesViewersSuccess) {
                              final totalViewQuantity =
                                  state.viewersOfStories.viewers.fold<int>(
                                0,
                                (sum, viewer) =>
                                    sum + (viewer.viewQuantity ?? 0),
                              );
                              return GestureDetector(
                                onTap: () async {
                                  storyController.pause();
                                  await showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return _buildBottomSheetContent(
                                        viewers: state.viewersOfStories,
                                        totalViewQuantity: totalViewQuantity,
                                      );
                                    },
                                  );
                                  storyController.play();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      totalViewQuantity.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/icon_viewed.svg',
                                      width: 28,
                                      height: 28,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Row(
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/icon_viewed.svg',
                                  width: 28,
                                  height: 28,
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showDeleteStoryAlert(Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Вы уверены, что хотите удалить историю?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: Text("Оставить"),
            ),
            InkWell(
              onTap: () {
                onDelete(); // Выполнить удаление
                Navigator.of(context).pop(); // Закрыть диалог после удаления
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Удалить",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheetContent({
    required ViewersOfStories viewers,
    required int totalViewQuantity,
  }) {
    return Container(
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${totalViewQuantity.toString()} посмотревших',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: viewers.viewers.length, // количество элементов
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return _buildViewerItem(
                  viewer: viewers.viewers[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewerItem({
    required Viewer viewer,
  }) {
    DateTime now = DateTime.now();
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          viewer.avatar[0].main!,
        ), // Замените на URL аватара
      ),
      title: Text(
        viewer.name!,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        formatDate(viewer.lastView!),
        style: TextStyle(color: Colors.white70),
      ),
      trailing: viewer.isLiked!
          ? Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : null,
    );
  }

  String formatDate(DateTime time) {
    DateTime now = DateTime.now();

    if (now.year == time.year &&
        now.month == time.month &&
        now.day == time.day) {
      // Если дата сегодняшняя, выводим 'Сегодня'
      return 'Сегодня в ${DateFormat.Hm().format(time)}';
    } else {
      // Если дата не сегодняшняя, выводим с указанием дня и месяца
      return DateFormat('dd.MM.yyyy в HH:mm').format(time);
    }
  }
}
