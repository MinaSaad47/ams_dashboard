import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopiableText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CopiableText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied `$text` to clipboard')),
        );
      },
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
