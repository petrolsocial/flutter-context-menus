// Helper widget, to dispatch Notifications when a right-click is detected on some child
import 'package:flutter/widgets.dart';
import '../context_menus.dart';

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class ContextMenuRegion extends StatelessWidget {
  const ContextMenuRegion(
      {Key? key,
      required this.child,
      required this.contextMenu,
      this.positionerFunc,
      this.isEnabled = true,
      this.enableLongPress = true})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final bool isEnabled;
  final bool enableLongPress;
  final Offset Function(Offset touchPosition)? positionerFunc;
  @override
  Widget build(BuildContext context) {
    void showMenu(Offset position) =>
        context.contextMenuOverlay.show(contextMenu, position);
    if (isEnabled == false) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        Offset showPos = positionerFunc == null
            ? details.globalPosition
            : positionerFunc!(details.globalPosition);
        showMenu(showPos);
      }, //(showMenu),
      onLongPressStart: enableLongPress
          ? (details) {
              Offset showPos = positionerFunc == null
                  ? details.globalPosition
                  : positionerFunc!(details.globalPosition);
              showMenu(showPos);
            }
          : null,
      child: child,
    );
  }
}
