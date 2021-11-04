/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

import 'package:flutter/material.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';

class DelayedItem extends StatefulWidget {
  const DelayedItem({Key? key}) : super(key: key);

  @override
  State<DelayedItem> createState() => _DelayedItemState();
}

class _DelayedItemState extends State<DelayedItem> {
  bool _isTutorialEnabled = true;

  bool _showDelayedWidget = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      _showDelayedWidget = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OverlayTutorialScope(
          enabled: _isTutorialEnabled,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Delayed item'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Hello world!'),
                ),
                OverlayTutorialHole(
                  enabled: true,
                  overlayTutorialEntry: OverlayTutorialRectEntry(
                    padding: const EdgeInsets.all(16),
                    overlayTutorialHints: [
                      OverlayTutorialWidgetHint(
                        position: (rect) => Offset(
                          0,
                          rect.bottom + 16,
                        ),
                        builder: (context, rect, rRect) => Text(
                          'Late test',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.yellow),
                        ),
                      ),
                    ],
                  ),
                  child: _showDelayedWidget
                      ? Container(
                          child: Text('I am here now!!!'),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
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
