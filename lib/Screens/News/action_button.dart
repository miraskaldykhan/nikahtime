import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/News/format_data.dart';

Widget button({
  required IconData iconData,
  required Color iconColor,
  Color backgroundColor = Colors.white,
  bool disableShadow = false,
  required int value,
  bool showZero = false,
  Function? action
})
{
  return GestureDetector(
    onTap: (){
      if(action != null) action();
    },
    child: Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
              visible: showZero || value != 0,
              child: Row(
                children: [
                  Text(
                    formatDigits(value),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromRGBO(0, 0, 0, 1)
                    ),
                  ),
                   const SizedBox(width: 6,),

                ],
              )
          ),
          Container(
            width: 20,
            child: Icon(
              iconData,
              size: 17,
              color: iconColor,
            ),
          ),

        ],
      ),
    ),
  );
}


