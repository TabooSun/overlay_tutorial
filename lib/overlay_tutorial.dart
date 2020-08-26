library overlay_tutorial;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'src/overlay_tutorial_controller.dart';

part 'src/overlay_tutorial_entry.dart';

class OverlayTutorial extends StatefulWidget {
  final Widget child;
  final List<OverlayTutorialEntry> overlayTutorialEntries;
  final OverlayTutorialController controller;
  final Color overlayColor;

  OverlayTutorial({
    Key key,
    this.child,
    this.overlayTutorialEntries,
    OverlayTutorialController controller,
    this.overlayColor,
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
    _entryRects.removeWhere((key, value) =>
        !widget.overlayTutorialEntries.any((x) => x.widgetKey == key));
    widget.overlayTutorialEntries.forEach((entry) {
      final renderBox =
          entry.widgetKey.currentContext?.findRenderObject() as RenderBox;
      if (renderBox == null) return;
      final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
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
    setState(() {
      _showOverlay = true;
    });
  }

  void hideOverlayTutorial() {
    setState(() {
      _showOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        try {
          for (final x in widget.overlayTutorialEntries) {
            for (final element in x.overlayTutorialHints
                .whereType<OverlayTutorialImageHint>()) {
              await element.loadUiImage();
            }
          }
        } catch (ex, stackTrace) {
          print(ex);
          print(stackTrace);
        }
      }),
      builder: (context, snapshot) => CustomPaint(
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
            ? Colors.white.withOpacity(0.6)
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

      final padding = entry.padding.resolve(Directionality.of(context));
      final rRectToDraw = RRect.fromLTRBR(
        rect.left + padding.left,
        rect.top + padding.top,
        rect.right + padding.right,
        rect.bottom + padding.bottom,
        entry.radius,
      );

      // Draw Overlay Tutorial Entry

      path = Path.combine(
        PathOperation.difference,
        path,
        Path()..addRRect(rRectToDraw),
      );

      entry.overlayTutorialHints.forEach((hint) {
        // Draw Overlay Tutorial Image

        if (hint is OverlayTutorialImageHint) {
          if (!hint.isImageReady) return;

          final image = hint.toUiImage();
          if (image == null) return;

          paintImage(
            canvas: canvas,
            image: image,
            rect: (rect.center + hint.positionFromEntry(rect)) &
                (hint.size ??
                    Size(
                      image.width.toDouble(),
                      image.height.toDouble(),
                    )),
            scale: hint.scale ?? 1.0,
          );
        }
      });
    });

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
