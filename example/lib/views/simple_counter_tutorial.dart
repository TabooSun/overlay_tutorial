/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

import 'package:flutter/material.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';

class SimpleCounterTutorial extends StatefulWidget {
  final String title;

  const SimpleCounterTutorial({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _SimpleCounterTutorialState createState() => _SimpleCounterTutorialState();
}

class _SimpleCounterTutorialState extends State<SimpleCounterTutorial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _tweenAnimation;

  bool _isTutorialEnabled = true;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tweenAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController
      ..repeat(
        reverse: true,
      ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tutorialColor = Colors.yellow;
    return Stack(
      children: [
        OverlayTutorialScope(
          enabled: _isTutorialEnabled,
          overlayColor: Colors.blueAccent.withOpacity(.6),
          child: AbsorbPointer(
            absorbing: _isTutorialEnabled,
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
                                        style: textTheme.bodyText2!
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
                              style: textTheme.bodyText2!
                                  .copyWith(color: tutorialColor),
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
                                      style: textTheme.bodyText2!
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
          ),
        ),
        if (_isTutorialEnabled)
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                _isTutorialEnabled = false;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
