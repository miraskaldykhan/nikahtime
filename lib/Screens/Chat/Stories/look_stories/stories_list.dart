import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:untitled/Screens/Chat/Stories/create/story_taking.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/get_my_stories/get_my_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/my_stories_page.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/get_friends_stories/get_friend_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/models/friends_stories.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/story_page.dart';
import 'package:untitled/Screens/Chat/Stories/widgets/storiesIcon.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({super.key});

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GetMyStoriesCubit>(context).getMyStories();
    BlocProvider.of<GetFriendStoriesCubit>(context).getFriendsStories();
    return Row(
      children: [
        userProfileIconAddStory(context),
        SizedBox(width: 8.w),
        BlocConsumer<GetFriendStoriesCubit, GetFriendStoriesState>(
          bloc: BlocProvider.of<GetFriendStoriesCubit>(context),
          listener: (context, state) {
            if (state is GetFriendStoriesError) {
              log("Error when get friend stories: ${state.message}");
            }
          },
          builder: (context, state) {
            if (state is GetFriendStoriesLoading) {
              return Column(
                children: [
                  SizedBox(
                    height: 54,
                    width: 54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  const Text(
                    "....",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              );
            }
            if (state is GetFriendStoriesSuccess) {
              var newStories = state.friendsStories.data
                  .where((e) => e.stories.isNotEmpty)
                  .toList();

              FriendsStories newElement = FriendsStories(data: newStories);

              return Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: newStories.map((e) {
                    bool allViewed = !e.stories.any(
                      (story) => story.isViewed == false,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StoryPage(
                                    index: newStories.indexOf(e),
                                    model: newElement,
                                  ),
                                ),
                              );
                            },
                            child: StoriesIconWidget(
                              profileUrl: e.userProfileUrl[0],
                              isViewed: allViewed,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${e.usersFirstName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              color: Color(0xff212121),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget userProfileIconAddStory(BuildContext context) =>
      BlocConsumer<GetMyStoriesCubit, GetMyStoriesState>(
        bloc: BlocProvider.of<GetMyStoriesCubit>(context),
        listener: (context, state) {
          if (state is GetMyStoriesError) {
            log("Error when get my stories: ${state.message}");
          }
        },
        builder: (context, state) {
          if (state is GetMyStoriesLoading) {
            return Column(
              children: [
                SizedBox(
                  height: 54,
                  width: 54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 4.h),
                const Text(
                  "Me",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    color: Color(0xff212121),
                  ),
                ),
              ],
            );
          }
          if (state is GetMyStoriesSuccess) {
            if (state.model.data.isEmpty) {
              return userCreateStoryIcon(
                avatarUrl: state.model.avatarUrl[0].preview,
              );
            }
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MyStoriesPage(
                      model: state.model,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  StoriesIconWidget(
                    profileUrl: state.model.avatarUrl[0].main,
                  ),
                  SizedBox(height: 4.h),
                  const Text(
                    "Me",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                      color: Color(0xff212121),
                    ),
                  )
                ],
              ),
            );
          }
          return userCreateStoryIcon(avatarUrl: null);
        },
      );

  Widget userCreateStoryIcon({
    required String? avatarUrl,
  }) =>
      Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                          avatarUrl,
                          width: 54,
                          height: 54,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          'assets/icons/user_icon.png',
                          width: 46,
                          height: 46,
                        ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CustomStoryEditor(),
                        ),
                      );
                    },
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            "You",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
              color: Color(0xff212121),
            ),
          )
        ],
      );
}
