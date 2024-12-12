part of '../anketes.dart';

class SingleUser extends StatefulWidget {
  SingleUser({this.anketa, this.targetUserId});

  UserProfileData? anketa;
  int? targetUserId;

  @override
  State<SingleUser> createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  bool show = false;
  late Echo echo;

  connectToSocket() async {
    debugPrint("Try to server connect");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";
    prefs.setBool("inDepth", true);
    try {
      echo = Echo({
        'broadcaster': 'socket.io',
        'host': 'https://www.nikahtime.ru:6002',
        'auth': {
          'headers': {'Authorization': 'Bearer $accessToken'}
        }
      });
      echo
          .private('mutual-likes.${prefs.getInt("userId") ?? 0}')!
          .listen("MutualLike", (e) => {likeAnimation(e)});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void likeAnimation(dynamic e) async {
    debugPrint("MutualLike2 " + DateTime.now().toString() + e.toString());
    if (mounted) {
      setState(() {
        show = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SendFriendsRequestCubit>(context).initialize();
    connectToSocket();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  disconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("inDepth", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, widget.anketa!.inFavourite);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary
                          ]),
                          width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: SvgPicture.asset(
                    'assets/icons/back.svg',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          )),
      body: FutureBuilder(
        future: loadUserData(targetUserId: widget.targetUserId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data as UserProfileData).id == null) {
              return const Center(
                  child: Text("Ошибка загрузки страницы пользователя"));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  loadedBody(context: context, targetUserData: snapshot.data),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<UserProfileData?> loadUserData({required int? targetUserId}) async {
    if (widget.anketa != null) return widget.anketa!;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserProfileData data = UserProfileData();

    var response = await NetworkService()
        .GetUserInfoByID(prefs.getString("token") ?? "", targetUserId ?? 0);

    if (response == null || response.statusCode != 200) {
      return UserProfileData();
    }

    debugPrint("${response.statusCode}");
    debugPrint("${jsonDecode(response.body)}");
    data.jsonToData(jsonDecode(response.body)[0]);

    widget.anketa = data;

    return data;
  }

  int swipeIndex = 0;

  Widget loadedBody(
      {required BuildContext context,
      required UserProfileData targetUserData}) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    return Stack(
      children: [
        SingleChildScrollView(
          child: userCardExpanded(targetUserData),
        ),
        (show)
            ? Center(
                child: LikeAnimationWidget(true),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget userCardExpanded(UserProfileData item) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    /// TODO need to change to inFriends
    if (item.isFriend!) {
      BlocProvider.of<SendFriendsRequestCubit>(context).alreadyFriends();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Контейнер для изображения и кнопок
        Container(
          height: MediaQuery.of(context).size.height / 1.9,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            color: Color.fromARGB(255, 236, 235, 235),
          ),
          child: Stack(
            children: [
              // Изображение или видео профиля
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Color.fromARGB(255, 236, 235, 235),
                  ),
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: (item.photos != null && item.photos!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: displayPhotoOrVideo(
                            context,
                            item.images![0].main.toString(),
                            items: item.images!
                                .map((e) => e.main)
                                .toList()
                                .cast<String>(),
                            initPage: 0,
                            photoOwnerId: item.id,
                          ),
                        )
                      : const Icon(
                          Icons.photo_camera,
                          color: Color.fromRGBO(230, 230, 230, 1),
                          size: 60,
                        ),
                ),
              ),

              // Чип с "выбран для вас"
              Positioned(
                right: 16,
                top: 16,
                child: Visibility(
                  visible: (item.isProfileParametersMatched != null &&
                          item.isProfileParametersMatched == true)
                      ? true
                      : false,
                  child: SvgPicture.asset('assets/icons/offer.svg'),
                ),
              ),

              // Контейнер с информацией о пользователе
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ), //BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    width: double
                        .infinity, //MediaQuery.of(context).size.width / 1.5,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff12121200), Color(0xff12121280)],
                          stops: [0.0, 1.0],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.firstName ?? ""}, ${item.age} " "",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.city != null ? item.city!.split(',')[0] : '',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Кнопки в правом нижнем углу
              Positioned(
                bottom: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (needPay) {
                          await showPaymentDialog(context,
                              text: LocaleKeys
                                  .common_payment_alert_titleForAction
                                  .tr());
                          return;
                        }
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        CreateChat(
                            this.context,
                            prefs.getString("userGender") ?? "",
                            prefs.getInt("userId") ?? 0,
                            afterPopCallback: (chatWithLastMessage) {
                          setState(() {
                            widget.anketa!.isBlocked =
                                chatWithLastMessage.isChatBlocked;
                          });
                        }).createChatWithUser(item.id!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary
                              ]),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/chat.svg',
                          color: Colors.white,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocConsumer<SendFriendsRequestCubit,
                        SendFriendsRequestState>(
                      bloc: BlocProvider.of<SendFriendsRequestCubit>(context),
                      listener: (context, state) {
                        if (state is SendFriendsRequestSuccess) {}
                        if (state is SendFriendsRequestError) {
                          debugPrint("ERROR: ${state.message}");
                          BlocProvider.of<SendFriendsRequestCubit>(context)
                              .initialize();
                        }
                      },
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            if (needPay) {
                              showPaymentDialog(context,
                                  text: LocaleKeys
                                      .common_payment_alert_titleForAction
                                      .tr());
                              return;
                            }
                            if (state is SendFriendsRequestInitial) {
                              BlocProvider.of<SendFriendsRequestCubit>(context)
                                  .sendRequest(userId: item.id!);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary
                                    ],
                                  ),
                                  width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: state is SendFriendsRequestLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  )
                                : state is SendFriendsRequestSuccess
                                    ? SvgPicture.asset(
                                        'assets/icons/check_icon.svg',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        height: 20,
                                        width: 20,
                                      )
                                    : SvgPicture.asset(
                                        'assets/icons/add_user_icon.svg',
                                        color: Colors.white,
                                        height: 20,
                                        width: 20,
                                      ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        if (needPay) {
                          await showPaymentDialog(context,
                              text: LocaleKeys
                                  .common_payment_alert_titleForAction
                                  .tr());
                          return;
                        }
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (item.inFavourite == false) {
                          setState(() {
                            show = true;
                          });
                        } else {
                          show = false;
                        }

                        var response = await NetworkService()
                            .FavoritesAddUserID(
                                prefs.getString("token") ?? "", item.id ?? 0);
                        if (response.statusCode == 202) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => CrossMatch(
                                  item,
                                  prefs.getInt("userId") ?? 0,
                                  prefs.getString("userGender") ?? ""),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                          );
                        }
                        item.inFavourite = !item.inFavourite;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary
                              ]),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          MenuIcons.favorite,
                          color: item.inFavourite
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /*Positioned(
                right: 16,
                top: (item.isProfileParametersMatched != null &&
                    item.isProfileParametersMatched == true)
                    ? 60
                    : 16,
                child: Chip(
                  labelPadding: const EdgeInsets.all(2.0),
                  avatar: (item.isOnline!)
                      ? const Icon(
                    Icons.circle,
                    color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                    size: 14,
                  )
                      : null,
                  label: Text(
                    (item.isOnline!) ? LocaleKeys.common_online.tr() : LocaleKeys.common_offline.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      //color: const Color.fromARGB(255,33,33,33),
                    ),
                  ),
                  elevation: 2.0,
                  padding: const EdgeInsets.all(8.0),
                  backgroundColor:
                  const Color.fromARGB(255, 246, 255, 237),
                ),
              ),*/

              // Positioned(
              //   right: 0,
              //   bottom: 16,
              //   child: PopupMenuButton(
              //       icon: const Icon(
              //         Icons.more_vert,
              //         color: Colors.white,
              //       ),
              //       //offset: const Offset(0, 50),
              //       shape: const OutlineInputBorder(
              //         borderSide:
              //         BorderSide(color: Colors.white, width: 2),
              //         borderRadius:
              //         BorderRadius.all(Radius.circular(10)),
              //       ),
              //       itemBuilder: (context) => [
              //         PopupMenuItem(
              //           onTap: () {
              //             Future.delayed(
              //                 const Duration(seconds: 0),
              //                     () => SendClaim(
              //                     claimObjectId: item.id!,
              //                     type: ClaimType.photo
              //                 ).ShowAlertDialog(this.context)
              //             );
              //           },
              //           child: Row(
              //             children: [
              //               const Icon(Icons.block),
              //               const SizedBox(
              //                 width: 16,
              //               ),
              //               Expanded(
              //                   child: Text(
              //                     LocaleKeys.claim_toReport.tr(),
              //                   ))
              //             ],
              //           ),
              //         ),
              //         PopupMenuItem(
              //           onTap: () {
              //             if (item.isBlocked) {
              //               unblockUser(item);
              //             } else {
              //               blockUser(item);
              //             }
              //           },
              //           child: Row(
              //             children: [
              //               const Icon(Icons.lock_rounded),
              //               const SizedBox(
              //                 width: 16,
              //               ),
              //               Expanded(
              //                   child: Container(
              //                     child: item.isBlocked
              //                         ? const Text(
              //                       LocaleKeys.chat_unblock,
              //                     ).tr()
              //                         : const Text(
              //                       LocaleKeys.chat_block,
              //                     ).tr(),
              //                   )
              //               )
              //             ],
              //           ),
              //         ),
              //       ]),
              // )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomInputDecoration()
            .anketasHeaderName(LocaleKeys.user_interests.tr()),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: item.interests!.isNotEmpty
              ? Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.start,
                  children: makeChipsArray(item.interests!),
                )
              : const Text(
                  '-',
                  style: TextStyle(color: Colors.black),
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_nationality.tr(),
            GlobalStrings.translateNationalityFromRu(
                context, item.nationality)),
        CustomInputDecoration()
            .anketesTextItem(LocaleKeys.user_aboutMe.tr(), item.about),
        CustomInputDecoration().anketesTextItem(LocaleKeys.user_education.tr(),
            educationList['${item.education}']?.tr()),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_placeOfStudy.tr(), item.placeOfStudy),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_placeOfWork.tr(), item.placeOfWork),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_workPosition.tr(), item.workPosition),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_maritalStatus.tr(),
            familyState["${item.maritalStatus}"]?.tr()),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_haveChildren_title.tr(),
            (item.haveChildren == true)
                ? LocaleKeys.childrenState_yes.tr()
                : LocaleKeys.childrenState_no.tr()),
        CustomInputDecoration().anketesTextItem(LocaleKeys.user_faith.tr(),
            faithState['${item.typeReligion}']?.tr()),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_canons.tr(),
            item.gender == "male"
                ? observantOfTheCanonsMaleState['${item.observeIslamCanons}']
                    ?.tr()
                : observantOfTheCanonsFemaleState['${item.observeIslamCanons}']
                    ?.tr()),
        CustomInputDecoration().anketesTextItem(
            LocaleKeys.user_badHabits.tr(), parseBadHabits(item)),
        Visibility(
          visible: (item.photos!.length > 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputDecoration()
                  .anketasHeaderName(LocaleKeys.user_photos.tr()),
              const SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Color.fromARGB(255, 236, 235, 235),
                        ),
                        width: 120,
                        child: (item.images!.length > index + 1)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: displayPhotoOrVideo(this.context,
                                    item.images![index + 1].preview.toString(),
                                    items: item.images!
                                        .map((e) => e.main)
                                        .toList()
                                        .cast<String>(),
                                    initPage: index + 1,
                                    photoOwnerId: item.id),
                              )
                            : const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 60,
                              ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: (item.images?.length ?? 1) - 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  void blockUser(UserProfileData item) async {
    try {
      await NetworkService().blockUser(userId: item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      item.isBlocked = true;
      item.inFavourite = false;
      show = false;
    });
  }

  void unblockUser(UserProfileData item) async {
    try {
      await NetworkService().unblockUser(userId: item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      item.isBlocked = false;
      show = false;
    });
  }

  List<Widget> makeChipsArray(List<String> items) {
    List<Widget> chips = [];
    for (int i = 0; i < items.length; i++) {
      Widget item = Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            color: tagsColors[Random().nextInt(tagsColors.length)],
            borderRadius: BorderRadius.circular(1000)),
        child: Text(
          showTagLabelCurrentLocale(items[i]),
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  String showTagLabelCurrentLocale(String str) {
    if (context.locale.languageCode == "en") {
      try {
        var reversed = Map.fromEntries(
            standartInterestList.entries.map((e) => MapEntry(e.value, e.key)));
        str = reversed[str]!;
      } catch (err) {}
    }

    return str;
  }

  String? parseBadHabits(UserProfileData item) {
    if (item.badHabits == null) {
      return null;
    }
    if (item.isBadHabitsFilled == false) {
      return null;
    }
    if (item.isBadHabitsFilled == true && item.badHabits!.isEmpty) {
      return LocaleKeys.badHabbits_missing.tr();
    }

    String str = "";
    try {
      for (int i = 0; i < item.badHabits!.length; i++) {
        final badHabitLocalized = addictionList[item.badHabits![i]]?.tr();
        if (badHabitLocalized == null) {
          continue;
        } else {
          str += badHabitLocalized;
          if (i < item.badHabits!.length - 1) {
            str += ", ";
          }
        }
      }
      return str;
    } catch (err) {
      return null;
    }
  }
}
