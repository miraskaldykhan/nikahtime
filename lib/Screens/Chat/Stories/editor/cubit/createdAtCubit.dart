import 'package:flutter_bloc/flutter_bloc.dart';

class TextCubit extends Cubit<DateTime> {
  TextCubit() : super(DateTime.now());

  void updateText(DateTime newDate) => emit(newDate);
}
