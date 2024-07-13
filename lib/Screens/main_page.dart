import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:laravel_echo2/laravel_echo2.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:untitled/Screens/Chat/chat_main_menu.dart';
import 'package:untitled/Screens/News/Feed/news.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Profile/profile_main_page.dart';
import 'package:untitled/Screens/Favorites/favorites_main.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/components/widgets/likeAnimation.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:untitled/Providers/NotSeenMessagesProvider.dart';
import 'package:untitled/main_page_custom_icon_icons.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import 'Friends/friends_page.dart';

/// This is the stateful widget that the main application instantiates.
class MainPage extends StatefulWidget {
  const MainPage(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<MainPage> createState() => MainPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 2;
  int numberNotSeenMessages = 0;

  Widget _childItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        return NewsScreen();
      case 1:
        return FavoriteMainPageScreen(widget.userProfileData);
      case 2:
        return FriendsPage(widget.userProfileData);
      case 3:
        return AnketesFeedScreen(widget.userProfileData);
      case 4:
        return ChatMainPage(widget.userProfileData);
      case 5:
        return ProfileMainPageScreen(widget.userProfileData);
    }

    return const Text(
      'ERROR',
    );
  }

  late NotSeenMessagesProvider provider;
  late Echo echo;
  bool show = false;

  connectToSocket(BuildContext context) async {
    debugPrint("Try to server connect");
    try {
      echo = Echo({
        'broadcaster': 'socket.io',
        'host': 'https://www.nikahtime.ru:6002',
        'auth': {
          'headers': {
            'Authorization':
                'Bearer ${widget.userProfileData.accessToken.toString()}'
          }
        }
      });
      echo
          .private('mutual-likes.${widget.userProfileData.id}')!
          .listen("MutualLike", (e) => {likeAnimation(context, e)});
      echo
          .private('chats.${widget.userProfileData.id}')!
          .listen("NewChatMessage", (e) => {socketEvent(context, e)});
      echo.connector.socket!
          .onConnect((_) => debugPrint('connected from chatlist'));
      echo.connector.socket!.onDisconnect((_) => debugPrint('disconnected'));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void likeAnimation(BuildContext context, dynamic e) async {
    debugPrint("MutualLike1 ${DateTime.now()}$e");
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("inDepth") == true) {
      return;
    }

    setState(() {
      show = true;
    });
  }

  void socketEvent(BuildContext context, dynamic e) {
    debugPrint("NewMessage$e");
    if (!mounted) return;
    if (e["type"] == "Новое сообщение") {
      final provider =
          Provider.of<NotSeenMessagesProvider>(context, listen: false);
      provider.GetNumberNotSeenMessagesFromServer(
          widget.userProfileData.accessToken.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initTracker();
  }

  initTracker() async {
    await MyTracker.flush();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(const LoadProfileDataEvent());

    return ChangeNotifierProvider<NotSeenMessagesProvider>(
        create: (context) => NotSeenMessagesProvider(),
        builder: (context, child) {
          connectToSocket(context);
          return body(context);
        });
  }

  Widget body(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => NewsBloc(),
                ),
              ],
              child: Center(
                child: _childItem(context, _selectedIndex),
              )),
          (show)
              ? Builder(builder: (context) {
                  show = false;
                  return Center(
                    child: LikeAnimationWidget(true),
                  );
                })
              : const SizedBox.shrink()
        ],
      ),
      bottomNavigationBar: Builder(builder: (context) {
        provider = Provider.of<NotSeenMessagesProvider>(context);
        provider.GetNumberNotSeenMessagesFromServer(
            widget.userProfileData.accessToken.toString());
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(-1, -1), // changes position of shadow
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 42),
              color: Color(0xfffef8ff),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 0
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 1
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 2
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 3
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 4
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    height: 4,
                    color: _selectedIndex == 5
                        ? Color(0xff00CF90)
                        : Color(0xfffef8ff),
                  ),
                ],
              ),
            ),
            BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              //enableFeedback: false,
              iconSize: 24,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8.3,
                    child: Image.asset(
                      _selectedIndex == 0
                          ? 'assets/icons/barGreen1.png'
                          : 'assets/icons/bar1.png',
                      width: 26,
                    ),
                  ),
                  label: LocaleKeys.usersScreen_tittle.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    child: Center(
                      child: Image.asset(
                        _selectedIndex == 1
                            ? 'assets/icons/barGreen2.png'
                            : 'assets/icons/bar2.png',
                        width: 30,
                      ),
                    ),
                  ),
                  label: LocaleKeys.usersScreen_tittle.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 2
                          ? 'assets/icons/barGreen3.png'
                          : 'assets/icons/bar3.png',
                      width: 30,
                    ),
                  ),
                  label: LocaleKeys.usersScreen_tittle.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 3
                          ? 'assets/icons/barGreen4.png'
                          : 'assets/icons/bar4.png',
                      width: 22,
                    ),
                  ),
                  label: LocaleKeys.usersScreen_tittle.tr(),
                ),
                BottomNavigationBarItem(
                  icon: provider.numberNotSeenMessages != null &&
                          provider.numberNotSeenMessages != '0'
                      ? Stack(
                          alignment: Alignment.topRight,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              color: Colors.amber,
                              width: MediaQuery.of(context).size.width / 8.3,
                              alignment: Alignment.center,
                              child: Image.asset(
                                _selectedIndex == 4
                                    ? 'assets/icons/barGreen5.png'
                                    : 'assets/icons/bar5.png',
                                width: 30,
                                color: _selectedIndex == 4
                                    ? const Color(0xff00CF90)
                                    : null,
                              ),
                            ),
                            Positioned(
                              top: -3,
                              right: -3,
                              child: SizedBox(
                                width: 15,
                                height: 15,
                                child: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0xcf, 0x91, 1),
                                  child: Text(
                                    int.parse(provider.numberNotSeenMessages) >
                                            9
                                        ? '9+'
                                        : '${provider.numberNotSeenMessages}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 9),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : const Icon(MainPageCustomIcon.message),
                  label: LocaleKeys.chat_main_header.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: MediaQuery.of(context).size.width / 8.3,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 5
                          ? 'assets/icons/barGreen6.png'
                          : 'assets/icons/bar6.png',
                      width: 28,
                    ),
                  ),
                  label: LocaleKeys.usersScreen_tittle.tr(),
                ),
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: const Color.fromRGBO(0, 0, 0, 0.38),
              selectedItemColor: const Color.fromRGBO(0, 0xcf, 0x91, 1),
              onTap: _onItemTapped,
            ),
          ],
        );
      }),
    );
  }
}
