library overlay_tutorial;

import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'src/overlay_tutorial_controller.dart';

part 'src/overlay_tutorial_entry.dart';

/// Widget for displaying an overlay on top of UI. Provide [OverlayTutorialEntry]
/// for holes.
///
/// To get started, create a [GlobalKey] key for widget that you need to make
/// entry and assign it to the widget's [Widget.key] property. Use the same
/// key for [OverlayTutorialEntry.widgetKey].
///
/// Create a [OverlayTutorialController] and assign to
/// [OverlayTutorial.controller]. You will be able to show and hide the
/// overlay tutorial with the controller.
class OverlayTutorial extends StatefulWidget {
  /// Used to wrap all the content containing widgets that would be used in
  /// [overlayTutorialEntries].
  ///
  /// If you use [SafeArea], pass [context] to avoid incorrect behaviour.
  final Widget child;

  /// All the widget entries that needs hole.
  final List<OverlayTutorialEntry> overlayTutorialEntries;

  /// This is used to show/hide this overlay tutorial.
  final OverlayTutorialController controller;

  /// The color of overlay.
  final Color overlayColor;

  /// This is rendered by stacking all widgets on top of the overlay entries.
  final List<Widget> overlayChildren;

  /// [context] is used for calculating [SafeArea] top padding.
  ///
  /// Do ensure that ancestor of [context] does not have [SafeArea].
  final BuildContext context;

  /// Defines how long will it take for the next retrieving widget position &
  /// building entry(s).
  ///
  /// Defaults to 200 milliseconds.
  final Duration refreshRate;

  OverlayTutorial({
    Key key,
    this.child,
    this.overlayTutorialEntries = const [],
    OverlayTutorialController controller,
    this.overlayColor,
    this.overlayChildren = const [],
    this.context,
    this.refreshRate = const Duration(milliseconds: 200),
  })  : controller = controller ?? OverlayTutorialController(),
        assert(refreshRate != null),
        super(key: key);

  @override
  _OverlayTutorialState createState() => _OverlayTutorialState();
}

class _OverlayTutorialState extends State<OverlayTutorial> {
  bool _showOverlay = false;
  final ValueNotifier<Map<GlobalKey, Rect>> entryRectsListenable =
      ValueNotifier({});

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  void showOverlayTutorial() {
    if (!_showOverlay) {
      setState(() {
        _showOverlay = true;
      });
    }
  }

  void hideOverlayTutorial() {
    if (_showOverlay) {
      setState(() {
        _showOverlay = false;
      });
    }
  }

  void retrieveEntryRects() {
    final parentContext = widget.context;

    final overlayTutorialEntries = widget.overlayTutorialEntries;
    final entryRects = entryRectsListenable.value;
    entryRects.removeWhere(
        (key, value) => !overlayTutorialEntries.any((x) => x.widgetKey == key));
    overlayTutorialEntries.forEach((entry) {
      final renderBox =
          entry.widgetKey.currentContext?.findRenderObject() as RenderBox;

      if (renderBox == null) return;
      final topSafeArea = parentContext != null &&
              context?.findAncestorWidgetOfExactType<SafeArea>() != null
          ? MediaQuery.of(parentContext).padding.top
          : 0.0;

      final rect =
          (renderBox.localToGlobal(Offset.zero) - Offset(0, topSafeArea)) &
              renderBox.size;
      final cachedEntryRect = entryRects[entry.widgetKey];
      if (cachedEntryRect == rect) return;
      entryRects.update(
        entry.widgetKey,
        (value) => rect,
        ifAbsent: () => rect,
      );
    });

    entryRectsListenable.value = Map.from(entryRects);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        if (_showOverlay) ...[
          _TutorialPaint(overlayTutorialState: this),
          ...widget.overlayTutorialEntries
              .map((entry) {
                return entry.overlayTutorialHints.map((hint) {
                  final entryRect = entryRectsListenable.value[entry.widgetKey];
                  if (entryRect == null) return const SizedBox.shrink();

                  final rRect = entry is OverlayTutorialRectEntry
                      ? OverlayTutorialRectEntry.applyDesignToEntry(
                          context,
                          entryRect,
                          entry,
                        )
                      : null;
                  if (hint.position == null)
                    return hint.builder(context, entryRect, rRect);

                  final position = hint.position(entryRect);

                  return Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: hint.builder(
                      context,
                      entryRect,
                      rRect,
                    ),
                  );
                }).toList();
              })
              .expand((x) => x)
              .toList(),
          ...widget.overlayChildren,
        ],
      ],
    );
  }
}

class _TutorialPaint extends StatefulWidget {
  final _OverlayTutorialState overlayTutorialState;

  const _TutorialPaint({
    Key key,
    this.overlayTutorialState,
  }) : super(key: key);

  @override
  __TutorialPaintState createState() => __TutorialPaintState();
}

class __TutorialPaintState extends State<_TutorialPaint> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer =
          Timer.periodic(widget.overlayTutorialState.widget.refreshRate, (_) {
        widget.overlayTutorialState.retrieveEntryRects();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlayTutorialEntries =
        widget.overlayTutorialState.widget.overlayTutorialEntries;
    final overlayColor = widget.overlayTutorialState.widget.overlayColor;

    return CustomPaint(
      size: const Size.square(double.infinity),
      foregroundPainter:
          widget.overlayTutorialState.entryRectsListenable.value.isEmpty
              ? null
              : _TutorialPainter(
                  context,
                  overlayTutorialEntries: overlayTutorialEntries,
                  entryRects: widget.overlayTutorialState.entryRectsListenable,
                  overlayColor: overlayColor,
                ),
    );
  }
}

class _TutorialPainter extends CustomPainter {
  final BuildContext context;
  final List<OverlayTutorialEntry> overlayTutorialEntries;
  final Color overlayColor;
  final ValueNotifier<Map<GlobalKey, Rect>> entryRects;

  _TutorialPainter(
    this.context, {
    this.overlayTutorialEntries = const [],
    this.overlayColor,
    this.entryRects,
  }) : super(repaint: entryRects);

  @override
  void paint(Canvas canvas, Size size) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var path = Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));

    path = _drawTutorialEntries(canvas, path);

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = this.overlayColor ??
        (isDarkTheme
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.6));
    canvas.drawPath(
      path,
      Paint()..color = overlayColor,
    );
  }

  Path _drawTutorialEntries(Canvas canvas, Path path) {
    overlayTutorialEntries.forEach((entry) {
      final rect = entryRects.value[entry.widgetKey];
      if (rect == null) return;

      if (entry is OverlayTutorialRectEntry) {
        final rRectToDraw = OverlayTutorialRectEntry.applyDesignToEntry(
          context,
          rect,
          entry,
        );

        // Draw Overlay Tutorial Rect Entry

        path = Path.combine(
          PathOperation.difference,
          path,
          Path()..addRRect(rRectToDraw),
        );
      } else if (entry is OverlayTutorialCircleEntry) {
        // Draw Overlay Tutorial Circle Entry

        path = Path.combine(
          PathOperation.difference,
          path,
          Path()
            ..addOval(
              OverlayTutorialCircleEntry.applyDesignToEntry(
                rect,
                entry,
              ),
            ),
        );
      } else if (entry is OverlayTutorialCustomShapeEntry) {
        path = entry.shapeBuilder?.call(rect, path);
      }
    });

    return path;
  }

  @override
  bool shouldRepaint(_TutorialPainter oldDelegate) =>
      oldDelegate.overlayColor != overlayColor ||
      oldDelegate.context != context ||
      !ListEquality()
          .equals(oldDelegate.overlayTutorialEntries, overlayTutorialEntries) ||
      !MapEquality().equals(oldDelegate.entryRects.value, entryRects.value);
}
