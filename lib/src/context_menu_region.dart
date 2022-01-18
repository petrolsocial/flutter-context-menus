// Helper widget, to dispatch Notifications when a right-click is detected on some child
import 'package:flutter/widgets.dart';
import '../context_menus.dart';

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class ContextMenuRegion extends StatelessWidget {
  const ContextMenuRegion(
      {Key? key,
      required this.child,
      required this.contextMenu,
      this.isEnabled = true,
      this.enableLongPress = true})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final bool isEnabled;
  final bool enableLongPress;
  @override
  Widget build(BuildContext context) {
    void showMenu(Offset localPosition) =>
        context.contextMenuOverlay.show(contextMenu, localPosition);
    if (isEnabled == false) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        showMenu(details.localPosition);
      }, //(showMenu),
      onLongPressStart: enableLongPress
          ? (details) {
              showMenu(details.localPosition);
            }
          : null,
      child: child,
    );
  }
}
