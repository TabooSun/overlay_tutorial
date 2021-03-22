part of overlay_tutorial;

/// Widget for displaying an overlay on top of UI.
///
/// [OverlayTutorialScope.child] needs to have [OverlayTutorialHole] as
/// descendants of [OverlayTutorialScope] (direct descendant is unnecessary.)
class OverlayTutorialScope extends StatefulWidget {
  /// The color of overlay.
  final Color? overlayColor;

  /// Whether to enable the overlay tutorial. If this is false, the
  /// [OverlayTutorialHole.enabled] is ignored.
  final bool enabled;

  /// This is rendered by stacking all widgets on top of the overlay entries.
  final List<Widget> overlayChildren;

  /// Holds [OverlayTutorialHole] as descendants of [OverlayTutorialScope].
  ///
  /// Note: Direct descendant is unnecessary.
  final Widget child;

  const OverlayTutorialScope({
    Key? key,
    this.overlayColor,
    this.enabled = false,
    required this.child,
    this.overlayChildren = const [],
  }) : super(key: key);

  @override
  _OverlayTutorialScopeState createState() => _OverlayTutorialScopeState();
}

class _OverlayTutorialScopeState extends State<OverlayTutorialScope> {
  /// Store all the dependants' [Rect] information.
  final HashMap<OverlayTutorialHole, BuildContext> _overlayTutorialHoles =
      HashMap();

  HashMap<BuildContext, Rect> _entryRects = HashMap();

  void updateChildren() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _OverlayTutorialBackbone(
          overlayColor: widget.overlayColor,
          enabled: widget.enabled,
          overlayTutorialHoles: _overlayTutorialHoles,
          onEntryRectCalculated: (entryRects) {
            _entryRects = entryRects;
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              updateChildren();
            });
          },
          child: widget.child,
        ),
        if (widget.enabled) ...[
          ..._overlayTutorialHoles.entries
              .map((entry) {
                return entry.key.overlayTutorialEntry.overlayTutorialHints
                    .map((hint) {
                  final overlayTutorialHoleContext = entry.value;
                  final entryRect = _entryRects[overlayTutorialHoleContext];
                  if (entryRect == null) return const SizedBox.shrink();

                  final overlayTutorialEntry = entry.key.overlayTutorialEntry;
                  final rRect = overlayTutorialEntry is OverlayTutorialRectEntry
                      ? OverlayTutorialRectEntry.applyDesignToEntry(
                          context,
                          entryRect,
                          overlayTutorialEntry,
                        )
                      : null;
                  if (hint.position == null)
                    return hint.builder(context, entryRect, rRect);

                  final position = hint.position!(entryRect);

                  return Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: hint.builder(
                      context,
                      entryRect,
                      rRect,
                    ),
                  );
                }).toList(growable: false);
              })
              .expand((x) => x)
              .toList(),
          ...widget.overlayChildren,
        ],
      ],
    );
  }
}

class _OverlayTutorialBackbone extends SingleChildRenderObjectWidget {
  /// See [OverlayTutorialScope.overlayColor] for detail.
  final Color? overlayColor;

  /// See [OverlayTutorialScope.context] for detail.
  final BuildContext? context;

  /// See [OverlayTutorialScope.enabled] for detail.
  final bool enabled;

  /// See [_OverlayTutorialScopeState._overlayTutorialHoles] for detail.
  final HashMap<OverlayTutorialHole, BuildContext> overlayTutorialHoles;

  /// This is called each time the entry position and size is being calculated.
  ///
  /// This callback will provide the calculated [Rect].
  final EntryRectCalculationFactory onEntryRectCalculated;

  _OverlayTutorialBackbone({
    Key? key,
    this.overlayColor,
    this.context,
    this.enabled = true,
    required this.overlayTutorialHoles,
    required Widget child,
    required this.onEntryRectCalculated,
  }) : super(
          key: key,
          child: child,
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverlayTutorialBackbone(
      context: context,
      overlayColor: overlayColor,
      enabled: enabled,
      overlayTutorialHoles: overlayTutorialHoles,
      onEntryRectCalculated: onEntryRectCalculated,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderOverlayTutorialBackbone renderObject,
  ) {
    renderObject
      ..context = context
      ..overlayColor = overlayColor
      ..enabled = enabled
      ..overlayTutorialHoles = overlayTutorialHoles
      ..onEntryRectCalculated = onEntryRectCalculated;
  }
}

class _RenderOverlayTutorialBackbone extends RenderProxyBox {
  /// Store all the dependants' [Rect] information.
  final HashMap<BuildContext, Rect> _entryRects = HashMap();

  @override
  bool get sizedByParent => false;

  Color? _overlayColor;

  Color? get overlayColor => _overlayColor;

  set overlayColor(Color? overlayColor) {
    if (_overlayColor == overlayColor) return;
    _overlayColor = overlayColor;
    markNeedsPaint();
  }

  BuildContext _context;

  BuildContext get context => _context;

  set context(BuildContext context) {
    if (_context == context) return;
    _context = context;
    markNeedsPaint();
  }

  bool _enabled;

  bool get enabled => _enabled;

  set enabled(bool enabled) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    markNeedsPaint();
  }

  HashMap<OverlayTutorialHole, BuildContext> _overlayTutorialHoles;

  /// See [_OverlayTutorialBackbone.overlayTutorialHoles] for detail.
  HashMap<OverlayTutorialHole, BuildContext> get overlayTutorialHoles =>
      _overlayTutorialHoles;

  set overlayTutorialHoles(HashMap<OverlayTutorialHole, BuildContext> value) {
    if (!MapEquality().equals(_overlayTutorialHoles, value)) {
      _overlayTutorialHoles = value;
      markNeedsPaint();
    }
  }

  EntryRectCalculationFactory _onEntryRectCalculated;

  EntryRectCalculationFactory get onEntryRectCalculated =>
      _onEntryRectCalculated;

  set onEntryRectCalculated(EntryRectCalculationFactory value) {
    if (_onEntryRectCalculated != value) {
      _onEntryRectCalculated = value;
      markNeedsPaint();
    }
  }

  _RenderOverlayTutorialBackbone({
    Color? overlayColor,
    required HashMap<OverlayTutorialHole, BuildContext> overlayTutorialHoles,
    required BuildContext context,
    required bool enabled,
    required EntryRectCalculationFactory onEntryRectCalculated,
    RenderBox? child,
  })  : _overlayColor = overlayColor,
        _context = context,
        _enabled = enabled,
        _overlayTutorialHoles = overlayTutorialHoles,
        _onEntryRectCalculated = onEntryRectCalculated,
        super(child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(ColorProperty('overlayColor', overlayColor));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(ObjectFlagProperty<EntryRectCalculationFactory>.has(
        'onEntryRectCalculated', onEntryRectCalculated));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    if (!enabled) return;

    final size = MediaQuery.of(this.context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    var path = Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    path = _drawTutorialEntries(this.context, path);

    final isDarkTheme = Theme.of(this.context).brightness == Brightness.dark;
    final overlayColor = this.overlayColor ??
        (isDarkTheme
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.6));
    context.canvas.drawPath(
      path,
      Paint()..color = overlayColor,
    );
  }

  Path _drawTutorialEntries(BuildContext context, Path path) {
    _calculateEntryRects();

    overlayTutorialHoles.entries.forEach((entry) {
      final overlayTutorialHoleContext = entry.value;
      final rect = _entryRects[overlayTutorialHoleContext];
      if (rect == null) return;

      final overlayTutorialEntry = entry.key.overlayTutorialEntry;
      if (overlayTutorialEntry is OverlayTutorialRectEntry) {
        final rRectToDraw = OverlayTutorialRectEntry.applyDesignToEntry(
          this.context,
          rect,
          overlayTutorialEntry,
        );

        if (rRectToDraw.hasNaN) return;
        // Draw Overlay Tutorial Rect Entry

        path = Path.combine(
          PathOperation.difference,
          path,
          Path()..addRRect(rRectToDraw),
        );
      } else if (overlayTutorialEntry is OverlayTutorialCircleEntry) {
        // Draw Overlay Tutorial Circle Entry

        final ovalRect = OverlayTutorialCircleEntry.applyDesignToEntry(
          rect,
          overlayTutorialEntry,
        );

        if (ovalRect.hasNaN) return;

        path = Path.combine(
          PathOperation.difference,
          path,
          Path()
            ..addOval(
              ovalRect,
            ),
        );
      } else if (overlayTutorialEntry is OverlayTutorialCustomShapeEntry) {
        path = overlayTutorialEntry.shapeBuilder.call(rect, path);
      }
    });

    return path;
  }

  void _calculateEntryRects() {
    _entryRects.clear();
    _entryRects
        .addAll(Map.fromEntries(overlayTutorialHoles.entries.map((entry) {
      final renderBox = entry.value.findRenderObject() as RenderBox?;

      if (renderBox == null) {
        return MapEntry(entry.value, Rect.zero);
      }

      return MapEntry(
        entry.value,
        (renderBox.localToGlobal(Offset.zero)) & renderBox.size,
      );
    })));

    onEntryRectCalculated.call(_entryRects);
  }
}
