import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Chat/bloc/chat_with_user/chat_with_user_bloc.dart';
import 'package:untitled/Screens/Chat/widgets/chat_audio.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/components/widgets/send_claim.dart';

import 'package:laravel_echo2/laravel_echo2.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

enum MenuAction { reply, copy, edit, delete }

class ChatWithUserScreen extends StatefulWidget {
  ChatWithUserScreen(this.chatData, this.userProfileGender, this.userProfileId,
      {super.key}) {
    bloc = ChatWithUserBloc(chatData: chatData);
  }

  ChatWithLastMessage chatData;
  final String userProfileGender;
  final int userProfileId;
  late ChatWithUserBloc bloc;

  @override
  State<ChatWithUserScreen> createState() => _ChatWithUserScreenState();
}

class _ChatWithUserScreenState extends State<ChatWithUserScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // чтобы сохранить, откуда прыгнули
  int? _lastChildIndex;
  bool _showBackButton = false;

  TextEditingController messageController = TextEditingController();
  late Echo echo_message;

  final Record _recorder = Record();
  bool isRecording = false;
  String? _recordedFilePath;
  int _recordDuration = 0;
  Timer? _timer;

  int lastMsgNmb = 0;

  connectToSocket() async {
    debugPrint("Try to server connect");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";
    try {
      echo_message = Echo({
        'broadcaster': 'socket.io',
        'host': 'https://www.nikahtime.ru:6002',
        'auth': {
          'headers': {'Authorization': 'Bearer $accessToken'}
        }
      });
      echo_message
          .private('chats.${prefs.getInt("userId") ?? ""}')!
          .listen("NewChatMessage", (e) => {SocketEvent(e)});
      //echo_message.connector.socket!
      //    .onConnect((_) => print('connected from chatlist'));
      //echo_message.connector.socket!.onDisconnect((_) => print('disconnected'));
    } catch (e) {
      //print(e.toString());
      return;
    }
  }

  void SocketEvent(dynamic e) {
    if (mounted == false) {
      return;
    }
    debugPrint("LastMsg $lastMsgNmb, messageId ${e["messageId"]}");
    if (e["chatId"] == null || e["chatId"] != widget.chatData.chatId) {
      return;
    }
    if (e["type"] == "Новое сообщение") {
      lastMsgNmb = e["messageId"];
      widget.bloc.add(NewMessage(messageId: lastMsgNmb));
    }
    if (e["type"] == "Прочитано") {
      debugPrint("aedaedaed");

      widget.bloc.add(const ReadMessage());
    }
  }

  @override
  void initState() {
    connectToSocket();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatData);
    print(widget.userProfileGender);
    print(widget.userProfileId);
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(64.0),
          child: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: header(context, (widget.bloc.state as ChatWithUserInitial)),
            automaticallyImplyLeading: false,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                  child: BlocBuilder<ChatWithUserBloc, ChatWithUserState>(
                bloc: widget.bloc,
                builder: (context, state) {
                  return body(context, state);
                },
              )),
              if (_showBackButton)
                Positioned(
                  bottom: 100,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.expand_circle_down_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_lastChildIndex != null) {
                        _itemScrollController.scrollTo(
                          index: _lastChildIndex!,
                          duration: const Duration(milliseconds: 300),
                          alignment: 0.5,
                        );
                      }
                      setState(() {
                        _showBackButton = false;
                        _lastChildIndex = null;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget waitBox(Color color) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      child: Column(
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
      ),
    );
  }

  Widget header(BuildContext context, ChatWithUserInitial state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: GradientBoxBorder(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ]),
                    width: 2),
              ),
              child: IconButton(
                  iconSize: 18.0,
                  icon: SvgPicture.asset(
                    'assets/icons/back.svg',
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context,
                        (widget.bloc.state as ChatWithUserInitial).chatData);
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: () async {
                  UserProfileData targetUserProfile = UserProfileData();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String accessToken = prefs.getString("token") ?? "";

                  var response = await NetworkService().GetUserInfoByID(
                      accessToken,
                      (widget.bloc.state as ChatWithUserInitial)
                          .chatData!
                          .userID!);

                  if (response.statusCode != 200) {
                    return;
                  }
                  debugPrint("${response.statusCode}");
                  debugPrint("${jsonDecode(response.body)}");
                  targetUserProfile.jsonToData(jsonDecode(response.body)[0]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SingleUser(anketa: targetUserProfile),
                      )).then((_) => {setState(() {})});
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                  height: MediaQuery.of(context).size.width / 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: displayImageMiniature(
                        widget.chatData.avatar?.preview ?? "",
                        Theme.of(context).colorScheme.secondary),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.chatData.userName.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                ),
                (widget.chatData.isOnline == false)
                    ? ((widget.chatData.lastTimeOnline != null)
                        ? Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              LocaleKeys.chat_main_lastTimeOnline_prefix.tr() +
                                  getTimeValue(widget.chatData.lastTimeOnline
                                      .toString()) +
                                  LocaleKeys.chat_main_lastTimeOnline_postfix
                                      .tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              LocaleKeys.common_offline.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color.fromARGB(255, 157, 157, 157),
                              ),
                            ),
                          ))
                    : Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          LocaleKeys.common_online.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color.fromARGB(255, 157, 157, 157),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
        moreButton(context, state)
      ],
    );
  }

  Widget blockedBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            LocaleKeys.chat_blocked.tr(),
          ))
        ],
      ),
    );
  }

  Widget inputBox(ChatWithUserInitial state) {
    if (state.editBoxVisible) {
      messageController.text = state.editText;
      log("EDIT TEXT: ${state.editText}");
    }
    return SizedBox(
      child: Row(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 218, 216, 215),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: isRecording
                  ? IconButton(
                      splashRadius: 1,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _cancelRecording();
                      },
                    )
                  : IconButton(
                      splashRadius: 1,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.attach_file_outlined,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
                      onPressed: () {
                        filePicker(state);
                      },
                    )),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: SizedBox(
            height: 40,
            child: isRecording
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.fiber_manual_record,
                          color: Colors.red, size: 12),
                      const SizedBox(width: 5),
                      Text(
                        _formatDuration(_recordDuration),
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  )
                : TextField(
                    cursorColor: Colors.black,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (state.editBoxVisible) {
                            if (state.editText == messageController.text) {
                              return;
                            }
                            widget.bloc.add(
                              EditChat(
                                editText: messageController.text,
                                messageId: state.editMessageId!,
                              ),
                            );
                          } else {
                            widget.bloc.add(
                              SendTextMessage(
                                text: messageController.text,
                                chatId: widget.chatData.chatId!,
                                parentMessageId: state.answerMessageId,
                              ),
                            );
                          }
                          messageController.text = "";
                        },
                        child: SvgPicture.asset(
                          'assets/icons/send.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.none,
                        ),
                      ),
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
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    controller: messageController,
                  ),
          )),
          const SizedBox(
            width: 5,
          ),
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: GradientBoxBorder(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ]),
                    width: 2),
              ),
              child: IconButton(
                splashRadius: 1,
                padding: const EdgeInsets.all(0),
                icon: isRecording
                    ? Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ) // Send icon during recording
                    : Icon(
                        Icons.mic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                onPressed: () {
                  if (isRecording) {
                    _sendRecordingToAPI(widget.bloc, state);
                  } else {
                    _startRecording();
                  }
                },
              )),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      log("Directory: ${directory.path}");
      final filePath =
          '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
        path: filePath,
      );

      setState(() {
        isRecording = true;
        _recordedFilePath = filePath;
      });

      _startTimer();
    }
  }

  Future<void> _cancelRecording() async {
    if (isRecording) {
      var s = await _recorder.stop();

      final file = File(s!);

      if (await file.exists()) {
        await file.delete();
      }

      setState(() {
        isRecording = false;
        _timer?.cancel();
        _recordedFilePath = null; // Clear the recorded file path
      });
    }
  }

  Future<void> _sendRecordingToAPI(
      ChatWithUserBloc bloc, ChatWithUserInitial state) async {
    if (isRecording) {
      var s = await _recorder.stop();
      setState(() {
        isRecording = false;
        _timer?.cancel();
      });

      var file = File(s!);
      print('FILEEEEE : ${s}');

      // Add a slight delay to ensure state updates
      await Future.delayed(Duration(milliseconds: 300));

      setState(
        () {
          bloc.add(SendFile(
            file: file,
            fileType: "audio",
            parentMessageId: state.answerMessageId,
          ));
        },
      );

      // Optionally, refresh the UI after the file is sent
      setState(() {});
    }
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Widget body(BuildContext context, ChatWithUserState state) {
    state as ChatWithUserInitial;
    if (state.pageState == PageState.preload) {
      widget.bloc.add(
        LoadChatData(chatId: widget.chatData.chatId!),
      );
      return waitBox(Theme.of(context).colorScheme.primary);
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: chatListVisualBuilder(context, state)),
          if (state.answerBoxVisible || state.editBoxVisible)
            Row(
              children: [
                state.answerBoxVisible
                    ? Image.asset(
                        'assets/icons/bxs_share.png',
                        width: 15,
                        height: 13,
                        color: const Color(
                          0xff212121,
                        ).withOpacity(0.3),
                      )
                    : Icon(
                        Icons.edit,
                        color: const Color(
                          0xff212121,
                        ).withOpacity(0.3),
                        size: 15,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Text(
                    state.editBoxVisible ? 'Изменить: ' : 'В ответ на:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(
                        0xff212121,
                      ).withOpacity(0.3),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    state.answerBoxVisible ? state.answerText : "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      widget.bloc.add(
                        const RemoveAnswerChat(),
                      );
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: (state.chatData!.isChatBlocked != true)
                ? inputBox(state)
                : blockedBox(),
          )
        ],
      ),
    );
  }

  Widget chatListVisualBuilder(
      BuildContext context, ChatWithUserInitial state) {
    Widget list = ScrollablePositionedList.separated(
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return chatListItem(state, index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 8,
        );
      },
      itemCount: state.messages.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );

    return list;
  }

  Widget chatListItem(ChatWithUserInitial state, int index) {
    final message = state.messages[index];

    return Column(
      children: [
        dateDivider(message, index, state.messages.length - 1),
        Align(
          alignment: message.isAuthUsermessage!
              ? Alignment.topLeft
              : Alignment.topRight,
          child: GestureDetector(
            onLongPressStart: (details) {
              _showMessageMenu(details.globalPosition, message);
            },
            onTap: () {
              if (message.parent != null && message.parent!.messageId != null) {
                final parentId = message.parent!.messageId!;
                // найдём индекс родителя
                final parentIndex =
                    state.messages.indexWhere((m) => m.messageId == parentId);
                if (parentIndex != -1) {
                  // запомнить, откуда прыгнули
                  _lastChildIndex = index;
                  _itemScrollController.scrollTo(
                    index: parentIndex,
                    duration: const Duration(milliseconds: 300),
                    alignment: 0.5, // отцентрирует
                  );
                  setState(() => _showBackButton = true);
                  return;
                }
              }
              if (message.sendedError) {
                _showRetryOptions(context, message);
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                left: message.isAuthUsermessage!
                    ? MediaQuery.of(context).size.width * .2
                    : 0,
                right: message.isAuthUsermessage!
                    ? 0
                    : MediaQuery.of(context).size.width * .2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: message.isAuthUsermessage!
                    ? const Color(0xFFEBEBEB)
                    : const Color(0xFFE2F1EC),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft:
                      Radius.circular(message.isAuthUsermessage! ? 10 : 0),
                  bottomRight:
                      Radius.circular(message.isAuthUsermessage! ? 0 : 10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.answerBoxVisible
                      ? state.answerMessageId == state.messages[index].messageId
                          ? const Icon(Icons.arrow_back_sharp)
                          : message.repliedStory != null
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_sharp,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "История",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                      : SizedBox.shrink(),
                  // ваш кусок "ответ на сообщение"
                  if (message.parent != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_sharp,
                              size: 15,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              message.parent!.messageType == "text"
                                  ? message.parent!.message!.length > 50
                                      ? '${message.parent!.message!.substring(0, 50)}…'
                                      : message.parent!.message!
                                  : message.parent!.messageType == "audio"
                                      ? "Аудио"
                                      : message.parent!.messageType == "video"
                                          ? "Видео"
                                          : message.parent!.messageType ==
                                                  "file"
                                              ? "Файл"
                                              : message.parent!.messageType ==
                                                      "image"
                                                  ? "Изображение"
                                                  : "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (message.isUploading)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: LinearProgressIndicator(
                        value: message.uploadProgress,
                        minHeight: 3,
                        backgroundColor: Colors.grey.shade300,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    messageBody(message),
                  // таймштамп и статус
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${intl.DateFormat('HH:mm').format(intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(message.messageTime!).add(DateTime.now().timeZoneOffset - const Duration(hours: 3)))}  ${message.edited ?? ""}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: message.isAuthUsermessage == true,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2,
                              ),
                              message.isAuthUsermessage! && message.sendedError
                                  ? SvgPicture.asset(
                                      'assets/icons/error_sent_msg.svg',
                                      height: 16,
                                      width: 16,
                                    )
                                  : Container(
                                      child: messageStatusMark(
                                        message,
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showMessageMenu(Offset tapPosition, ChatMessage message) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final choice = await showMenu<MenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<MenuAction>>[
        const PopupMenuItem(value: MenuAction.reply, child: Text('Ответить')),
        const PopupMenuItem(value: MenuAction.copy, child: Text('Копировать')),
        if (message.isAuthUsermessage! && message.messageType == "text")
          const PopupMenuItem(value: MenuAction.edit, child: Text('Изменить')),
        if (message.isAuthUsermessage!)
          const PopupMenuItem(value: MenuAction.delete, child: Text('Удалить')),
      ],
    );

    switch (choice) {
      case MenuAction.reply:
        if (message.message != null) {
          widget.bloc.add(
            AnswerChat(
              answerText: message.messageType == "text"
                  ? message.message!
                  : message.messageType == "audio"
                      ? "Аудио"
                      : message.messageType == "video"
                          ? "Видео"
                          : message.messageType == "file"
                              ? "Файл"
                              : message.messageType == "image"
                                  ? "Изображение"
                                  : "",
              answerMessageId: message.messageId!,
            ),
          );
        }
        break;
      case MenuAction.copy:
        Clipboard.setData(ClipboardData(text: message.message ?? ""));
        break;
      case MenuAction.edit:
        if (message.message != null && message.messageId != null) {
          widget.bloc.add(
            EditChatActive(
              editText: message.message!.toString(),
              messageId: message.messageId!,
            ),
          );
        } else {
          log("this message yet not sended to server");
        }
        break;
      case MenuAction.delete:
        widget.bloc.add(DeleteChatMessageWithId(
          messageId: message.messageId!,
        ));
        break;
      case null:
        break;
    }
  }

  void _showRetryOptions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text("Отправить сообщение заново"),
              onTap: () {
                // Закрываем диалог
                Navigator.pop(context);
                // Вызываем событие повторной отправки конкретного сообщения
                widget.bloc.add(
                  RetrySendSingleMessage(
                    messageId: message.messageId!,
                  ),
                );
              },
            ),
            // Если нужно, можно добавить опцию отправки всех неотправленных:
            ListTile(
              leading: Icon(Icons.refresh_outlined),
              title: Text("Отправить все неотправленные сообщения"),
              onTap: () {
                Navigator.pop(context);
                widget.bloc.add(
                  const RetrySendAllUnsentMessages(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget messageStatusMark(ChatMessage message, Color color) {
    if (message.isMessageSend == false) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 1.0),
      );
    }
    if (message.sendedError == true) {
      return Icon(
        Icons.error,
        color: Colors.red,
        size: 16,
      );
    }
    return SvgPicture.asset(
      'assets/icons/check_mess.svg',
      color: (message.isMessageSeen == true) ? color : Colors.grey,
    );
  }

  DateTime convertData(String date) {
    return intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(date);
  }

  Widget dateDivider(ChatMessage message, int index, int maxSize) {
    DateTime currDate = convertData(message.messageTime!);
    DateTime lastDate = currDate;

    if (index == maxSize) {
      lastDate = convertData((widget.bloc.state as ChatWithUserInitial)
          .messages[index]
          .messageTime!);
    } else {
      lastDate = convertData((widget.bloc.state as ChatWithUserInitial)
          .messages[index + 1]
          .messageTime!);
    }

    if (index != maxSize &&
        (lastDate.day == currDate.day &&
            lastDate.month == currDate.month &&
            lastDate.year == currDate.year)) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(children: <Widget>[
          const Expanded(
              child: Divider(
            color: Color(0xFFDEDEDE),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${currDate.day}.${currDate.month}.${currDate.year}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Expanded(
              child: Divider(
            color: Color(0xFFDEDEDE),
          )),
        ]),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget messageBody(ChatMessage message) {
    if (message.messageType == "text") {
      return RichText(
        text: _buildTextWithLinks(message.message!),
      );
    }
    if (message.messageType == "image") {
      return SizedBox(
        height: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: displayPhotoOrVideo(context, message.message!.toString(),
              initPage: 0,
              items: <String>[message.message!.toString()],
              photoOwnerId:
                  (widget.bloc.state as ChatWithUserInitial).chatData?.userID ??
                      0),
        ),
      );
    }
    if (message.messageType == "file") {
      String idStr =
          message.message!.substring(message.message!.lastIndexOf('/') + 1);
      //debugPrint(idStr);
      if (idStr.contains(".mp4") ||
          idStr.contains(".avi") ||
          idStr.contains(".mov")) {
        /*return GestureDetector(
            onTap: () {
              try{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      message.message!,
                      photoOwnerId: (widget.bloc.state as ChatWithUserInitial).chatData?.userID ?? 0
                    ),
                  )
                );
              }catch(e){
                debugPrint(e.toString());
              }

            },
            child: Row(
              children: [
                const Icon(
                  Icons.videocam,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                    LocaleKeys.chat_video.tr() +
                        "${p.extension(message.message!)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.blue.shade500,
                      //decoration: TextDecoration.underline,
                    )),
              ],
            ));*/
        return Column(
          children: [
            SizedBox(
              height: 64,
              width: 64,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayPhotoOrVideo(
                      context, message.message!.toString(),
                      initPage: 0,
                      items: <String>[message.message!.toString()],
                      photoOwnerId: (widget.bloc.state as ChatWithUserInitial)
                              .chatData
                              ?.userID ??
                          0)),
            ),
            Row(
              children: [
                const Icon(
                  Icons.videocam,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(LocaleKeys.chat_video.tr() + p.extension(message.message!),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.blue.shade500,
                      //decoration: TextDecoration.underline,
                    )),
              ],
            )
          ],
        );
      }
      return GestureDetector(
          onTap: () => setState(() {
                try {
                  _launchInBrowser(message.message!);
                } catch (err) {
                  //print(err.toString());
                }
              }),
          child: Row(
            children: [
              const Icon(
                Icons.insert_drive_file_rounded,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(LocaleKeys.chat_file.tr() + p.extension(message.message!),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.blue.shade500,
                    //decoration: TextDecoration.underline,
                  )),
            ],
          ));
    }
    if (message.messageType == "audio") {
      String idStr = message.message!;
      return VoiceMessageView(
        url: idStr,
      );
    }

    return const Text("Ошибка загрузки сообщения");
  }

  TextSpan _buildTextWithLinks(String text) {
    final RegExp linkRegExp = RegExp(
      r'((https?:\/\/|www\.)[^"]+)',
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    int start = 0;

    text.splitMapJoin(
      linkRegExp,
      onMatch: (match) {
        final String url = match.group(0)!;
        if (start != match.start) {
          spans.add(TextSpan(text: text.substring(start, match.start)));
        }
        spans.add(
          TextSpan(
            text: url,
            style: const TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri uri =
                    Uri.parse(url.startsWith('http') ? url : 'https://$url');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
          ),
        );
        start = match.end;
        return '';
      },
      onNonMatch: (nonMatch) {
        spans.add(TextSpan(text: nonMatch));
        return '';
      },
    );

    return TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
      children: spans,
    );
  }

  // void _launchInBrowser(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   }
  // }

  Future<void> _launchInBrowser(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    /*if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );

    } else {
      throw 'Could not launch $url';
    }*/
  }

  filePicker(ChatWithUserInitial state) {
    ImagePicker picker = ImagePicker();
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(LocaleKeys.chat_bottom_img_take.tr()),
          onTap: () async {
            XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                preferredCameraDevice: CameraDevice.front);
            Navigator.pop(context);
            widget.bloc.add(SendFile(
              file: File(image!.path),
              fileType: "image",
              parentMessageId: state.answerMessageId,
            ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: Text(LocaleKeys.chat_bottom_img_get.tr()),
          onTap: () async {
            XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );
            Navigator.pop(context);
            widget.bloc.add(SendFile(
              file: File(image!.path),
              fileType: "image",
              parentMessageId: state.answerMessageId,
            ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: Text(LocaleKeys.chat_bottom_video_take.tr()),
          onTap: () async {
            XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(context);
            if (video != null) {
              widget.bloc.add(
                SendFile(
                  file: File(video.path),
                  fileType: "file",
                  parentMessageId: state.answerMessageId,
                ),
              );
            } else {
              print('Video picking canceled');
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.video_library),
          title: Text(LocaleKeys.chat_bottom_video_get.tr()),
          onTap: () async {
            XFile? video = await picker.pickVideo(
              source: ImageSource.gallery,
            );
            debugPrint(video!.path);
            Navigator.pop(context);
            widget.bloc.add(SendFile(
              file: File(video.path),
              fileType: "file",
              parentMessageId: state.answerMessageId,
            ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: Text(LocaleKeys.chat_bottom_file.tr()),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              File file = File(result.files.single.path!);
              debugPrint(result.files.single.path!);
              widget.bloc.add(SendFile(
                file: file,
                fileType: "file",
                parentMessageId: state.answerMessageId,
              ));
            } else {
              // User canceled the picker
            }

            Navigator.pop(context);
          },
        ),
      ]),
    );
  }

  Widget moreButton(BuildContext context, ChatWithUserInitial state) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ]),
            width: 2),
      ),
      child: PopupMenuButton(
          color: Colors.white,
          icon: SvgPicture.asset(
            'assets/icons/more.svg',
            color: Theme.of(context).primaryColor,
          ),
          offset: const Offset(0, 50),
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          itemBuilder: (itemContext) {
            List<PopupMenuEntry> items = [];
            if ((state.chatData!.isChatBlocked &&
                    state.chatData!.isAuthUserBlockChat) ||
                state.chatData!.isChatBlocked == false) {
              items.add(
                PopupMenuItem(
                  onTap: () async {
                    widget.bloc.add(const BlockChat());
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: ((widget.bloc.state as ChatWithUserInitial)
                                .chatData!
                                .isChatBlocked)
                            ? Text(
                                LocaleKeys.chat_unblock.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              )
                            : Text(LocaleKeys.chat_block.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      SvgPicture.asset('assets/icons/lock.svg'),
                    ],
                  ),
                ),
              );
            }
            items.addAll([
              PopupMenuItem(
                onTap: () async {
                  Future.delayed(
                      const Duration(seconds: 0),
                      () => SendClaim(
                              claimObjectId:
                                  (widget.bloc.state as ChatWithUserInitial)
                                          .chatData
                                          ?.userID ??
                                      0,
                              type: ClaimType.photo)
                          .ShowAlertDialog(context));
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(LocaleKeys.chat_report.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset('assets/icons/block.svg'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await NetworkService()
                      .chatsDeleteChatID(chatID: widget.chatData.chatId!);
                  Navigator.pop(this.context);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.chat_delete.tr(),
                        style: const TextStyle(
                            color: Color(0xFFFC3B3B),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      'assets/icons/trash.svg',
                      color: const Color(0xFFFC3B3B),
                    ),
                  ],
                ),
              ),
            ]);
            return items;
          }),
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
}
