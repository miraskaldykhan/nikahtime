import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:untitled/Screens/Chat/Stories/create/captured_file_editing.dart';

class TextPositionOfStory extends StatefulWidget {
  const TextPositionOfStory(
      {super.key, required this.textItem, required this.onLongPress});

  final EditableTextItem textItem;
  final VoidCallback onLongPress;

  @override
  State<TextPositionOfStory> createState() => _TextPositionOfStoryState();
}

class _TextPositionOfStoryState extends State<TextPositionOfStory> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.textItem.left,
      top: widget.textItem.top,
      child: GestureDetector(
        onDoubleTap: () {
          _changeTextColor(widget.textItem); // Изменение цвета по двойному тапу
        },
        onLongPress: widget.onLongPress,
        onPanUpdate: (details) {
          setState(() {
            widget.textItem.left += details.delta.dx;
            widget.textItem.top += details.delta.dy;
          });
        },
        child: Text(
          widget.textItem.text,
          style: TextStyle(
            fontSize: widget.textItem.fontSize,
            color: widget.textItem.color,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  void _changeTextColor(EditableTextItem textItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Выберите цвет текста"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: textItem.color,
              onColorChanged: (color) {
                setState(() {
                  textItem.color = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Готово"),
            ),
          ],
        );
      },
    );
  }
}
