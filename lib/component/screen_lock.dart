import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class KeyLock extends StatelessWidget {
  final String tendigits;
  final String title;
  final bool showCancel;
  KeyLock(
      {super.key,
      required this.tendigits,
      required this.title,
      this.showCancel = true});

  final InputController ic = InputController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (key) {
        if (key is! KeyDownEvent) return;
        if (key.logicalKey == LogicalKeyboardKey.goBack && showCancel) {
          return Navigator.of(context).pop(false);
        }
        if (key.logicalKey == LogicalKeyboardKey.backspace) {
          ic.removeCharacter();
          return;
        } else {
          ic.addCharacter(key.character!);
        }
      },
      child: ScreenLock(
        title: Text(title),
        correctString: tendigits,
        cancelButton: !showCancel ? SizedBox() : null,
        inputController: ic,
        onCancelled:
            !showCancel ? null : () => Navigator.of(context).pop(false),
        onUnlocked: () => Navigator.of(context).pop(true),
      ),
    );
  }
}
