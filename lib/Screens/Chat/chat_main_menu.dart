import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laravel_echo2/laravel_echo2.dart';

//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled/Providers/NotSeenMessagesProvider.dart';
import 'package:untitled/Screens/Chat/Stories/create/story_taking.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/stories_list.dart';
import 'package:untitled/Screens/Chat/bloc/chat_list_bloc/chat_bloc.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/Screens/Chat/chat_settings.dart';
import 'package:untitled/Screens/Chat/chat_with_user.dart';
import 'package:untitled/Screens/Payment/payment.dart' as payment;
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart' as PB;
import 'package:untitled/Screens/main_page.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/components/widgets/likeAnimation.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class ChatMainPage extends StatefulWidget {
  ChatMainPage(this.userProfileData, {super.key});

  UserProfileData userProfileData;

  @override
  State<ChatMainPage> createState() {
    return ChatMainPageState();
  }
}

class ChatMainPageState extends State<ChatMainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TextEditingController searchFieldTextController = TextEditingController();
  late ChatBloc _chatBloc;

  bool show = false;
  late Echo echo;

  connectToSocket() async {
    debugPrint("Try to server connect");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      echo = Echo({
        'broadcaster': 'socket.io',
        'host': 'https://www.nikahtime.ru:6002',
        'auth': {
          'headers': {
            'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'
          }
        }
      });
      echo
          .private('chats.${widget.userProfileData.id}')!
          .listen("NewChatMessage", (e) => {newChatMessageEvent(e)});
      //echo.connector.socket!.onConnect((_) => print('connected from chatlist'));
      //echo.connector.socket!.onDisconnect((_) => print('disconnected'));
    } catch (e) {
      //print(e.toString());
    }
  }

  void newChatMessageEvent(dynamic e) {
    debugPrint("SocketEvent ChatMainMenu" + e.toString());
    if (!mounted) return;
    if (e["type"] == "Новое сообщение") {
      _chatBloc.add(const LoadChatList());
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("init chat_main_menu");
    WidgetsBinding.instance.addObserver(this);
    connectToSocket();
    FlutterAppBadger.removeBadge();
  }

  @override
  void dispose() {
    //echo.disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  void onResume() {
    FlutterAppBadger.removeBadge();
  }

  @override
  Widget build(BuildContext context) {
    PB.ProfileInitial state =
        context.read<PB.ProfileBloc>().state as PB.ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    if (needPay) {
      return Center(child: payment.paymentStub(context));
    }

    return BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            state as ChatInitial;
            switch (state.pageState) {
              case PageState.preload:
                context.read<ChatBloc>().add(const LoadChatList());
                return waitBox(Theme.of(context).colorScheme.primary);
              case PageState.ready:
                _chatBloc = context.read<ChatBloc>();
                return mainPage(context, state);
              case PageState.error:
                return Center(
                  child: Text(
                    "Ошибка сервера",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              case PageState.hold:
              case PageState.noMoreItem:
              case PageState.loading:
                return Container();
            }
          },
        ));
  }

  Widget waitBox(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          LocaleKeys.chat_waitbox.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget mainPage(BuildContext context, ChatInitial state) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Проверяем направление свайпа (вправо)
        if (details.primaryVelocity! > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomStoryEditor()),
          );
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Builder(builder: (context) {
              if (show) {
                show = false;
                return LikeAnimationWidget(true);
              } else {
                return const SizedBox.shrink();
              }
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.chat_main_header.tr(),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: const Color.fromARGB(255, 33, 33, 33),
                  ),
                ),
                // Container(
                //   height: 36,
                //   width: 36,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       width: 1.0,
                //       color: const Color.fromARGB(255, 218, 216, 215),
                //     ),
                //     borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                //   ),
                //   child: IconButton(
                //       splashRadius: 4.0,
                //       iconSize: 18.0,
                //       padding: const EdgeInsets.all(0),
                //       icon: const Icon(
                //         Icons.settings,
                //         color: Color.fromARGB(255, 117, 116, 115),
                //       ),
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => const ChatSettings(),
                //             ));
                //       }),
                // )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(height: 90, child: StoriesList()),
            SizedBox(
                height: 40,
                child: TextField(
                  controller: searchFieldTextController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: (searchFieldTextController.text.isEmpty)
                        ? SizedBox(
                            child: SvgPicture.asset(
                              './assets/icons/search.svg',
                              height: 20,
                              width: 20,
                              fit: BoxFit.none,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              searchFieldTextController.text = "";
                              context
                                  .read<ChatBloc>()
                                  .add(const SearchChat(searchString: ""));
                            },
                            icon: const Icon(Icons.close)),
                    hintText: LocaleKeys.chat_main_find.tr(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 218, 216, 215),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    context
                        .read<ChatBloc>()
                        .add(SearchChat(searchString: value));
                  },
                )),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: chatListVisualBuilder(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatListVisualBuilder(BuildContext context, ChatInitial state) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        if (searchFieldTextController.text == "") {
          return chatListItem(context, state.allChatsList[index]);
        } else {
          return chatListItem(context, state.searcedUser[index]);
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
            height: 25, thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.12));
      },
      itemCount: (searchFieldTextController.text == "")
          ? state.allChatsList.length
          : state.searcedUser.length,
    );
  }

  Widget chatListItem(BuildContext context, ChatWithLastMessage chatInfo) {
    getTimeValue(chatInfo.lastMessageTime.toString());
    return GestureDetector(
      onLongPress: () {
        _showAlertDialog(context, chatInfo.chatId!);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatWithUserScreen(
                chatInfo,
                widget.userProfileData.gender ?? "",
                widget.userProfileData.id ?? 0),
          ),
        ).then((_) {
          context.read<ChatBloc>().add(const LoadChatList());
          final provider =
              Provider.of<NotSeenMessagesProvider>(context, listen: false);
          provider.GetNumberNotSeenMessagesFromServer(
              widget.userProfileData.accessToken.toString());
        });
      },
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: displayImageMiniature(
                    chatInfo.avatar?.preview ?? "",
                    Theme.of(context).colorScheme.secondary,
                    //chatInfo.userAvatar.toString()
                  ),
                ),
              ),
              Visibility(
                visible: chatInfo.isOnline == true,
                child: Positioned(
                  bottom: -3,
                  right: -3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Container(
                      width: 18,
                      height: 18,
                      color: Colors.white,
                      child: Center(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90.0),
                            child: Container(
                              color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chatInfo.userName.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      (chatInfo.isAuthUserMessage)
                          ? LocaleKeys.chat_main_you.tr()
                          : "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: (chatInfo.lastMessageType != "text")
                            ? const Color.fromARGB(180, 0, 0, 255)
                            : const Color.fromARGB(180, 33, 33, 33),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      lastMessageField(chatInfo),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: (chatInfo.lastMessageType != "text")
                            ? const Color.fromARGB(180, 0, 0, 255)
                            : const Color.fromARGB(180, 33, 33, 33),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  right: 16,
                  top: 16,
                ),
                child: Text(
                  getTimeValue(chatInfo.lastMessageTime.toString()),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: const Color.fromARGB(255, 157, 157, 157),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: (chatInfo.numberNotSeenMessages! > 0)
                    ? Container(
                        //padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        width: 12,
                        height: 12,
                        child: Center(
                          child: Text(
                            '${chatInfo.numberNotSeenMessages!}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : null,
              )
            ],
          )
        ],
      ),
    );
  }

  String getTimeValue(String str) {
    DateTime messageDt;
    try {
      messageDt = intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(str);
      debugPrint(DateTime.now().timeZoneOffset.toString());

      Duration defaultOffset = const Duration(hours: 3);

      messageDt = messageDt.add(DateTime.now().timeZoneOffset - defaultOffset);
    } catch (on) {
      return "";
    }
    String timeValue = "";

    int value = DateTime.now().difference(messageDt).inMinutes.abs();
    timeValue = LocaleKeys.chat_main_min.tr();
    if (value > 59) {
      timeValue = LocaleKeys.chat_main_hour.tr();
      value = DateTime.now().difference(messageDt).inHours.abs();
      if (value > 24) {
        timeValue = LocaleKeys.chat_main_day.tr();
        value = DateTime.now().difference(messageDt).inDays.abs();
      }
    }
    String result;
    if (value == 0) {
      result = LocaleKeys.chat_main_now.tr();
    } else {
      result = "$value $timeValue";
    }

    return result;
  }

  String lastMessageField(ChatWithLastMessage chatInfo) {
    if (chatInfo.lastMessageType == "text") {
      return chatInfo.lastMessage.toString();
    }
    if (chatInfo.lastMessageType == "file") {
      return LocaleKeys.chat_file.tr();
    }
    if (chatInfo.lastMessageType == "image") {
      return LocaleKeys.chat_img.tr();
    }
    if (chatInfo.lastMessageType == "video") {
      return LocaleKeys.chat_video.tr();
    }
    return "";
  }

  _showAlertDialog(BuildContext context, int chatID) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.chat_del_cancel.tr()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = TextButton(
      child: Text(LocaleKeys.chat_del_confirm.tr()),
      onPressed: () async {
        context.read<ChatBloc>().add(DeleteChat(chatId: chatID));
        //MyTracker.trackEvent("Delete chat from main chat page", {});
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.chat_del_header.tr()),
      content: Text(LocaleKeys.chat_del_msg.tr()),
      actions: [cancelButton, confirmButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
