# overlay_tutorial

A Flutter package for displaying overlay tutorial.

# Feature

- Allow to display an overlay tutorial with hole cropping.
- Allow to display hint aside hole.
- Allow to customize hole shape.

# Usage

Create a [GlobalKey] key for widget that you need to make
entry and assign it to the widget's [Widget.key] property. Use the same
key for [OverlayTutorialEntry.widgetKey].

# Full Usage

## Create a controller somewhere
```dart
final OverlayTutorialController _controller = OverlayTutorialController();
```

## Wrap your UI

```dart

SafeArea(
  child: OverlayTutorial(
    context: context,
    controller: _controller,
    overlayTutorialEntries: <OverlayTutorialEntry>[
      OverlayTutorialRectEntry(
        widgetKey: addButtonKey,
        padding: const EdgeInsets.all(8.0),
        radius: const Radius.circular(16.0),
        overlayTutorialHints: <OverlayTutorialWidgetHint>[
          OverlayTutorialWidgetHint(
            builder: (context, rect, rRect) {
              return Positioned(
                top: rRect.top - 24.0,
                left: rRect.left,
                child: Text(
                  'Try this out',
                  style: textTheme.bodyText2.copyWith(color: tutorialColor),
                ),
              );
            },
          ),
          OverlayTutorialWidgetHint(
            position: (rect) => Offset(0, rect.center.dy),
            builder: (context, rect, rRect) {
              return SizedBox(
                width: rRect.left,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          'Click here to add counter',
                          style: textTheme.bodyText2
                              .copyWith(color: tutorialColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      OverlayTutorialRectEntry(
        widgetKey: counterTextKey,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        radius: const Radius.circular(16.0),
        overlayTutorialHints: <OverlayTutorialWidgetHint>[
          OverlayTutorialWidgetHint(
            position: (rect) => Offset(0, rect.bottom),
            builder: (context, rect, rRect) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Current Counter will be displayed here',
                      style: textTheme.bodyText2
                          .copyWith(color: tutorialColor),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      OverlayTutorialCustomShapeEntry(
        widgetKey: shareKey,
        shapeBuilder: (rect, path) {
          path = Path.combine(
            PathOperation.difference,
            path,
            Path()
              ..addOval(Rect.fromLTWH(
                rect.left - 16,
                rect.top,
                112,
                64,
              )),
          );
          return path;
        },
      ),
    ],
    overlayColor: Colors.blueAccent.withOpacity(.6),
    overlayChildren: <Widget>[],
    child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.share,
              key: shareKey,
              size: 64,
            ),
            const SizedBox(height: 64),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              key: counterTextKey,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: addButtonKey,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),
  ),
);
```

## Use the controller to control if the Tutorial should be shown

```dart
_controller.showOverlayTutorial();
```

# Hole Shape

- `OverlayTutorialRectEntry` draws a Rectangle shape
- `OverlayTutorialCircleEntry` draws a Circle shape
- `OverlayTutorialCustomShapeEntry` allows to draw a customized shape

# Screenshot

![](https://github.com/TabooSun/overlay_tutorial/blob/master/example/images/example_screenshot.png)

# API

Check [Dart Documentation](https://pub.dev/documentation/overlay_tutorial/latest/)

## License

[License](LICENSE).
