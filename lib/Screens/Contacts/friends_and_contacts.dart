import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Contacts/contacts_screen.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_followers/fetch_followers_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_friends/fetch_friends_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_registered_contacts/fetch_registered_contacts_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/move_follower_to_friends/follower_to_friend_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/move_friend_to_follower/friend_to_follower_cubit.dart';
import 'package:untitled/Screens/Contacts/models/contacts.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/components/widgets/create_chat.dart';

import 'models/friends_profile.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool showFriends = true;

  bool visibilityFollowers = false;

  bool searchIsActive = false;

  List<RegisteredContacts> registeredContacts = [];

  FriendsProfile? friendsProfile;

  @override
  void initState() {
    BlocProvider.of<FetchRegisteredContactsCubit>(context)
        .getRegisteredContacts();
    BlocProvider.of<FetchFollowersCubit>(context).getFollowersList();
    BlocProvider.of<FetchFriendsCubit>(context).getFriendsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: searchIsActive
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  if (showFriends) {
                    if (friendsProfile != null) {
                      BlocProvider.of<FetchFriendsCubit>(context)
                          .searchRegisteredContacts(
                              searchQuery: value,
                              friendsProfile: friendsProfile!);
                    }
                  } else {
                    if (registeredContacts.isNotEmpty) {
                      BlocProvider.of<FetchRegisteredContactsCubit>(context)
                          .searchRegisteredContacts(
                              searchQuery: value,
                              registeredContacts: registeredContacts);
                    }
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Введите имя...",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              )
            : Text(
                "Контакты",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
        actions: searchIsActive
            ? [
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    searchIsActive = false;
                    if (registeredContacts.isNotEmpty) {
                      BlocProvider.of<FetchRegisteredContactsCubit>(context)
                          .backToFullContacts(
                              registeredContacts: registeredContacts);
                    }
                    if (friendsProfile != null) {
                      BlocProvider.of<FetchFriendsCubit>(context)
                          .backToFullContacts(friendsProfile: friendsProfile!);
                    }

                    setState(() {});
                  },
                )
              ]
            : [
                _buildIconButton('assets/icons/plus.svg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvitePage()),
                  );
                }),
                // SizedBox(width: 10),
                // _buildIconButton('assets/icons/filter.svg', () {}),
                SizedBox(width: 10),
                _buildIconButton('assets/icons/search.svg', () {
                  searchIsActive = true;
                  setState(() {});
                }),
                SizedBox(width: 16),
              ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              Expanded(
                child: _buildToggleButton(
                  "Ваши приятели",
                  isActive: showFriends,
                  onPressed: () {
                    setState(() {
                      showFriends = true;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildToggleButton(
                  "Ваши контакты",
                  isActive: !showFriends,
                  onPressed: () {
                    setState(() {
                      showFriends = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (showFriends)
                    Column(
                      children: [
                        _buildFollowerRequest(),
                        SizedBox(
                          height: 30,
                        ),
                        BlocConsumer<FriendToFollowerCubit,
                            FriendToFollowerState>(
                          bloc: BlocProvider.of<FriendToFollowerCubit>(context),
                          listener: (context, state) {
                            if (state is FriendToFollowerError) {
                              log("ERROR: ${state.message}");
                            }
                            if (state is FriendToFollowerSuccess) {
                              log("Success");
                              BlocProvider.of<FetchFriendsCubit>(context)
                                  .getFriendsList();
                              BlocProvider.of<FetchFollowersCubit>(context)
                                  .getFollowersList();
                            }
                          },
                          builder: (context, state) {
                            return BlocConsumer<FetchFriendsCubit,
                                FetchFriendsState>(
                              bloc: BlocProvider.of<FetchFriendsCubit>(context),
                              listener: (context, state) {
                                if (state is FetchFriendsError) {
                                  log("ERROR: ${state.message}");
                                }
                              },
                              builder: (context, state) {
                                if (state is FetchFriendsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (state is FetchFriendsSuccess) {
                                  friendsProfile = state.friendsProfile;
                                  List<Datum> filteredData =
                                      state.friendsProfile.friends!.data;
                                  if (state.searchWord != null) {
                                    filteredData = state
                                            .friendsProfile.friends?.data
                                            .where((datum) {
                                          final firstName = datum
                                                  .prof?.firstName
                                                  ?.toLowerCase() ??
                                              "";
                                          final lastName = datum.prof?.lastName
                                                  ?.toLowerCase() ??
                                              "";
                                          final searchQuery =
                                              state.searchWord!.toLowerCase();

                                          return firstName
                                                  .contains(searchQuery) ||
                                              lastName.contains(searchQuery);
                                        }).toList() ??
                                        [];
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: state.searchWord == null
                                        ? state
                                            .friendsProfile.friends!.data.length
                                        : filteredData.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 0),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: 66,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xFFDEDEDE))),
                                        ),
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onLongPress: () {
                                            showMoveFriendToFollowersAlert(
                                              state.searchWord == null
                                                  ? state
                                                      .friendsProfile
                                                      .friends!
                                                      .data[index]
                                                      .userId!
                                                  : filteredData[index].userId!,
                                            );
                                          },
                                          onTap: () async {
                                            goToUserProfile(
                                              context: context,
                                              id: state.searchWord == null
                                                  ? state
                                                      .friendsProfile
                                                      .friends!
                                                      .data[index]
                                                      .userId!
                                                  : filteredData[index].userId!,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  state.searchWord == null
                                                      ? state
                                                          .friendsProfile
                                                          .friends!
                                                          .data[index]
                                                          .prof!
                                                          .images
                                                          .first
                                                          .main!
                                                      : filteredData[index]
                                                          .prof!
                                                          .images
                                                          .first
                                                          .main!,
                                                ),
                                                radius: 24,
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state.searchWord == null
                                                          ? state
                                                              .friendsProfile
                                                              .friends!
                                                              .data[index]
                                                              .prof!
                                                              .firstName!
                                                          : filteredData[index]
                                                              .prof!
                                                              .firstName!,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      state.searchWord == null
                                                          ? state
                                                              .friendsProfile
                                                              .friends!
                                                              .data[index]
                                                              .prof!
                                                              .lastName!
                                                          : filteredData[index]
                                                              .prof!
                                                              .lastName!,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF111111),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _buildChatButton(
                                                id: state.searchWord == null
                                                    ? state
                                                            .friendsProfile
                                                            .friends!
                                                            .data[index]
                                                            .userId ??
                                                        0
                                                    : filteredData[index]
                                                            .userId ??
                                                        0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            );
                          },
                        )
                      ],
                    )
                  else
                    _buildUserList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String icon, void Function()? onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ]),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void showMoveFriendToFollowersAlert(
    int id,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Вы уверены, что хотите убрать из приятелей этого пользователя?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xff212121),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Оставить",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<FriendToFollowerCubit>(context)
                    .moveFriendToFollower(id: id);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 11.5, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Text(
                  "Удалить",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(String label,
      {required bool isActive, required VoidCallback onPressed}) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ])
            : null,
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ]),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowerRequest() {
    return BlocListener<FollowerToFriendCubit, FollowerToFriendState>(
      bloc: BlocProvider.of<FollowerToFriendCubit>(context),
      listener: (context, state) {
        if (state is FollowerToFriendError) {
          log("errror: ${state.message}");
        }
        if (state is FollowerToFriendSuccess) {
          BlocProvider.of<FetchFollowersCubit>(context).getFollowersList();
          BlocProvider.of<FetchFriendsCubit>(context).getFriendsList();
        }
      },
      child: BlocConsumer<FetchFollowersCubit, FetchFollowersState>(
        bloc: BlocProvider.of<FetchFollowersCubit>(context),
        listener: (context, state) {
          if (state is FetchFollowersError) {
            log("Error: ${state.message}");
          }
        },
        builder: (context, state) {
          if (state is FetchFollowersSuccess) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF26262614).withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 16,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Заявки в приятели',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              state.followersProfiles.followers!.data.length
                                  .toString(),
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.w400,
                                height: 1.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildToggleButton(
                        visibilityFollowers ? 'Скрыть' : 'Показать все',
                        isActive: false,
                        onPressed: () {
                          visibilityFollowers = !visibilityFollowers;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: !visibilityFollowers,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            state.followersProfiles.followers!.data.first.prof!
                                .images.first.main!,
                          ),
                          radius: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${state.followersProfiles.followers!.data.first.prof!.firstName!} ${state.followersProfiles.followers!.data.first.prof!.lastName!}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                "хочет стать вашим приятелем",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        _buildFriendActionButton(
                            'assets/icons/close.svg', () {}),
                        SizedBox(width: 8),
                        _buildFriendActionButton('assets/icons/check.svg', () {
                          BlocProvider.of<FollowerToFriendCubit>(context)
                              .moveFollowerToFriend(
                            id: state.followersProfiles.followers!.data.first
                                .userId!,
                          );
                        }),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: visibilityFollowers,
                      child: Column(
                        children: state.followersProfiles.followers!.data
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        e.prof!.images.first.main!,
                                      ),
                                      radius: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${e.prof!.firstName!} ${e.prof!.lastName!}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "хочет стать вашим приятелем",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildFriendActionButton(
                                        'assets/icons/close.svg', () {}),
                                    SizedBox(width: 8),
                                    _buildFriendActionButton(
                                        'assets/icons/check.svg', () {
                                      BlocProvider.of<FollowerToFriendCubit>(
                                              context)
                                          .moveFollowerToFriend(
                                        id: e.userId!,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      )),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFriendActionButton(String icon, Function() onPress) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ]),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: SvgPicture.asset(icon, color: Theme.of(context).primaryColor),
        color: Theme.of(context).colorScheme.primary,
        onPressed: onPress,
      ),
    );
  }

  Widget _buildUserList() {
    return BlocBuilder<FetchRegisteredContactsCubit,
        FetchRegisteredContactsState>(
      bloc: BlocProvider.of<FetchRegisteredContactsCubit>(context),
      builder: (context, state) {
        if (state is FetchRegisteredContactsError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          );
        }
        if (state is FetchRegisteredContactsLoading) {
          return Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is FetchRegisteredContactsSuccess) {
          registeredContacts = state.registeredContacts;
          List<RegisteredContacts> contacts = [];
          if (state.searchWord != null) {
            contacts = state.registeredContacts.where((contact) {
              final nameLower = (contact.name ?? "").toLowerCase();
              return nameLower.contains(state.searchWord!.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.searchWord == null
                ? state.registeredContacts.length
                : contacts.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 0),
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 66,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(bottom: BorderSide(color: Color(0xFFDEDEDE))),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    goToUserProfile(
                      context: context,
                      id: state.searchWord == null
                          ? state.registeredContacts[index].id!
                          : contacts[index].id!,
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          state.searchWord == null
                              ? state.registeredContacts[index].profilePhoto
                                  .first.main!
                              : contacts[index].profilePhoto.first.main!,
                        ),
                        radius: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.searchWord == null
                                  ? state.registeredContacts[index].name!
                                  : contacts[index].name!,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            Text(
                              state.registeredContacts[index].phoneNumber!,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      _buildChatButton(
                        id: state.searchWord == null
                            ? state.registeredContacts[index].id ?? 0
                            : contacts[index].id ?? 0,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: TextButton(
            onPressed: () {
              BlocProvider.of<FetchRegisteredContactsCubit>(context)
                  .getRegisteredContacts();
            },
            child: Text(
              "Repeat again",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatButton({
    required int id,
  }) {
    return InkWell(
      onTap: () {
        log("ASDASDasdasdasdS");
        debugPrint("Начать чат с пользователем № $id");
        CreateChat(context, "", id, afterPopCallback: (chatWithLastMessage) {
          setState(() {});
        }).createChatWithUser(
          id,
        );
      },
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ]),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/chat.svg',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

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

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleUser(anketa: targetUserProfile),
        )).then((_) => {setState(() {})});
  }
}
