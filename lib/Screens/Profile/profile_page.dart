import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Employeers/employee_information.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Profile/profile_main_page.dart';
import 'package:untitled/Screens/Profile/subscribe_page.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/components/widgets/image_grid_widget.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'dart:math';

import 'package:untitled/generated/locale_keys.g.dart'; // Для генерации случайных чисел

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.userProfileData, {Key? key}) : super(key: key) {
    _getUserInfo();
    bool haveBadHabits = true;
    if (userProfileData.badHabits == null) {
      userProfileData.badHabits = [];
      haveBadHabits = false;
    } else {
      if (userProfileData.badHabits!.isNotEmpty &&
          userProfileData.badHabits![0].isEmpty) {
        userProfileData.badHabits = [];
      }
      haveBadHabits = userProfileData.badHabits!.isNotEmpty;
    }

    _isBadHabitsCheckboxOn =
        (haveBadHabits == false) && userProfileData.isBadHabitsFilled;
  }

  UserProfileData userProfileData;
  late bool _isBadHabitsCheckboxOn;

  _getUserInfo() async {
    var response = await NetworkService()
        .GetUserInfo(userProfileData.accessToken.toString());

    if (response.statusCode != 200) {
      return;
    }
    userProfileData.jsonToData(jsonDecode(response.body)[0]);
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Color> iconBackgroundColors = [
    const Color(0xFF337FFF),
    const Color(0xFF0AE8B2),
    const Color(0xFF1BEA6C),
    const Color(0xFF3FC5F9),
    const Color(0xFF7D61EC),
    const Color(0xFFF840C4),
    const Color(0xFFF949FD),
    const Color(0xFFFCE410),
    const Color(0xFFFF5050),
    const Color(0xFFFF8B49),
  ];

  Color getRandomColor() {
    final random = Random();
    return iconBackgroundColors[random.nextInt(iconBackgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.profileScreen_title.tr(),
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                border: GradientBoxBorder(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ]),
                    width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            ProfileMainPageScreen(widget.userProfileData)),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                  size: 18,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: displayPhotoOrVideo(
                      this.context,
                      widget.userProfileData.images![0].main.toString(),
                      items: widget.userProfileData.images!
                          .map((e) => e.main)
                          .toList()
                          .cast<String>(),
                      initPage: 0,
                      photoOwnerId: widget.userProfileData.id,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDCDCDC)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.userProfileData.firstName == ''
                                    ? ''
                                    : widget.userProfileData.firstName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDCDCDC)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.userProfileData.lastName == ''
                                    ? ''
                                    : widget.userProfileData.lastName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFDCDCDC)),
                  borderRadius: BorderRadius.circular(10)),
              child: _buildMenuItem(
                  context,
                  LocaleKeys.profileScreen_settings_change_photo.tr(),
                  Icons.camera_alt, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          ProfileMainPageScreen(widget.userProfileData)),
                );
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDCDCDC)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_subscription_header
                            .tr(),
                        Icons.subscriptions, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BackgroundImageScreen(),
                        ),
                      );
                    }),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                      context,
                      LocaleKeys.profileScreen_settings_family_consultation
                          .tr(),
                      Icons.family_restroom,
                      () async {
                        MyTracker.trackEvent("Open \"About Us\" page", {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const EmployeeInformation(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                      context,
                      LocaleKeys.profileScreen_settings_privacy.tr(),
                      Icons.lock,
                      () {
                        //_launchInBrowser("http://nikahtime.ru/privacy/policy");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomWebView(
                                  initialUrl:
                                      "https://www.nikahtime.ru/privacy/policy",
                                  header: LocaleKeys
                                      .profileScreen_settings_privacy
                                      .tr(),
                                )));
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_help.tr(),
                        Icons.help, () {
                      _showHelpDialog(context);
                    }),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_notifications.tr(),
                        Icons.notifications,
                        () {}),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_language_header.tr(),
                        Icons.language, () {
                      _showLanguageDialog(context);
                    }),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_theme_header.tr(),
                        Icons.brightness_6, () {
                      _showThemeDialog(context);
                    }),
                    const Divider(
                      height: 1,
                      color: Color(0xFFDCDCDC),
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildMenuItem(
                        context,
                        LocaleKeys.profileScreen_settings_donate_msg_header
                            .tr(),
                        Icons.favorite, () {
                      _showSupportDialog(context);
                    }),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFDCDCDC)),
                  borderRadius: BorderRadius.circular(10)),
              child: _buildMenuItem(
                  context,
                  LocaleKeys.profileScreen_settings_exit.tr(),
                  Icons.exit_to_app, () async {
                await NetworkService().SendLogoutGet(
                    (context.read<ProfileBloc>().state as ProfileInitial)
                        .userProfileData!
                        .accessToken!);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("token", "empty");
                prefs.setString("userGender", "empty");
                prefs.setInt("userId", 0);

                try {
                  FirebaseMessaging messaging = FirebaseMessaging.instance;
                  await messaging.deleteToken();
                } catch (_) {}

                context.read<ProfileBloc>().add(const ClearProfileInfo());

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: Colors.transparent, // Фон окна
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildThemeOption(
                context,
                LocaleKeys.profileScreen_settings_theme_tiffani.tr(),
                'assets/icons/greenColorChoose.png',
              ),
              const SizedBox(width: 10),
              _buildThemeOption(
                context,
                LocaleKeys.profileScreen_settings_theme_pinkClouds.tr(),
                'assets/icons/purpleColorChoose.png',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context, String themeName, String imagePath) {
    return GestureDetector(
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false)
            .switchTheme(themeName);
        Navigator.pop(context);
      },
      child: Container(
        width: 168,
        padding: const EdgeInsets.only(bottom: 15, top: 5, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      themeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(4, 0),
                  child: Radio<String>(
                    overlayColor: WidgetStateProperty.all<Color?>(Colors.grey),
                    splashRadius: null,
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        return Colors.grey;
                      },
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: themeName,
                    groupValue: Provider.of<ThemeProvider>(context).themeName,
                    onChanged: (String? value) {
                      if (value != null) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .switchTheme(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            Image.asset(
              imagePath,
              height: 168,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: getRandomColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff111111)),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xff111111),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 1. Поддержать
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          backgroundColor: Colors.white,
          content: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.profileScreen_settings_donate_msg_text.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                //убран виджет с отступом

                TextSpan(
                  text: LocaleKeys.profileScreen_settings_donate_msg_text2.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              LocaleKeys
                                  .profileScreen_settings_donate_msg_later_btn
                                  .tr(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 1)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            LocaleKeys
                                .profileScreen_settings_donate_msg_support_btn
                                .tr(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, height: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// 2. Язык приложения
  void _showLanguageDialog(BuildContext context) {
    String? selectedLanguage = context.locale.languageCode;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          backgroundColor: Colors.white,
          title: Text(LocaleKeys.profileScreen_settings_language_header.tr()),
          contentPadding: const EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RadioListTile<String>(
                  overlayColor: WidgetStateProperty.all<Color?>(Colors.grey),
                  splashRadius: null,
                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Theme.of(context).colorScheme.primary;
                      }
                      return Colors.grey;
                    },
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  title: const Text('Русский',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  value: 'ru',
                  groupValue: selectedLanguage,
                  onChanged: (String? value) {
                    if (value != null) {
                      localize.EasyLocalization.of(context)
                          ?.setLocale(const Locale('ru'));
                      setState(() {
                        selectedLanguage = value;
                      });
                    }
                  },
                ),
              ),
              RadioListTile<String>(
                overlayColor: WidgetStateProperty.all<Color?>(Colors.grey),
                splashRadius: null,
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Colors.grey;
                  },
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                title: const Text(
                  'English',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                value: 'en',
                groupValue: selectedLanguage,
                // The selected language
                onChanged: (String? value) {
                  if (value != null) {
                    localize.EasyLocalization.of(context)
                        ?.setLocale(const Locale('en'));
                    setState(() {
                      selectedLanguage =
                          value; // Update the state with selected language
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        color: Colors.white,
                        child: Text(''),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            LocaleKeys.common_confirm.tr(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, height: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// 3. Помощь проект
  void _showHelpDialog(BuildContext context) async {
    final Email email = Email(
      recipients: ['nikahtime@bk.ru'],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == 'not_available') {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  LocaleKeys.profileScreen_settings_error_header.tr(),
                  style: TextStyle(color: Colors.black),
                ),
                content: Text(LocaleKeys.profileScreen_settings_error_text.tr(),
                    style: TextStyle(color: Colors.black))),
          );
          return;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(LocaleKeys.profileScreen_settings_error_header.tr()),
            content: Text(LocaleKeys.profileScreen_settings_mail.tr() +
                error.toString())),
      );
    }
    child:
    Container(
      color: Colors.white,
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          children: [
            TextSpan(
              text: LocaleKeys.profileScreen_settings_connectToDevs.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Выбор темы приложения

class AppThemes {
  static final ThemeData tiffanyTheme = ThemeData(
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00CF90), secondary: Color(0xFF00CF90)),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0ABAB5),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      // Основной текст
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
      // Заголовки
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      // Текст кнопок
      labelLarge: TextStyle(color: Colors.black),
      // Подписи
      bodySmall: TextStyle(color: Colors.black),
      // Подзаголовки
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData pinkCloudsTheme = ThemeData(
    primaryColor: const Color(0xFFFB457E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8048F9),
      secondary: Color(0xFFFB457E),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF3FD),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFF3FD),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      // Основной текст
      bodyLarge: TextStyle(color: Colors.black),
      // Заголовки
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      // Текст кнопок
      labelLarge: TextStyle(color: Colors.black),
      // Подписи
      bodySmall: TextStyle(color: Colors.black),
      // Подзаголовки
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
    ),
  );
}

Future<void> saveTheme(String themeName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme', themeName);
}

Future<String?> loadTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('theme');
}

class ThemeProvider with ChangeNotifier {
  late ThemeData _currentTheme;
  late String _themeName;

  ThemeData get currentTheme => _currentTheme;

  String get themeName => _themeName;

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    _currentTheme = AppThemes.tiffanyTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeName = prefs.getString('theme') ?? "Тиффани" ?? 'Tiffany';
    _applyTheme();
    notifyListeners();
  }

  Future<void> saveTheme(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
  }

  void _applyTheme() {
    _currentTheme = _themeName == 'Тиффани' || _themeName == 'Tiffany'
        ? AppThemes.tiffanyTheme
        : AppThemes.pinkCloudsTheme;
  }

  // Переключение темы и сохранение в SharedPreferences
  void switchTheme(String themeName) {
    _themeName = themeName;
    _applyTheme();
    saveTheme(themeName);
    notifyListeners();
  }
}
