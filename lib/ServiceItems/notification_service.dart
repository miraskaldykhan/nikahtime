import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class AppNotifications {
  static void showError({
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showBaseNotification(
      type: ToastificationType.error,
      description: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      duration: duration,
    );
  }

  static void showSuccess({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showBaseNotification(
      type: ToastificationType.success,
      title: title != null ? Text(title) : null,
      description: Text(
        message,
        style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
      duration: duration,
      alignment: Alignment.topCenter,
    );
  }

  static void showInfo({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showBaseNotification(
      type: ToastificationType.info,
      title: Text(
        title ?? 'Информация',
        style: TextStyle(
            fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w700),
      ),
      description: Text(
        message,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14.sp, color: Colors.white),
      ),
      duration: duration,
    );
  }

  static void _showBaseNotification({
    required ToastificationType type,
    Text? title,
    Text? description,
    Duration? duration,
    Alignment alignment = Alignment.topRight,
  }) {
    toastification.show(
      title: title,
      description: description,
      style: ToastificationStyle.fillColored,
      type: type,
      showProgressBar: false,
      autoCloseDuration: duration,
      alignment: alignment,
    );
  }
}
