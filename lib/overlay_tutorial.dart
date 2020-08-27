library overlay_tutorial;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _entryRects = <GlobalKey, Rect>{};

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WidgetsBinding.instance.addPersistentFrameCallback(_onFrameUpdated);
    });
  }

  void _onFrameUpdated(timeStamp) {
    final parentContext = widget.context;

    _entryRects.removeWhere((key, value) =>
        !widget.overlayTutorialEntries.any((x) => x.widgetKey == key));
    widget.overlayTutorialEntries.forEach((entry) {
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
      final cachedEntryRect = _entryRects[entry.widgetKey];
      if (cachedEntryRect == rect) return;
      _entryRects.update(
        entry.widgetKey,
        (value) => rect,
        ifAbsent: () => rect,
      );
    });
    setState(() {});
  }

  void showOverlayTutorial() {
    if (!_showOverlay)
      setState(() {
        _showOverlay = true;
      });
  }

  void hideOverlayTutorial() {
    if (_showOverlay)
      setState(() {
        _showOverlay = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          child: widget.child,
          foregroundPainter: _showOverlay
              ? _TutorialPaint(
                  context,
                  overlayTutorialEntries: widget.overlayTutorialEntries,
                  entryRects: _entryRects,
                  overlayColor: widget.overlayColor,
                )
              : null,
        ),
        if (_showOverlay) ...[
          ...widget.overlayTutorialEntries
              .map((entry) {
                return entry.overlayTutorialHints.map((hint) {
                  final entryRect = _entryRects[entry.widgetKey];
                  if (entryRect == null) return const SizedBox.shrink();

                  final rRect = OverlayTutorialEntry.applyPaddingToWidgetEntry(
                    context,
                    entryRect,
                    entry,
                  );
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

class _TutorialPaint extends CustomPainter {
  final BuildContext context;
  final List<OverlayTutorialEntry> overlayTutorialEntries;
  final Color overlayColor;
  final Map<GlobalKey, Rect> entryRects;

  _TutorialPaint(
    this.context, {
    this.overlayTutorialEntries = const [],
    this.overlayColor,
    this.entryRects,
  });

  @override
  Future<void> paint(Canvas canvas, Size size) async {
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
      final rect = entryRects[entry.widgetKey];
      if (rect == null) return;

      final rRectToDraw = OverlayTutorialEntry.applyPaddingToWidgetEntry(
        context,
        rect,
        entry,
      );

      // Draw Overlay Tutorial Entry

      path = Path.combine(
        PathOperation.difference,
        path,
        Path()..addRRect(rRectToDraw),
      );
    });

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
