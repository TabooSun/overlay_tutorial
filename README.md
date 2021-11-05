# overlay_tutorial

A Flutter package for displaying overlay tutorial.

# Feature

- Allow to display an overlay tutorial with hole cropping.
- Allow to display hint aside hole.
- Allow to customize hole shape.

# Usage

Wrap the widget that you want to create a hole using `OverlayTutorialHole`. Ensure you have `OverlayTutorialScope` as a parent of these holes. 

1. Use `OverlayTutorialScope.enabled` property to control the visibility of the overlay tutorial. If this is false, the entire overlay tutorial will be hidden.
2. Use `OverlayTutorialHole.enabled` property to control the visibility of the holes.

## Wrap your UI

```dart

Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final tutorialColor = Colors.yellow;
  return OverlayTutorialScope(
    enabled: true,
    overlayColor: Colors.blueAccent.withOpacity(.6),
    // overlayChildren: <Widget>[],
    child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _tweenAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _tweenAnimation,
                    child: child,
                  );
                },
                child: OverlayTutorialHole(
                  enabled: true,
                  overlayTutorialEntry: OverlayTutorialCustomShapeEntry(
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
                  child: Icon(
                    Icons.share,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Text(
                'You have pushed the button this many times:',
              ),
              OverlayTutorialHole(
                enabled: true,
                overlayTutorialEntry: OverlayTutorialRectEntry(
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
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: OverlayTutorialHole(
          enabled: true,
          overlayTutorialEntry: OverlayTutorialRectEntry(
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
                      style:
                          textTheme.bodyText2.copyWith(color: tutorialColor),
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
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ),
  );
};
```


# Hole Shape

- `OverlayTutorialRectEntry` draws a Rectangle shape
- `OverlayTutorialCircleEntry` draws a Circle shape
- `OverlayTutorialCustomShapeEntry` allows to draw a customized shape

# Disabling Widget

Disabling widget is not provided by this package out of the box. You can achieve this using one of the Flutter widget: `AbsorbPointer` or `IgnorePointer`. Make sure you do not wrap the `OverlayTutorialScope` with these widgets as this will disable the widget in `OverlayTutorialWidgetHint`.

# Screenshot

![](https://github.com/TabooSun/overlay_tutorial/blob/master/example/images/example_gif.gif)

# API

Check [Dart Documentation](https://pub.dev/documentation/overlay_tutorial/latest/)

## License

[License](LICENSE).
