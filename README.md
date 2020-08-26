# overlay_tutorial

A Flutter package for displaying overlay tutorial.

## Feature

* Allow to display an overlay tutorial with hole cropping.
* Allow to display hint aside hole.

## Usage

```dart

 OverlayTutorial(
      controller: _controller,
      overlayTutorialEntries: <OverlayTutorialEntry>[
        OverlayTutorialEntry(
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
        OverlayTutorialEntry(
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
                        style: textTheme.bodyText2.copyWith(color: tutorialColor),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
        ), 
      ),
    );
```


## Screenshot

![](https://github.com/TabooSun/overlay_tutorial/blob/master/example/images/example_screenshot.png=250x)

## API

Check [Dart Documentation](https://pub.dev/documentation/overlay_tutorial/latest/)

## License

[License](LICENSE).
