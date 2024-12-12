import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomButton extends StatelessWidget {
  final String firstText;
  final String? firstIconPath;

  final String? secondText;
  final String? secondIconPath;

  final Function() firstOnPressed;
  final Function()? secondOnPressed;

  final bool isWhiteBackground;

  const BottomButton({
    Key? key,
    required this.firstText,
    required this.firstOnPressed,
    this.firstIconPath,
    this.secondText,
    this.secondIconPath,
    this.secondOnPressed,
    this.isWhiteBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _customContainer(
      child: _customColumn(),
    );
  }

  Widget _customContainer({required Widget child}) => Container(
        height: secondText == null ? 0.176.sh : 0.21.sh,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isWhiteBackground ? Colors.white : Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: child,
      );

  Widget _customColumn() => Column(
        children: List.generate(
          secondText == null ? 1 : 2,
          (index) {
            return Padding(
              padding: EdgeInsets.only(top: index == 1 ? 0.0147.sh : 0.0357.sh),
              child: _button(
                onPress: index == 0 ? firstOnPressed : secondOnPressed,
                btnText: index == 0 ? firstText : secondText!,
                btnIconPath: index == 0 ? firstIconPath : secondIconPath,
                btnColor: isWhiteBackground
                    ? Colors.green
                    : index == 0
                        ? Colors.white
                        : Colors.greenAccent,
                isSecondBtn: index == 0 ? false : true,
              ),
            );
          },
        ),
      );

  Widget _button({
    Function()? onPress,
    required Color btnColor,
    required String btnText,
    String? btnIconPath,
    bool isSecondBtn = false,
  }) =>
      SizedBox(
        width: isWhiteBackground ? 343.w : 301.w,
        height: 0.064.sh,
        child: ElevatedButton(
          onPressed: () => onPress!(),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 30.w),
            ),
            backgroundColor: MaterialStateProperty.all(btnColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          child: btnIconPath == null
              ? _textBtn(btnText, isSecond: isSecondBtn)
              : btnIconPath == "isVideo"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textBtn(btnText, isSecond: isSecondBtn),
                        _iconPngVideo(isSecond: isSecondBtn),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textBtn(btnText, isSecond: isSecondBtn),
                        _iconPngBtn(btnIconPath, isSecond: isSecondBtn),
                      ],
                    ),
        ),
      );

  Widget _textBtn(String text, {bool isSecond = false}) => Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: _textAndIconColor(isSecond),
          fontWeight:
              isSecond ?  FontWeight.w500 :  FontWeight.w600,
        ),
      );

  Widget _iconPngBtn(String path, {bool isSecond = false}) => Image.asset(
        path,
        color: _textAndIconColor(isSecond),
        width: 24.w,
        height: 24.h,
      );

  Widget _iconPngVideo({bool isSecond = false}) => Icon(
        Icons.video_collection,
        color: _textAndIconColor(isSecond),
      );

  Color _textAndIconColor(bool isSecond) => isWhiteBackground == false
      ? isSecond
          ? Colors.white
          : Colors.green
      : Colors.white;
}
