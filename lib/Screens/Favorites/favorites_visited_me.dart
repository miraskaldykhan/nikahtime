import 'dart:async';

import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class PeopleWhoVizitedMeScreen extends StatefulWidget {
  const PeopleWhoVizitedMeScreen(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<PeopleWhoVizitedMeScreen> createState() =>
      PeopleWhoVizitedMeScreenState();
}

class PeopleWhoVizitedMeScreenState extends State<PeopleWhoVizitedMeScreen> {
  int page = 1;
  bool isLoadingComplete = false;
  bool isLoadingEnd = false;
  List<UserProfileData> vizitedMeAnketas = [];
  Timer? timer;

  sendAnketesRequest() async {
    try {
      var response = await NetworkService().getGuests(
          accessToken: widget.userProfileData.accessToken!, page: page);
      page++;
      vizitedMeAnketas = [];
      vizitedMeAnketas.addAll(response.users as Iterable<UserProfileData>);

      if (response.users.length < 20) {
        setState(() {
          isLoadingEnd = true;
        });
      }

      setState(() {
        isLoadingComplete = true;
      });
    } catch (e) {
      return;
    }
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
          LocaleKeys.usersScreen_loading.tr(),
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

  @override
  void initState() {
    if (timer == null) {
      sendAnketesRequest();
    }
    super.initState();
    timer = Timer.periodic(
        const Duration(
          seconds: 60,
        ), (timer) {
      sendAnketesRequest();
    });
  }

  @override
  dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isLoadingComplete
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: vizitedMeAnketas.isEmpty
                          ? Center(
                              child: SizedBox(
                                width: 240,
                                child: Text(
                                    LocaleKeys.usersScreen_notFound.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          : FeedVerticalGridView(
                              userProfileData: widget.userProfileData,
                              anketas: vizitedMeAnketas,
                              uploadMore: () async {
                                sendAnketesRequest();
                              },
                            ),
                    ),
                  ],
                ),
              )
            : Center(
                child: waitBox(Theme.of(context).colorScheme.primary),
              ));
  }
}
