library overlay_tutorial;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'src/overlay_tutorial_controller.dart';

part 'src/overlay_tutorial_entry.dart';

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

  OverlayTutorial({
    Key key,
    this.child,
    this.overlayTutorialEntries = const [],
    OverlayTutorialController controller,
    this.overlayColor,
    this.overlayChildren = const [],
    this.context,
  })  : controller = controller ?? OverlayTutorialController(),
        super(key: key);

  @override
  _OverlayTutorialState createState() => _OverlayTutorialState();
}

class _OverlayTutorialState extends State<OverlayTutorial> {
  bool _showOverlay = false;
  final ValueNotifier<Map<GlobalKey, Rect>> _entryRects = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    _timingsCallback = (_){
      _retrieveEntryRects();
    };
    widget.controller._state = this;
  }

  void _retrieveEntryRects() {
    final parentContext = widget.context;

    final overlayTutorialEntries = widget.overlayTutorialEntries;
    final entryRects = _entryRects.value;
    entryRects.removeWhere(
        (key, value) => !overlayTutorialEntries.any((x) => x.widgetKey == key));
    overlayTutorialEntries.forEach((entry) {
      final renderBox =
          entry.widgetKey.currentContext?.findRenderObject() as RenderBox;

      if (renderBox == null) return;
      final topSafeArea = parentContext != null &&
              context.findAncestorWidgetOfExactType<SafeArea>() != null
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

    _entryRects.value = Map.from(entryRects);
    setState(() {});
  }

  TimingsCallback _timingsCallback;

  void showOverlayTutorial() {
    if (!_showOverlay) {
      SchedulerBinding.instance.addTimingsCallback(_timingsCallback);
      setState(() {
        _showOverlay = true;
      });
    }
  }

  void hideOverlayTutorial() {
    if (_showOverlay){
      SchedulerBinding.instance.removeTimingsCallback(_timingsCallback);
      setState(() {
        _showOverlay = false;
      });}
  }

  @override
  Widget build(BuildContext context) {
    if (!_showOverlay) return widget.child;
    return Stack(
      children: <Widget>[
        CustomPaint(
          child: widget.child,
          foregroundPainter: _TutorialPaint(
            context,
            overlayTutorialEntries: widget.overlayTutorialEntries,
            entryRects: _entryRects,
            overlayColor: widget.overlayColor,
          ),
        ),
        ...widget.overlayTutorialEntries
            .map((entry) {
              return entry.overlayTutorialHints.map((hint) {
                final entryRect = _entryRects.value[entry.widgetKey];
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
    );
  }
}

class _TutorialPaint extends CustomPainter {
  final BuildContext context;
  final List<OverlayTutorialEntry> overlayTutorialEntries;
  final Color overlayColor;
  final ValueNotifier<Map<GlobalKey, Rect>> entryRects;

  _TutorialPaint(
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
            ..addOval(OverlayTutorialCircleEntry.applyDesignToEntry(
              rect,
              entry,
            )),
        );
      } else if (entry is OverlayTutorialCustomShapeEntry) {
        path = entry.shapeBuilder?.call(rect, path);
      }
    });

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
