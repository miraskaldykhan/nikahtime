import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:untitled/Screens/Chat/Stories/create/cubit/send_stories/send_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/createdAtCubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/delete/delete_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/editor/cubit/get_my_stories/get_my_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/get_friends_stories/get_friend_stories_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/get_stories_viewers/stories_viewers_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/like_story/like_story_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/send_message_to_story/send_message_to_story_cubit.dart';
import 'package:untitled/Screens/Chat/Stories/look_stories/cubit/show_story/show_story_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_followers/fetch_followers_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_friends/fetch_friends_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_registered_contacts/fetch_registered_contacts_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_unregistered_contacts/unregistered_contacts_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/move_follower_to_friends/follower_to_friend_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/move_friend_to_follower/friend_to_follower_cubit.dart';
import 'package:untitled/Screens/Contacts/cubit/send_friends_request/send_friends_request_cubit.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Profile/profile_page.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/Screens/main_page.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/ServiceItems/notification_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/components/widgets/nikah_app_updater.dart';
import 'package:untitled/firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";

  await Firebase.initializeApp(
    name: 'nikah-time-332406',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Получено сообщение: ${message.notification?.title}");
    print("Тело сообщения: ${message.notification?.body}");
  });

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //debugPrint("fcm token: ${await messaging.getToken()}");
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Color.fromARGB(255, 0xf5, 0xf5, 0xf5),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark
  ));*/

  //WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isIOS) {
    StreamSubscription? subscription;
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      if (purchaseDetailsList.isEmpty) {
        subscription?.cancel();
        return;
      }
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            try {
              String receiptData =
                  purchaseDetails.verificationData.localVerificationData;
              await NetworkService()
                  .verifyPaymentByApplePay(receiptData: receiptData);
              // ignore: deprecated_member_use
            } on DioError catch (error) {
              debugPrint(error.toString());
              return;
            }
          } else if (purchaseDetails.status == PurchaseStatus.canceled) {}
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      });
      subscription?.cancel();
    }, onDone: () {
      subscription?.cancel();
    }, onError: (error) {
      debugPrint(error);
    });
  }

  //MyTrackerConfig trackerConfig = MyTracker.trackerConfig;
  // trackerConfig.setLaunchTimeout(300);
  // trackerConfig.setBufferingPeriod(60);
  // trackerConfig.setRegion(MyTrackerRegion.RU);
  // trackerConfig.setTrackingLocationEnabled(false);
  //
  // //MyTracker.setDebugMode(true);
  // await MyTracker.init(MyTrackerSDK.getKeySDK());

  // runApp(MyApp(token, response));
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(prefs),
        child: MyApp(token),
      ),
    ),
  );
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MyApp extends StatefulWidget {
  const MyApp(this.token, {super.key});

  final String token;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> colorCodes = {
    50: const Color.fromRGBO(00, 0xcf, 0x91, .1),
    100: const Color.fromRGBO(00, 0xcf, 0x91, .2),
    200: const Color.fromRGBO(00, 0xcf, 0x91, .3),
    300: const Color.fromRGBO(00, 0xcf, 0x91, .4),
    400: const Color.fromRGBO(00, 0xcf, 0x91, .5),
    500: const Color.fromRGBO(00, 0xcf, 0x91, .6),
    600: const Color.fromRGBO(00, 0xcf, 0x91, .7),
    700: const Color.fromRGBO(00, 0xcf, 0x91, .8),
    800: const Color.fromRGBO(00, 0xcf, 0x91, .9),
    900: const Color.fromRGBO(00, 0xcf, 0x91, 1),
  };

  late DateTime installationDate;
  bool showRatingPopup = false;

  Future<http.Response>? _userInfoFuture;

  @override
  void initState() {
    super.initState();
    checkRatingPopup();
    if (widget.token.isNotEmpty && widget.token != 'empty') {
      _userInfoFuture = NetworkService().GetUserInfo(widget.token);
    }
  }

  Future<void> checkRatingPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final installationTimestamp = prefs.getInt('installation_date');

    if (installationTimestamp == null) {
      // Сохраняем текущую дату как дату установки при первом запуске
      prefs.setInt('installation_date', DateTime.now().millisecondsSinceEpoch);
      prefs.setInt('rating_popup_day', 3);
      return;
    }

    installationDate =
        DateTime.fromMillisecondsSinceEpoch(installationTimestamp);
    int daysToPopup = prefs.getInt('rating_popup_day') ?? 3;
    final daysSinceInstallation =
        DateTime.now().difference(installationDate).inDays;

    // Проверка необходимости показа всплывающего окна
    if (daysSinceInstallation >= daysToPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(
            () => showRatingPopup = true,
          ));
    }
  }

  Future<void> updateNextPopupDay() async {
    final prefs = await SharedPreferences.getInstance();
    int currentPopupDay = prefs.getInt('rating_popup_day') ?? 3;
    int nextPopupDay;

    if (currentPopupDay == 3) {
      nextPopupDay = 7;
    } else if (currentPopupDay == 7) {
      nextPopupDay = 30;
    } else {
      nextPopupDay = 0; // Прекращаем показывать окна
    }

    prefs.setInt('rating_popup_day', nextPopupDay);
  }

  Future<void> launchAppStore() async {
    const appStoreUrl = "https://apps.apple.com/kz/app/nikah-time/id1593398215";
    const googlePlayUrl =
        "https://play.google.com/store/apps/details?id=ru.nikahtime";

    final url = Theme.of(context).platform == TargetPlatform.iOS
        ? appStoreUrl
        : googlePlayUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open store URL';
    }
  }

  Future<void> showRatingDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Уважаемый(ая) пользователь!",
            style: TextStyle(
              color: Color(
                0xff212121,
              ),
              fontSize: 18,
            ),
          ),
          content: Text(
            "Команда разработчиков выражает благодарность за использование приложения «NikahTime»! Оцените нашу работу в «App Store» или «Google Play» для улучшения приложения.",
            style: TextStyle(
              color: Color(
                0xff212121,
              ),
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateNextPopupDay();
                Navigator.pop(context);
              },
              child: Text(
                "Оценить позже",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                launchAppStore();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                  "Оценить сейчас",
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => SendStoriesCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetMyStoriesCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => DeleteStoriesCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetFriendStoriesCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => TextCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => StoriesViewersCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShowStoryCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => LikeStoryCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FetchRegisteredContactsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => UnregisteredContactsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FetchFriendsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FetchFollowersCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FollowerToFriendCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => SendFriendsRequestCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FriendToFollowerCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => SendMessageToStoryCubit(),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        child: ToastificationWrapper(
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Nikah Time',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: buildAppBody(context),
            navigatorKey: navigatorKey,
            routes: {
              '/entering': (context) => const WelcomeScreen(),
            },
          ),
        ),
      ),
    );
  }

  Widget buildAppBody(BuildContext context) {
    if (widget.token == "empty" || widget.token.isEmpty) {
      return const AppBody(
        initialScreen: AppBodyScreen.welcome,
      );
    }
// а если авторизован — ждём Future
    return FutureBuilder<http.Response>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data?.statusCode != 200) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Не удалось соединиться с сервером',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userInfoFuture =
                            NetworkService().GetUserInfo(widget.token);
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(color: Colors.white),
                        )),
                    child: const Text(
                      'Попробовать снова',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        print(snapshot.data);
        UserProfileData userProfileData = UserProfileData();
        userProfileData.accessToken = widget.token;
        userProfileData.jsonToData(jsonDecode(snapshot.data!.body)[0]);

        log("accessTOKEN: ${widget.token}");

        if (showRatingPopup) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async => await showRatingDialog(),
          );
        }

        return Builder(builder: (ctx) {
          ctx
              .read<ProfileBloc>()
              .add(UpdateProfileDataEvent(userProfileData: userProfileData));
          return AppBody(
            initialScreen: userProfileData.isValid()
                ? AppBodyScreen.main
                : AppBodyScreen.registrationCreateProfile,
            userProfileData: userProfileData,
          );
        });
      },
    );
  }
}

enum AppBodyScreen { welcome, main, registrationCreateProfile }

class AppBody extends StatelessWidget {
  final AppBodyScreen initialScreen;
  final UserProfileData? userProfileData;

  const AppBody({super.key, required this.initialScreen, this.userProfileData});

  String getCountryIsoCode() {
    final WidgetsBinding instance = WidgetsBinding.instance;
    final List<Locale> systemLocales = instance.window.locales;
    String? isoCountryCode = systemLocales.first.countryCode;
    if (isoCountryCode != null) {
      return isoCountryCode;
    } else {
      throw Exception("Unable to get Country ISO code");
    }
  }

  @override
  Widget build(BuildContext context) {
    var country = "US";
    try {
      country = getCountryIsoCode();
    } catch (e) {
      country = "US";
    }

    final appUpdater = NikahAppUpdater(country: country);
    appUpdater.showUpdateDialogIfNecessary(context: context);

    // FlutterAppBadger.removeBadge();

    switch (initialScreen) {
      case AppBodyScreen.welcome:
        return const WelcomeScreen();
      case AppBodyScreen.main:
        //MyTrackerParams trackerParams = MyTracker.trackerParams;

        // trackerParams.setCustomUserIds([userProfileData!.id!.toString()]);
        // trackerParams.setAge(DateTime.now()
        //         .difference(
        //             DateFormat("dd.MM.yyyy").parse(userProfileData!.birthDate!))
        //         .abs()
        //         .inDays ~/
        //     365);
        // trackerParams.setGender(userProfileData!.gender == null
        //     ? MyTrackerGender.UNKNOWN
        //     : ((userProfileData!.gender == "male")
        //         ? MyTrackerGender.MALE
        //         : MyTrackerGender.FEMALE));
        //
        // MyTracker.trackLoginEvent(userProfileData!.id!.toString(), {});
        //MyTracker.trackRegistrationEvent(widget.userProfileData.id!.toString(),{});
        return MainPage(userProfileData!);
      case AppBodyScreen.registrationCreateProfile:
        return RegistrationCreateProfileScreen(userProfileData!);
    }
  }
}
