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
  final HashMap<OverlayTutorialHole, OverlayTutorialScopeModel>
      _overlayTutorialHoles = HashMap();

  void _updateChildren() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() {});

      if (_checkIsParentRectUpdated()) {
        _updateChildren();
      }
    });
  }

  bool _checkIsParentRectUpdated() {
    return _overlayTutorialHoles.entries.any((element) {
      final rect = element.value.computeRect();
      if (rect != element.value.rect) {
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _OverlayTutorialBackbone(
          overlayColor: widget.overlayColor,
          enabled: widget.enabled,
          overlayTutorialHoles: _overlayTutorialHoles,
          onEntryRectCalculated: () {
            _updateChildren();
          },
          child: widget.child,
        ),
        if (widget.enabled) ...[
          ..._overlayTutorialHoles.entries
              .map((entry) {
                return entry.key.overlayTutorialEntry.overlayTutorialHints
                    .map((hint) {
                  final entryRect = entry.value.rect;
                  if (entryRect == null) return const SizedBox.shrink();

                  final overlayTutorialEntry = entry.key.overlayTutorialEntry;
                  if (overlayTutorialEntry is OverlayTutorialRectEntry) {
                    final rRect = OverlayTutorialRectEntry.applyDesignToEntry(
                      context,
                      entryRect,
                      overlayTutorialEntry,
                    );
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
                  } else {
                    return const SizedBox.shrink();
                  }
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

  /// See [OverlayTutorialScope.enabled] for detail.
  final bool enabled;

  /// See [_OverlayTutorialScopeState._overlayTutorialHoles] for detail.
  final HashMap<OverlayTutorialHole, OverlayTutorialScopeModel>
      overlayTutorialHoles;

  /// This is called each time the entry position and size is being calculated.
  ///
  /// This callback will provide the calculated [Rect].
  final EntryRectCalculationFactory onEntryRectCalculated;

  _OverlayTutorialBackbone({
    Key? key,
    this.overlayColor,
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

  HashMap<OverlayTutorialHole, OverlayTutorialScopeModel> _overlayTutorialHoles;

  /// See [_OverlayTutorialBackbone.overlayTutorialHoles] for detail.
  HashMap<OverlayTutorialHole, OverlayTutorialScopeModel>
      get overlayTutorialHoles => _overlayTutorialHoles;

  set overlayTutorialHoles(
      HashMap<OverlayTutorialHole, OverlayTutorialScopeModel> value) {
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
    required HashMap<OverlayTutorialHole, OverlayTutorialScopeModel>
        overlayTutorialHoles,
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
      // HACK: Add empty rect to path to overcome
      // the issue: https://github.com/TabooSun/overlay_tutorial/issues/15.
      // Remove it when there is any better solution or Flutter fixes it.

      if (kIsWeb) {
        path = Path.combine(
          PathOperation.difference,
          path,
          Path()..addRect(Rect.zero),
        );
      }

      final rect = entry.value.rect;
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
    overlayTutorialHoles.entries.forEach((entry) {
      entry.value.rect = entry.value.computeRect();
    });
    onEntryRectCalculated.call();
  }
}
