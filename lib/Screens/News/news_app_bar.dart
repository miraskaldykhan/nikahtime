

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:untitled/generated/locale_keys.g.dart';

PreferredSizeWidget BackNavigateAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor:Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:BoxDecoration(
                border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                borderRadius: BorderRadius.circular(10)
                ),
            child: IconButton(
                splashRadius: 1,
                color: Theme.of(context).primaryColor ,
                iconSize: 20.0,
                padding: const EdgeInsets.all(0),
                icon: SvgPicture.asset('assets/icons/back.svg'),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
          ),
        ]
    ),
    automaticallyImplyLeading: false,
  );
}

PreferredSizeWidget simpleAppBarWithSearch(
  BuildContext context,
  {
    required Function onSearchAction
  }
)
{
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.news_header.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration:BoxDecoration(
                border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                borderRadius: BorderRadius.circular(10)
                ),
          child: IconButton(
            splashRadius: 1,
            iconSize: 20.0,
            padding: const EdgeInsets.all(0),
            icon:  SvgPicture.asset(
              'assets/icons/search.svg',
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              onSearchAction();

            }
          ),
        ),
      ]
    ),
    automaticallyImplyLeading: false,
  );
}


PreferredSizeWidget searchAppBar(BuildContext context,
  {
    required TextEditingController textEditingController,
    required Function onBackAction,
    required Function onClearAction,
    required Function onSubmitAction
  })
{
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
                border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                borderRadius: BorderRadius.circular(8)
                ),
          child: IconButton(
            splashRadius: 1,
            iconSize: 20.0,
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(0),
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              onBackAction();
            }
          ),
        ),
        const SizedBox(width: 8,),
        Flexible(
          flex: 1,
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1),
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
            ),
            child: Center(
              child: TextField(
                controller: textEditingController,
                cursorColor:  Theme.of(context).colorScheme.primary,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5, left: 10),
                  filled: true,
                  fillColor: const Color.fromRGBO(0x5A, 0x5A, 0xEE, 0),
                  suffixIcon: GestureDetector(
                    onTap: (){
                      onClearAction();
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  hintText: LocaleKeys.news_searchHint.tr(),
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(110, 122, 145, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(110, 122, 145, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  border:  UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide:  BorderSide(color:  Theme.of(context).colorScheme.secondary, width: 2),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: const BorderSide(color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: const BorderSide(color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                  ),
                ),
                onSubmitted: (value){
                  onSubmitAction(value);
                },
              ),
            ),
          )
        )
      ]
    ),
    automaticallyImplyLeading: false,
  );
}


BoxDecoration IconDecoration(BuildContext context) {
  return BoxDecoration(
    border: Border.all(
      width: 2.0,
      color:  Theme.of(context).colorScheme.secondary,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
  );
}