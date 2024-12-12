import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/generated/locale_keys.g.dart';

Widget newsListWaitBox(Color color) {
  return _waitBox(label: LocaleKeys.news_loading_feed.tr(),  color: color);
}

Widget singleNewsWaitBox(Color color) {
  return _waitBox(label: LocaleKeys.news_loading_news.tr(), color: color);
}

Widget answersWaitBox(Color color) {
  return _waitBox(label: LocaleKeys.news_loading_commentaries.tr(),  color: color);
}

Widget _waitBox({required String label, required Color color}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(color!),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          label,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    ),
  );
}
