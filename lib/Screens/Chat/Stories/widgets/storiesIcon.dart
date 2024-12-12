import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class StoriesIconWidget extends StatelessWidget {
  const StoriesIconWidget({
    super.key,
    required this.profileUrl,
    this.isViewed = false,
  });

  final String? profileUrl;
  final bool isViewed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary.withOpacity(!isViewed ? 1:0.2),
            Theme.of(context).colorScheme.secondary.withOpacity(!isViewed ? 1:0.2)
          ]),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: profileUrl != null
            ? Image.network(
                profileUrl!,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/icons/1111.jpg',
                width: 46,
                height: 46,
              ),
      ),
    );
  }
}
