import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class KlingonText extends RichText {
  final TextStyle style;

  // Constructs a new KlingonText widget
  //
  // fromString: The source string, possibly containing {tlhIngan Hol mu'mey}
  // onTap: A callback to be run when links are tapped
  // style: The default style to apply to non-braced text

  KlingonText({String fromString, Function onTap, this.style}) : super(
    text: _ProcessKlingonText(fromString, onTap, style),
  );

  // Build a TextSpan containing 'src', with tet {in curly braces} formatted
  // appropriately.
  static TextSpan _ProcessKlingonText(String src, Function onTap(String),
      TextStyle style) {
    List<TextSpan> ret = [];
    String remainder = src;

    while (remainder.contains('{')) {
      // TODO handle URLs and other special text spans
      if (remainder.startsWith('{') && remainder.contains('}')) {
        int endIndex = remainder.indexOf('}');
        String klingon = remainder.substring(1, endIndex);
        List<String> klingonSplit = klingon.split(':');
        String textOnly = klingonSplit[0];
        String textType = klingonSplit.length > 1 ? klingonSplit[1] : null;
        String textFlags = klingonSplit.length > 2 ? klingonSplit[2] : null;

        bool serif = textType != null && textType != 'url';
        bool link = textFlags == null ||
            !textFlags.split(',').contains('nolink');
        TapGestureRecognizer recognizer = new TapGestureRecognizer();;

        remainder = remainder.substring(endIndex + 1);

        if (link && onTap != null) {
          recognizer.onTap = () {onTap(klingon);};
        }

        ret.add(new TextSpan(
          text: textOnly,
          style: new TextStyle(
            fontFamily: serif ? 'RobotoSlab' : style.fontFamily,
            decoration: link ? TextDecoration.underline : null,
            // TODO color coding, part of speech tagging
          ),
          recognizer: recognizer,
          // TODO handle tap
        ));
      } else {
        int endIndex = remainder.indexOf('{');

        ret.add(new TextSpan(text: remainder.substring(0, endIndex)));
        remainder = remainder.substring(endIndex);
      }
    }

    ret.add(new TextSpan(text: remainder));

    return new TextSpan(children: ret, style: style);
  }
}