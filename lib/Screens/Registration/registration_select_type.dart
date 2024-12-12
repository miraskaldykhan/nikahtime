import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/Screens/Registration/registration_email_1.dart';
import 'package:untitled/Screens/Registration/registration_phone_number_1.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class RegistrationSelectTypeScreen extends StatefulWidget {
  const RegistrationSelectTypeScreen();

  @override
  State<RegistrationSelectTypeScreen> createState() =>
      _RegistrationSelectTypeScreenState();
}

class _RegistrationSelectTypeScreenState
    extends State<RegistrationSelectTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            width: double.infinity,
            //margin: EdgeInsets.only(top: 104),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Header(),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary  ,
                              elevation: 0,
                              fixedSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.registration_type_phone_by.tr(),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  const RegistrationPhoneNumberScreen(),
                                  transitionDuration:
                                  const Duration(seconds: 0),
                                ),
                              );
                            })),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                          height: 56,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                                width: 2,
                                color:  Theme.of(context).colorScheme.secondary ),
                          ),
                          child: Text(
                            LocaleKeys.registration_type_email_by.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color:  Theme.of(context).colorScheme.secondary ,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                const RegistrationEmailScreen(),
                                transitionDuration:
                                const Duration(seconds: 0),
                              ),
                            );
                            setState(() {});
                          }),
                    ),
                    const SizedBox(height: 20),
                    const _OrLoginOption(),
                    const SizedBox(height: 20),
                   Container(
            width: double.infinity,
            child: Row(
              children: [
          Expanded(
            child: GestureDetector(
              onTap: () async { 
                _sendGoogleSignInRegistrationRequest();
              },
              child: Container(
                height: 52,
                 decoration: BoxDecoration(
                      border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                      borderRadius: BorderRadius.circular(10)
                 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/google.png', width: 20,),
                    const SizedBox(width: 8),
                    const Text(
                      'Google',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16), // Расстояние между кнопками
          Expanded(
            child: GestureDetector(
              onTap: () async { 
                _sendAppleSignInRegistrationRequest();
              },
              child: Container(
                height: 52,
                 decoration: BoxDecoration(
                      border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                      borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/apple.png', width: 20,),
                    const SizedBox(width: 8),
                    const Text(
                      'Apple',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
                          
                          // Container(
                          //     height: 48,
                          //     width: 48,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: const Color.fromARGB(255, 218, 216, 215),
                          //         width: 1,
                          //       ),
                          //       borderRadius:
                          //       const BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.instagram),
                          //       color: Colors.green,
                          //       onPressed: () {
                          //         ;
                          //       },
                          //     )),
                          // Container(
                          //     height: 48,
                          //     width: 48,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: Color.fromARGB(255, 218, 216, 215),
                          //         width: 1,
                          //       ),
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.vk),
                          //       color: Colors.green,
                          //       onPressed: () {
                          //         ;
                          //       },
                          //     )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                  ]
              ),
            ),
          ),
          const Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          PolicyAgreement(),
                          SizedBox(height: 20,)
                        ],
                      ))
        ],
      ),
    );
  }

  _sendAppleSignInRegistrationRequest() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'ru.nikahtime.web',
          redirectUri: Uri.parse(
            'https://www.nikahtime.ru/api/auth/apple/callback',
          ),
        ),
      );
      String? token = "";
      FirebaseMessaging messaging = await FirebaseMessaging.instance;
      token = (await messaging.getToken());

      final service = NetworkService();
      final response = await service
          .sendRegistrationRequestByAppleId(credential.identityToken!, token);

      if (response.statusCode != 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(
                    '${response.statusCode}\n${jsonDecode(response.body)["detail"]}')));
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.accessToken = jsonDecode(response.body)["accessToken"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              RegistrationCreateProfileScreen(userProfileData),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } catch (error) {
      if (error is SignInWithAppleAuthorizationException) {
        if (error.code == AuthorizationErrorCode.canceled) {
          return;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(error.toString())),
      );
    }
  }

  _sendGoogleSignInRegistrationRequest() async {
    try {
      String? clientId = null;

      if (Platform.isIOS) {
        clientId =
            '1023685173404-go99snh3am30qgjgd8up1kld3mbr7ra8.apps.googleusercontent.com';
      }

      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
        clientId: clientId,
      );

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      GoogleSignInAccount? googleSignInAccount;

      try {
        googleSignInAccount = await _googleSignIn.signIn();
      } catch (error) {
        if (error is PlatformException) {
          if (error.code == 'sign_in_canceled') {
            return;
          }
        }
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: const Text("Ошибка"), content: Text(error.toString())),
        );
      }

      if (googleSignInAccount == null) {
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      String? token = "";
      FirebaseMessaging messaging = await FirebaseMessaging.instance;
      token = (await messaging.getToken());

      final service = NetworkService();
      final response = await service
          .sendRegistrationRequestByGoogle(googleSignInAuthentication.idToken!, token);

      if (response.statusCode != 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(
                    '${response.statusCode}\n${jsonDecode(response.body)["detail"]}')));
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.accessToken = jsonDecode(response.body)["accessToken"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              RegistrationCreateProfileScreen(userProfileData),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } catch (error) {
      // if (error is GoogleSignIn.kSignInCanceledError) {
      //   if (error.code == AuthorizationErrorCode.canceled) {
      //     return;
      //   }
      // }
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(error.toString())),
      );
    }
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.registration_header.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color.fromARGB(255, 33, 33, 33),
            ),
          )
        ]);
  }
}


class _OrLoginOption extends StatelessWidget {
    const _OrLoginOption ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return  Row(
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
                  fontWeight: FontWeight.w500,
                  color: Colors.black
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