# context_menus
A package to show context menus on right-click or long-press.

## 🔨 Installation
```yaml
dependencies:
  context_menus: ^0.1.0
```

### ⚙ Import

```dart
import 'package:context_menus/context_menus.dart';
```

## 🕹️ Usage

To get started, wrap a `ContextMenuOverlay` around your main app or top-most view:

```dart
return ContextMenuOverlay(
  child: MaterialApp(...)
);
```

You can then use the `ContextMenuRegion` widget to wrap sections of the Widget tree that should trigger a context menu:
```dart
return ContextMenuRegion(
  enableLongPress: false,
  // LinkContextMenu is an example menu, provided with this package
  contextMenu: LinkContextMenu(url: 'http://flutter.dev'),
  child: TextButton(onPressed: () {}, child: Text("http://flutter.dev")),
),
```

`ContextMenuRegion` listens for right-click and (optionally) long-press events. It requires a `contextMenu` widget which will be shown when one of the input events is triggered.

While this package provides some default menus, buttons and a system for styling **it's important to note that the `contextMenu` can be any widget you like.** You are free to replace this all with your own menu content and just rely on the plugin for managing positioning and visibility.

## 💡 Custom Menus

### GenericContextMenu
The easiest way to create a custom menu is to use the `GenericContextMenu`. Just pass it a list of `ContextMenuButtonConfig`s and it will create a menu using the built in `ContextMenuButton` and `ContextMenuCard` widgets:
```dart
/// Custom Context Menu for an Image
ContextMenuRegion(
  contextMenu: GenericContextMenu(
    buttonConfigs: [
      ContextMenuButtonConfig(
        "View image in browser",
        onPressed: () => launch(_testImageUrl),
      ),
      ContextMenuButtonConfig(
        "Copy image path",
        onPressed: () => Clipboard.setData(ClipboardData(text: _testImageUrl)),
      )
    ],
  ),
  child: Image.network(_testImageUrl),
),
```

When using the `GenericContextMenu` the visual style of the buttons will be determined by the `ContextMenuOverlay.buttonStyle` property, but can also be overridden by `GenericContextMenu.buttonStyle`.

### ContextMenuStateMixin
Another easy way to create custom menus is to create a `StatefulWidget` and use the `ContextMenuStateMixin` along with the `cardBuilder` and `buttonBuilder` delegates.

You can see this in action with the existing `LinkContextMenu`:
```dart
class _LinkContextMenuState extends State<LinkContextMenu> with ContextMenuStateMixin {
  @override
  Widget build(BuildContext context) {
    // cardBuilder is provided to us by the mixin, we must pass it a list of children to layout
    return cardBuilder.call(
      context,
      [
        // buttonBuilder is also provided by the mixin, use it to build each btn
        buttonBuilder.call(
          context,
          // button builder needs a config, so it knows how to setup the btn
          ContextMenuButtonConfig(
            "Open link in new window",
            icon: widget.useIcons ? Icon(Icons.link, size: 18) : null,
            onPressed: () => handlePressed(context, _handleNewWindowPressed),
          ),
        ),
        buttonBuilder.call(
          context,
          ContextMenuButtonConfig(
            "Copy link address",
            icon: widget.useIcons ? Icon(Icons.copy, size: 18) : null,
            onPressed: () => handlePressed(context, _handleClipboardPressed),
          ),
        )
      ],
    );
  }
```

In the above example, you could provide your own Card and Buttons directly, rather than using the builders, but the builders give you a couple of advantages:
* You can globally style all menus by editing the builders on `ContextMenuOverlay`
* All buttons will auto-close the context menu when triggered, as is standard behavior
* Your custom menus will match the `LinkMenu` and `GenericContextMenu` that come with this package

### Provide your own widget
If you would like to just use your own set of menus and skip the builders, just pass it in:
```dart
ContextMenuRegion(
  contextMenu: Container(width: 150, child: Column(children: [ ... ])),
  child: ...,
),
```

Note that if you are providing your own menu from scratch, you are responsible for setting horizontal constraints on the menu, and also closing the menu when items are pressed. At this point the plugin will only be handling positioning of the content near the mouse, and showing the content on right-click or long-press.

## ✨ ️Styling

You have three options to modify styling
* pass a `ContextMenuButtonStyle` to `ContextMenuOverlay` for small styling tweaks
* use your own `cardBuilder` or `buttonBuilder` delegate for more control
* pass your own custom menu widgets for total control

For basic styling, just pass button styling values to the `ContextMenuOverlay`:
```dart
return ContextMenuOverlay(
    buttonStyle: ContextMenuButtonStyle(
      fgColor: Colors.green,
      bgColor: Colors.green.shade100,
      hoverFgColor: Colors.green,
      hoverBgColor: Colors.green.shade200,
    ),
    child: MaterialApp(...);
}
```

For more control, you can overide the `cardBuilder` and `buttonBuilder` delegates and optionally use the provided styling values:
```dart
return ContextMenuOverlay(
  /// Make a custom background
  cardBuilder: (_, children) => Container(color: Colors.purple.shade100, child: Column(children: children)),
  /// Make custom buttons
  buttonBuilder: (_, config, [__]) => TextButton(
    onPressed: config.onPressed,
    child: Container(width: double.infinity, child: Text(config.label)),
  ),
  child: MaterialApp( ... ),
);
```

As mentioned above, you can always just provide your custom menus directly to the `ContextMenuRegion` bypassing the provided styling system completely.

## 🛠️ Manual Control
 If you would like to manually show or close a menu you can look up the overlay and control it directly:
```dart
ContextMenuOverlay.of(context).show(Container(width: 100, height: 100, color: Colors.red))
...
ContextMenuOverlay.of(context).hide();
```

This can also be expressed with a shortcut extension on `BuildContext`:
```dart
context.contextMenuOverlay.close();
```

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on Github and we'll look into it. Pull request are welcome.

## 📃 License

MIT License
