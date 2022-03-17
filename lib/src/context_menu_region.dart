// Helper widget, to dispatch Notifications when a right-click is detected on some child
import 'package:flutter/widgets.dart';
import '../context_menus.dart';

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class ContextMenuRegion extends StatelessWidget {
  const ContextMenuRegion(
      {Key? key,
      required this.child,
      required this.contextMenu,
      this.useLocalPosition = false,
      this.positionerFunc,
      this.onTapUp,
      this.isEnabled = true,
      this.enableLongPress = true})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final bool isEnabled;
  final bool useLocalPosition;
  final bool enableLongPress;
  final Offset Function(Offset touchPosition)? positionerFunc;
  final void Function(Offset touchPosition)? onTapUp;

  @override
  Widget build(BuildContext context) {
    void showMenu(Offset position) =>
        context.contextMenuOverlay.show(contextMenu, position);
    if (isEnabled == false) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        Offset posToUse =
            useLocalPosition ? details.localPosition : details.globalPosition;
        Offset showPos =
            positionerFunc == null ? posToUse : positionerFunc!(posToUse);
        showMenu(showPos);
      }, //(showMenu),
      onLongPressStart: enableLongPress
          ? (details) {
              Offset posToUse = useLocalPosition
                  ? details.localPosition
                  : details.globalPosition;
              Offset showPos =
                  positionerFunc == null ? posToUse : positionerFunc!(posToUse);
              showMenu(showPos);
            }
          : null,
      onTapUp: (details) {
        if (onTapUp != null) {
          onTapUp!(details.localPosition);
        }
      },
      child: child,
    );
  }
}
