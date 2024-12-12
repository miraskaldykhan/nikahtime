import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar ({Key? key}) : super (key:key);

  final double barHeight = 72.0;
  double getStatusbarHeight(BuildContext context) {
    return MediaQuery
        .of(context)
        .padding
        .top;
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(barHeight + getStatusbarHeight(context)),
        child:AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  SvgPicture.asset(
                  'assets/icons/back.svg',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            
          ],
        )
      ),
    );
  }

  @override
  //TODO: + getStatusbarHeight(context)
  Size get preferredSize => Size.fromHeight(barHeight + 0);
}