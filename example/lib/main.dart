import 'package:flutter/material.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final OverlayTutorialController _controller = OverlayTutorialController();
  final addButtonKey = GlobalKey(), counterTextKey = GlobalKey();

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.showOverlayTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tutorialColor = Colors.yellow;
    return OverlayTutorial(
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
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
