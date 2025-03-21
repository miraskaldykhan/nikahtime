import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class BackgroundImageScreen extends StatefulWidget {
  @override
  State<BackgroundImageScreen> createState() => _BackgroundImageScreenState();
}

class _BackgroundImageScreenState extends State<BackgroundImageScreen> {
  final List<bool> switchStates = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final List<int> indicesWithSwitch = [2, 3, 6];

  @override
  Widget build(BuildContext context) {
    final options = [
      LocaleKeys.tariffs_option1.tr(),
      LocaleKeys.tariffs_option2.tr(),
      LocaleKeys.tariffs_option3.tr(),
      LocaleKeys.tariffs_option4.tr(),
      LocaleKeys.tariffs_option5.tr(),
      LocaleKeys.tariffs_option6.tr(),
      LocaleKeys.tariffs_option7.tr(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2)),
                      child: SvgPicture.asset('assets/icons/back.svg',
                          color: Colors.black, fit: BoxFit.none),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 50),

                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/tariff.png',
                      width: 234,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Описание
                  Text(
                    LocaleKeys.tariffs_description.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2),
                  ),
                  const SizedBox(height: 20),
                  // Список
                  Text(
                    LocaleKeys.tariffs_header.tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final bool hasSwitch =
                            indicesWithSwitch.contains(index);
                        return ListTile(
                          dense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          leading: hasSwitch
                              ? Switch(
                                  activeColor: Color(0xff0EFF6E),
                                  inactiveThumbColor: Colors.black,
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white,
                                  value: switchStates[index],
                                  onChanged: (bool value) {
                                    setState(() {
                                      switchStates[index] = value;
                                    });
                                  },
                                )
                              : SvgPicture.asset('assets/icons/item.svg'),
                          title: Text(
                            options[index],
                            style: const TextStyle(
                                color: Colors.black,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Кнопка
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              LocaleKeys.tariffs_alertTitle.tr(),
                            ),
                            content: Text(
                              LocaleKeys.tariffs_alertContent.tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Закрыть диалог после удаления
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 6),
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
                                    "ОK",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0EFF6E),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 12,
                                color:
                                    const Color(0xFF0000001F).withOpacity(0.12),
                                offset: const Offset(0, 0))
                          ]),
                      child: Text(
                        LocaleKeys.tariffs_button.tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      LocaleKeys.tariffs_canCancel.tr(),
                      style: TextStyle(color: Color(0xFF111111), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
