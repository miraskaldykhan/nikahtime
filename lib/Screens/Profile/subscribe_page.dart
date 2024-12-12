import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class BackgroundImageScreen extends StatelessWidget {
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  GestureDetector(
                    child:  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2)
                      ),
                      child: SvgPicture.asset('assets/icons/back.svg', color: Colors.black, fit: BoxFit.none),),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 50),

                  Container(
                    alignment: Alignment.center,
                    child:  Image.asset('assets/icons/tariff.png', 
                    width: 234,),
                  ),
                  const SizedBox(height: 40),
                  // Описание
                  Text(
                    LocaleKeys.tariffs_description.tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2
                      
                    ),
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
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          leading: SvgPicture.asset('assets/icons/item.svg'),
                          title: Text(
                            options[index],
                            style: const TextStyle(color: Colors.black, height: 1.1, fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        );
                      },  
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Кнопка
                  GestureDetector(
                    onTap: () {
                      // Действие при нажатии кнопки ОФОРМЛЕНИЕ ПОДПИСКИ
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
                            color: const Color(0xFF0000001F).withOpacity(0.12),
                            offset: const Offset(0,0)
                          )
                        ]
                      ),
                      child: Text(LocaleKeys.tariffs_button.tr(), style: const TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),),
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