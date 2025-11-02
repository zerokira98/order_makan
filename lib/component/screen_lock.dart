import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class KeyLock extends StatefulWidget {
  final String tendigits;
  final String title;
  final bool showCancel;
  const KeyLock(
      {super.key,
      required this.tendigits,
      required this.title,
      this.showCancel = true});

  @override
  State<KeyLock> createState() => _KeyLockState();
}

class _KeyLockState extends State<KeyLock> {
  final InputController ic = InputController();

  final FocusNode _focusNode = FocusNode(
    onKeyEvent: (node, event) {
      debugPrint('here focus');
      return KeyEventResult.handled;
    },
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (key) {
        debugPrint('keytpress');
        if (key is! KeyDownEvent) return;
        if (key.logicalKey == LogicalKeyboardKey.goBack && widget.showCancel) {
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
        title: Text(widget.title),
        correctString: widget.tendigits,
        cancelButton: !widget.showCancel ? SizedBox() : null,
        inputController: ic,
        onCancelled:
            !widget.showCancel ? null : () => Navigator.of(context).pop(false),
        onUnlocked: () => Navigator.of(context).pop(true),
      ),
    );
  }
}
