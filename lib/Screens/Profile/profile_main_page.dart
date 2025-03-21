import 'dart:convert';
import 'dart:math';
import 'package:customizable_multiselect_field/customizable_multiselect_flutter.dart';
import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Profile/profile_redact_interests.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/components/items/nationality_list.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/Screens/Profile/profile_settings.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/widgets/image_grid_widget.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class ProfileMainPageScreen extends StatefulWidget {
  ProfileMainPageScreen(this.userProfileData, {Key? key}) : super(key: key) {
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
  State<ProfileMainPageScreen> createState() => _ProfileMainPageScreenState();
}

class _ProfileMainPageScreenState extends State<ProfileMainPageScreen> {
  void updateUserData() async {
    debugPrint("ASDSAD");
    checkFields();
    if (firstNameErr == true ||
        lastNameErr == true ||
        birthDateErr == true ||
        nationalityErr == true ||
        cityErr == true ||
        numberErr == true ||
        educationErr == true ||
        typeReligionErr == true ||
        canonsErr == true ||
        maritalErr == true ||
        placeOfWorkErr == true ||
        childrenErr == true) {
      return;
    }
    debugPrint("ASDSAD");
    var request = await NetworkService().UpdateuserInfo(
        widget.userProfileData.accessToken.toString(),
        widget.userProfileData.returnUserData());
    if (request.statusCode != 200) {
      debugPrint("${widget.userProfileData.returnUserData()}");
      debugPrint("${request.body}");
    }
    needUpdate = false;
    try {
      setState(() {});
    } catch (e) {
      debugPrint("Print");
    }
  }

  bool firstNameErr = false;
  bool lastNameErr = false;
  bool birthDateErr = false;
  bool nationalityErr = false;
  bool cityErr = false;
  bool countryErr = false;
  bool numberErr = false;
  bool educationErr = false;
  bool maritalErr = false;
  bool childrenErr = false;
  bool photoErr = false;
  bool typeReligionErr = false;
  bool canonsErr = false;
  bool placeOfWorkErr = false;
  bool religionErr = false;
  bool needUpdate = false;

  bool isStringCorrect(String? field) {
    if (field == null || field.isEmpty || field == "") return false;
    return true;
  }

  void checkFields() {
    widget.userProfileData.firstName = widget.userProfileData.firstName?.trim();
    widget.userProfileData.lastName = widget.userProfileData.lastName?.trim();

    firstNameErr = !isStringCorrect(widget.userProfileData.firstName);
    lastNameErr = !isStringCorrect(widget.userProfileData.lastName);
    // typeReligionErr = !isStringCorrect(widget.userProfileData.typeReligion);
    canonsErr = !isStringCorrect(widget.userProfileData.observeIslamCanons);
    birthDateErr = !isStringCorrect(widget.userProfileData.birthDate);
    religionErr = widget.userProfileData.religionId == null;
    // nationalityErr = !isStringCorrect(widget.userProfileData.nationality);
    cityErr = !isStringCorrect(widget.userProfileData.city);
    countryErr = !isStringCorrect(widget.userProfileData.country);
    // numberErr = !isStringCorrect(widget.userProfileData.contactPhoneNumber);
    educationErr = !isStringCorrect(widget.userProfileData.education);
    placeOfWorkErr = !isStringCorrect(widget.userProfileData.placeOfWork);
    maritalErr = !isStringCorrect(widget.userProfileData.maritalStatus);

    if (widget.userProfileData.haveChildren == null) {
      childrenErr = true;
    } else {
      childrenErr = false;
    }

    if (widget.userProfileData.photos == null ||
        widget.userProfileData.photos!.isEmpty) {
      photoErr = true;
    } else {
      photoErr = false;
    }

    if (widget._isBadHabitsCheckboxOn) {
      widget.userProfileData.isBadHabitsFilled = true;
    } else {
      if (widget.userProfileData.badHabits?.isNotEmpty ?? false) {
        widget.userProfileData.isBadHabitsFilled = true;
      } else {
        widget.userProfileData.isBadHabitsFilled = false;
      }
    }

    needUpdate = true;

    try {
      setState(() {});
    } catch (e) {
      debugPrint("Print");
    }
  }

  @override
  void initState() {
    widget._getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("exit screen");
    updateUserData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("${widget.userProfileData.badHabits!}");
    return BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (buildContext, state) {
            if ((context.read<ProfileBloc>().state as ProfileInitial)
                    .userProfileData ==
                null) {
              context.read<ProfileBloc>().add(UpdateProfileDataEvent(
                  userProfileData: widget.userProfileData));
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //debugPrint((context.read<ProfileBloc>().state as ProfileInitial).userProfileData!.lastName);
            return Scaffold(
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
                          Navigator.pop(context);
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
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        LocaleKeys.profileScreen_title,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color.fromARGB(255, 33, 33, 33),
                        ),
                      ).tr(),
                    ],
                  )),
              body: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          PhotoPlace(widget.userProfileData, () {
                            needUpdate = true;
                            setState(() {});
                          }),

                          CustomInputDecoration().errorBox(photoErr,
                              errMessage: LocaleKeys.needPhotoError),

                          const SizedBox(height: 24),
                          Focus(
                            child: TextField(
                              decoration: CustomInputDecoration(
                                hintText: LocaleKeys.user_firstName.tr(),
                              ).GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.firstName),
                              onChanged: (value) {
                                needUpdate = true;
                                widget.userProfileData.firstName = value;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.firstName = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),

                          CustomInputDecoration().errorBox(firstNameErr),
                          const SizedBox(height: 8),
                          Focus(
                            child: TextField(
                              decoration: CustomInputDecoration(
                                hintText: LocaleKeys.user_lastName.tr(),
                              ).GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.lastName),
                              onChanged: (value) {
                                needUpdate = true;
                                widget.userProfileData.lastName = value;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.lastName = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),
                          CustomInputDecoration().errorBox(lastNameErr),

                          Visibility(
                              visible: (widget.userProfileData.gender == null),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomInputDecoration().subtitleText(
                                      LocaleKeys.user_gender_title.tr()),
                                  _gender(context),
                                ],
                              )),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_birthDate.tr()),
                          BirthDate(
                            widget.userProfileData,
                            onPick: () {
                              checkFields();
                            },
                          ),
                          CustomInputDecoration().errorBox(birthDateErr),
                          // religion
                          CustomInputDecoration()
                              .subtitleText('religionSubtitle'.tr()),

                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  hint: Text(
                                    (widget.userProfileData.religionId == null)
                                        ? LocaleKeys.user_canons.tr()
                                        : widget.userProfileData.religionId == 1
                                            ? LocaleKeys.islam.tr()
                                            : widget.userProfileData
                                                        .religionId ==
                                                    2
                                                ? LocaleKeys.christianity.tr()
                                                : widget.userProfileData
                                                            .religionId ==
                                                        3
                                                    ? LocaleKeys.judaism.tr()
                                                    : LocaleKeys.another.tr(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  isDense: true,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val.toString() == "Islam") {
                                        widget.userProfileData.religionId = 1;
                                      } else if (val.toString() ==
                                          "Christianity") {
                                        widget.userProfileData.religionId = 2;
                                      } else if (val.toString() == "Judaism") {
                                        widget.userProfileData.religionId = 3;
                                      }
                                      checkFields();
                                    });
                                  },
                                  items: religionState
                                      .map(
                                        (description, value) {
                                          return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            ),
                                          );
                                        },
                                      )
                                      .values
                                      .toList(),
                                ),
                              ),
                            );
                          }),
                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_nationality.tr(),
                              isFieldRequired: false),
                          DropdownFormField<String>(
                            dropdownColor: Colors.white,
                            decoration: CustomInputDecoration().GetDecoration(
                                Theme.of(context).colorScheme.primary),
                            onSaved: (dynamic str) {},
                            onChanged: (dynamic item) {
                              widget.userProfileData.nationality = item;
                              checkFields();
                              setState(() {});
                            },
                            displayItemFn: (dynamic item) => Text(
                              translateNationName(widget
                                      .userProfileData.nationality ??
                                  LocaleKeys.nationalityState_notSelected.tr()),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            findFn: (dynamic str) async => getNationalityy(str),
                            dropdownItemFn: (dynamic item,
                                    int position,
                                    bool focused,
                                    bool selected,
                                    Function() onTap) =>
                                ListTile(
                              title: Text(
                                translateNationName(item),
                                style: const TextStyle(color: Colors.black),
                              ),
                              tileColor: focused
                                  ? const Color.fromARGB(20, 0, 0, 0)
                                  : Colors.transparent,
                              onTap: onTap,
                            ),
                          ),
                          // CustomInputDecoration().errorBox(nationalityErr),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_country.tr()),
                          DropdownFormField<String>(
                            dropdownColor: Colors.white,
                            decoration: CustomInputDecoration().GetDecoration(
                                Theme.of(context).colorScheme.primary),
                            onSaved: (dynamic str) {},
                            onChanged: (dynamic item) {
                              widget.userProfileData.country = "$item";
                              checkFields();
                              setState(() {});
                            },
                            displayItemFn: (dynamic str) => Text(
                              translateCountryName(
                                  widget.userProfileData.country ?? ""),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            findFn: (dynamic str) async => getCountry(str),
                            dropdownItemFn: (dynamic item,
                                    int position,
                                    bool focused,
                                    bool selected,
                                    Function() onTap) =>
                                ListTile(
                              title: Text(
                                translateCountryName(item),
                                style: const TextStyle(color: Colors.black),
                              ),
                              tileColor: focused
                                  ? const Color.fromARGB(20, 0, 0, 0)
                                  : Colors.transparent,
                              onTap: onTap,
                            ),
                          ),
                          CustomInputDecoration().errorBox(countryErr),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_city.tr()),
                          Visibility(
                            visible: widget.userProfileData.country == "Россия",
                            child: DropdownFormField<Map<String, dynamic>>(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              onSaved: (dynamic str) {},
                              onChanged: (dynamic item) {
                                debugPrint(
                                    "${item["name"]!}, ${item["region"]!}");
                                widget.userProfileData.city =
                                    "${item["name"]!}, ${item["region"]!}";
                                checkFields();
                                setState(() {});
                              },
                              displayItemFn: (dynamic item) => Text(
                                widget.userProfileData.city ?? "",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              findFn: (dynamic str) async =>
                                  NetworkService().DadataRequest(str),
                              dropdownItemFn: (dynamic item,
                                      int position,
                                      bool focused,
                                      bool selected,
                                      Function() onTap) =>
                                  ListTile(
                                title: Text(item['name'] ?? ' '),
                                subtitle: Text(
                                  item['region'] ?? '',
                                ),
                                tileColor: focused
                                    ? const Color.fromARGB(20, 0, 0, 0)
                                    : Colors.transparent,
                                onTap: onTap,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.userProfileData.country != "Россия",
                            child: Focus(
                              child: TextField(
                                decoration: CustomInputDecoration(
                                        hintText: LocaleKeys.user_city.tr())
                                    .GetDecoration(
                                        Theme.of(context).colorScheme.primary),
                                controller: TextEditingController(
                                    text: widget.userProfileData.city),
                                onChanged: (value) {
                                  needUpdate = true;
                                  widget.userProfileData.city = value;
                                },
                                onSubmitted: (value) {
                                  widget.userProfileData.city = value;
                                  checkFields();
                                  setState(() {});
                                },
                              ),
                              onFocusChange: (hasFocus) {
                                if (!hasFocus) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          CustomInputDecoration().errorBox(cityErr),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_contactPhoneNumber.tr(),
                              isFieldRequired: false),
                          userPhoneNumber(),
                          // CustomInputDecoration().errorBox(numberErr),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_education.tr()),
                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: widget.userProfileData.education ??
                                      "basicGeneral",
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.userProfileData.education =
                                          newValue;
                                      checkFields();
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: educationList
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            );
                          }),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_placeOfStudy.tr(),
                              isFieldRequired: false),

                          Focus(
                            child: TextField(
                              decoration: CustomInputDecoration(
                                      hintText:
                                          LocaleKeys.user_placeOfStudy.tr())
                                  .GetDecoration(
                                      Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.placeOfStudy),
                              onChanged: (value) {
                                needUpdate = true;
                                widget.userProfileData.placeOfStudy = value;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.placeOfStudy = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_placeOfWork.tr()),

                          Focus(
                            child: TextField(
                              decoration: CustomInputDecoration(
                                hintText: LocaleKeys.user_placeOfWork.tr(),
                              ).GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.placeOfWork),
                              onChanged: (value) {
                                widget.userProfileData.placeOfWork = value;
                                needUpdate = true;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.placeOfWork = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),
                          CustomInputDecoration().errorBox(placeOfWorkErr),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_workPosition.tr(),
                              isFieldRequired: false),

                          Focus(
                            child: TextField(
                              decoration: CustomInputDecoration(
                                hintText: LocaleKeys.user_workPosition.tr(),
                              ).GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.workPosition),
                              onChanged: (value) {
                                needUpdate = true;
                                widget.userProfileData.workPosition = value;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.workPosition = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_maritalStatus.tr()),
                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            if (familyState['married'] != null) {
                              widget.userProfileData.gender == "female"
                                  ? familyState.remove('married')
                                  : null;
                            }

                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    value:
                                        widget.userProfileData.maritalStatus ??
                                            "notMarried",
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.userProfileData.maritalStatus =
                                            newValue;
                                        checkFields();
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: familyState
                                        .map((description, value) {
                                          return MapEntry(
                                              description,
                                              DropdownMenuItem<String>(
                                                value: description,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ).tr(),
                                              ));
                                        })
                                        .values
                                        .toList()),
                              ),
                            );
                          }),
                          CustomInputDecoration().errorBox(maritalErr),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_faith.tr(),
                              isFieldRequired: false),
                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: widget.userProfileData.typeReligion ??
                                      "notSelected",
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      if (newValue == "notSelected") {
                                        widget.userProfileData.typeReligion =
                                            null;
                                      } else {
                                        widget.userProfileData.typeReligion =
                                            newValue;
                                      }
                                      checkFields();
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: faithState
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            );
                          }),
                          // CustomInputDecoration().errorBox(typeReligionErr),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_canons.tr()),

                          FormField<String>(
                              builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: widget
                                          .userProfileData.observeIslamCanons ??
                                      "observingIslamCanons",
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.userProfileData
                                          .observeIslamCanons = newValue;
                                      checkFields();
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: widget.userProfileData.gender == "male"
                                      ? observantOfTheCanonsMaleState
                                          .map((description, value) {
                                            return MapEntry(
                                                description,
                                                DropdownMenuItem<String>(
                                                  value: description,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ).tr(),
                                                ));
                                          })
                                          .values
                                          .toList()
                                      : observantOfTheCanonsFemaleState
                                          .map((description, value) {
                                            return MapEntry(
                                                description,
                                                DropdownMenuItem<String>(
                                                  value: description,
                                                  child: Text(value).tr(),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                ),
                              ),
                            );
                          }),
                          CustomInputDecoration().errorBox(canonsErr),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_haveChildren_title.tr()),
                          FormField<bool>(
                              builder: (FormFieldState<bool> state) {
                            return InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<bool>(
                                  dropdownColor: Colors.white,
                                  value: widget.userProfileData.haveChildren!,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.userProfileData.haveChildren =
                                          newValue;
                                      checkFields();
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: chldrnState
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<bool>(
                                              value: description,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            );
                          }),
                          CustomInputDecoration().errorBox(childrenErr),

                          CustomInputDecoration().subtitleText(
                              LocaleKeys.user_badHabits.tr(),
                              isFieldRequired: false),
                          Visibility(
                            visible: widget._isBadHabitsCheckboxOn == false,
                            child: CustomizableMultiselectField(
                              decoration: CustomInputDecoration().GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              customizableMultiselectWidgetOptions:
                                  CustomizableMultiselectWidgetOptions(
                                      hintText: Text(
                                          LocaleKeys.common_chooseOptions.tr(),
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                      chipShape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      chipColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                              customizableMultiselectDialogOptions:
                                  CustomizableMultiselectDialogOptions(
                                      okButtonLabel:
                                          LocaleKeys.common_confirm.tr(),
                                      cancelButtonLabel:
                                          LocaleKeys.common_cancel.tr(),
                                      enableSearchBar: false),
                              dataSourceList: [
                                DataSource<String>(
                                  dataList: GlobalStrings.getBadHabits(),
                                  valueList:
                                      widget.userProfileData.badHabits ?? [],
                                  options: DataSourceOptions(
                                    valueKey: 'value',
                                    labelKey: 'label',
                                  ),
                                ),
                              ],
                              onChanged: ((List<List<dynamic>> value) {
                                widget.userProfileData.badHabits = [];
                                for (int i = 0; i < value[0].length; i++) {
                                  widget.userProfileData.badHabits!
                                      .add(value[0][i]);
                                }
                                checkFields();
                              }),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 1.0, color: Colors.grey),
                                ),
                                value: widget._isBadHabitsCheckboxOn,
                                onChanged: (value) {
                                  widget._isBadHabitsCheckboxOn =
                                      widget._isBadHabitsCheckboxOn == false;
                                  widget.userProfileData.badHabits = [];
                                  checkFields();
                                },
                              ),
                              Text(
                                LocaleKeys.badHabbits_missing.tr(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),

                          CustomInputDecoration()
                              .subtitleText(LocaleKeys.user_aboutMe.tr()),
                          Focus(
                            child: TextField(
                              maxLength: 1500,
                              maxLines: 10,
                              minLines: 1,
                              decoration: CustomInputDecoration(
                                hintText: widget.userProfileData.about ?? "",
                              ).GetDecoration(
                                  Theme.of(context).colorScheme.primary),
                              controller: TextEditingController(
                                  text: widget.userProfileData.about),
                              onChanged: (value) {
                                needUpdate = true;
                                widget.userProfileData.about = value;
                              },
                              onSubmitted: (value) {
                                widget.userProfileData.about = value;
                                checkFields();
                                setState(() {});
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                setState(() {});
                              }
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.user_interests.tr(),
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 33, 33, 33),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: LocaleKeys.common_change.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    UpdateInterests(
                                                        widget.userProfileData),
                                                transitionDuration:
                                                    const Duration(seconds: 0),
                                              ),
                                            ).then((_) => {
                                                  setState(() {
                                                    widget._getUserInfo();
                                                  })
                                                });
                                          }),
                                  ],
                                ),
                              )
                            ],
                          ),
                          _interestTags(context),
                          // DonateButton(),
                          const SizedBox(height: 24),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              _showDeleteAccountAlertDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color:
                                        Color.fromARGB(255, 0xF4, 0x43, 0x36),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    LocaleKeys
                                        .profileScreen_settings_deleteAccount
                                        .tr(),
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          255, 0xF4, 0x43, 0x36),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Visibility(
                      visible: needUpdate,
                      child: FloatingActionButton(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          updateUserData();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

//==============================================================================
// Описание поля с отображением интересов
  Widget _interestTags(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 12,
        runSpacing: 5,
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: notUsedChips(),
      ),
    );
  }

  List<Widget> notUsedChips() {
    List<String> tagList = [];
    if (widget.userProfileData.interests != null) {
      tagList = widget.userProfileData.interests!.toList();
    }
    List<Widget> chips = [];
    for (int i = 0; i < tagList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(0),
        child: ChoiceChip(
          selected: true,
          checkmarkColor: Colors.black,
          label: Text(
            showTagLabelCurrentLocale(tagList[i]),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          selectedColor: tagsColors[Random().nextInt(tagList.length) % 7],
          labelStyle: const TextStyle(color: Colors.black),
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

//==============================================================================

  Widget _gender(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
          height: 60,
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: InkWell(
                      onTap: () {
                        widget.userProfileData.gender = "male";
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.userProfileData.gender == "male"
                                ? Colors.green
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topLeft: Radius.circular(12))),
                        child: Text(LocaleKeys.user_gender.tr(gender: "male"),
                            style: TextStyle(
                              color: widget.userProfileData.gender == "male"
                                  ? Colors.white
                                  : Colors.green,
                              fontSize: 17,
                            )),
                      ))),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        widget.userProfileData.gender = "female";
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.userProfileData.gender == "female"
                                ? Colors.green
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Text(LocaleKeys.user_gender.tr(gender: "female"),
                            style: TextStyle(
                                color: widget.userProfileData.gender == "female"
                                    ? Colors.white
                                    : Colors.green,
                                fontSize: 17)),
                      ))),
            ],
          )),
    );
  }

  String translateCountryName(String str) {
    try {
      if (context.locale.languageCode == "en") {
        str = countryListEn[countryList.indexOf(str)];
      }
      return str;
    } catch (err) {
      return str;
    }
  }

  List<String> getCountry(String str) {
    List<String> finded = <String>[];
    if (context.locale.languageCode == "en") {
      for (int i = 0; i < countryListEn.length; i++) {
        if (countryListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(countryList[i]);
        }
      }
    } else {
      for (int i = 0; i < countryList.length; i++) {
        if (countryList[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(countryList[i]);
        }
      }
    }
    return finded;
  }

  String translateNationName(String str) {
    try {
      if (context.locale.languageCode == "en") {
        str = nationalityListEn[nationalityList.indexOf(str)];
      }
      return str;
    } catch (err) {
      return str;
    }
  }

  List<String> getNationalityy(String str) {
    List<String> finded = <String>[];
    if (context.locale.languageCode == "en") {
      for (int i = 0; i < nationalityListEn.length; i++) {
        if (nationalityListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityListEn[i]);
        }
      }
    } else {
      for (int i = 0; i < nationalityListEn.length; i++) {
        if (nationalityList[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityList[i]);
        }
      }
    }

    return finded;
  }

  final String initialCountry = 'RU';
  late PhoneNumber number;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  Widget userPhoneNumber() {
    number = PhoneNumber(
        phoneNumber: widget.userProfileData.contactPhoneNumber, isoCode: "RU");
    return Form(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 218, 216, 215),
              width: 1, //                   <--- border width here
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0) //                 <--- border radius here
                ),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternationalPhoneNumberInput(
                  inputBorder: InputBorder.none,
                  searchBoxDecoration: const InputDecoration(
                    hintText: "Введите название страны или ее код",
                  ),
                  onInputChanged: (PhoneNumber temp) {
                    number = temp;
                    //debugPrint(number.toString());
                  },
                  onFieldSubmitted: (String value) {
                    debugPrint(number.toString());
                    widget.userProfileData.contactPhoneNumber =
                        number.toString();
                    checkFields();
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  hintText: number.phoneNumber,
                  maxLength: 13,
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                ),
              ],
            ),
          )),
    );
  }

  void _showDeleteAccountAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_cancel.tr()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = TextButton(
      child: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_confirm.tr()),
      onPressed: () async {
        try {
          await NetworkService().deleteAccount(
              accessToken: (context.read<ProfileBloc>().state as ProfileInitial)
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
        } catch (_) {
          Navigator.of(context).pop();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_header.tr()),
      content: Text(
        LocaleKeys.profileScreen_settings_deleteAccountAlert_msg.tr(),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
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
