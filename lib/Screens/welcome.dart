import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as car;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/Screens/Entering/entering.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

import 'Registration/registration_select_type.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: const Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[AppFeaturesCarousel()],
                  ),
                ),
                Positioned(
                    left: 16,
                    right: 16,
                    bottom: 50,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const _CreateAccountButton(),
                      const SizedBox(height: 16),
                      _LoginButton(),
                      const SizedBox(height: 16),
                      //_AuthLink()
                    ]))
              ],
            )));
  }
}

class _OrLoginOption extends StatelessWidget {
  const _OrLoginOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black,
            indent: 0,
            endIndent: 10,
          ),
        ),
        Text(
          LocaleKeys.welcome_screen_createAcc.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.black,
            indent: 10,
            endIndent: 0,
          ),
        ),
      ],
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              LocaleKeys.welcome_screen_createAcc.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            onPressed: () async {
              await ageConfirmationDialog(
                context: context,
              );
            }));
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              LocaleKeys.welcome_screen_authorize.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => EnteringScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            }));
  }
}

ageConfirmationDialog({required BuildContext context}) async {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      LocaleKeys.welcome_screen_ageConfirmed_bad.tr(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      LocaleKeys.welcome_screen_ageConfirmed_good.tr(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      useTermsConfirmation(context: context);
    },
  );

  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))),
    backgroundColor: Colors.white,
    title: Text(LocaleKeys.welcome_screen_ageConfirmed_question.tr()),
    content: Text(
      LocaleKeys.welcome_screen_ageConfirmed_action.tr(),
      style: const TextStyle(color: Colors.black),
    ),
    actions: [
      Row(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                height: 34,
                child: cancelButton),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                height: 34,
                child: continueButton),
          )
        ],
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

useTermsConfirmation({required BuildContext context}) async {
  showModalBottomSheet(
      enableDrag: false,
      //expand: true,

      context: context,
      builder: (buildContext) => Material(
            color: Colors.white,
            child: Column(
              children: [
                const Expanded(
                  child: CustomWebView(
                      initialUrl: "https://www.nikahtime.ru/user/app_use_terms",
                      header: ""),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const RegistrationSelectTypeScreen() /*RegistrationPhoneNumberScreen()*/,
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.common_confirm.tr(),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.common_cancel.tr(),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ));
}

class NikahCarouselItem {
  String icon;
  String title;
  String description;
  Color color;

  NikahCarouselItem(this.icon, this.title, this.description, this.color);
}

final List<NikahCarouselItem> nikahCarouselItems = [
  NikahCarouselItem(
    'assets/icons/about_app_features/filters.png',
    LocaleKeys.welcome_screen_carousel_item1_header.tr(),
    LocaleKeys.welcome_screen_carousel_item1_text.tr(),
    Colors.transparent,
  ),
  NikahCarouselItem(
      'assets/icons/about_app_features/people.png',
      LocaleKeys.welcome_screen_carousel_item2_header.tr(),
      LocaleKeys.welcome_screen_carousel_item2_text.tr(),
      Colors.transparent),
  NikahCarouselItem(
      'assets/icons/about_app_features/chating.png',
      LocaleKeys.welcome_screen_carousel_item3_header.tr(),
      LocaleKeys.welcome_screen_carousel_item3_text.tr(),
      Colors.transparent)
];

final List<Widget> itemSliders = nikahCarouselItems
    .map((item) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 250,
                      maxWidth: 250,
                      minHeight: 350,
                      maxHeight: 350),
                  child: Image.asset(item.icon, fit: BoxFit.contain)),
            ),
            const SizedBox(height: 8),
            Expanded(
                flex: 0,
                child: Text(item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ))),
            const SizedBox(height: 8),
            Expanded(
                flex: 0,
                child: Text(item.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0x21, 0x21, 0x21),
                        fontSize: 16,
                        height: 1.4))),
          ],
        ))
    .toList();

class AppFeaturesCarousel extends StatefulWidget {
  const AppFeaturesCarousel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppFeaturesCarouselState();
  }
}

class _AppFeaturesCarouselState extends State<AppFeaturesCarousel> {
  int _current = 0;
  final car.CarouselController _controller = car.CarouselController();

  @override
  Widget build(BuildContext context) {
    // Теперь itemSliders создается внутри build, где есть доступ к context
    final List<Widget> itemSliders = nikahCarouselItems
        .map((item) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 250,
                        maxWidth: 250,
                        minHeight: 350,
                        maxHeight: 350),
                    child: Image.asset(item.icon, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 8),
                // Используем context для темы
                Expanded(
                    flex: 0,
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    )),
                const SizedBox(height: 8),
                Expanded(
                    flex: 0,
                    child: Text(
                      item.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0x21, 0x21, 0x21),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    )),
              ],
            ))
        .toList();

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: nikahCarouselItems.asMap().entries.map((entry) {
              return Expanded(
                child: GestureDetector(
                    onTap: () => const CarouselScrollPhysics(),
                    child: Container(
                      height: 5.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: _current == entry.key
                            ? Colors.black
                            : const Color.fromARGB(255, 0xc4, 0xc3, 0xc1),
                      ),
                    )),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          car.CarouselSlider(
            items: itemSliders,
            carouselController: _controller,
            options: car.CarouselOptions(
                height: 500,
                autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                disableCenter: true,
                aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ]);
  }
}
