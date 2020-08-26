part of overlay_tutorial;

class OverlayTutorialEntry {
  /// The [GlobalKey] of the target widget that requires hole.
  final GlobalKey widgetKey;
  /// The padding of the hole.
  final EdgeInsetsGeometry padding;
  /// The radius of the hole.
  final Radius radius;
  /// Optional hint that can be placed beside the hole as the position of the
  /// target widget is provided. See [PositionFromEntryFactory] for detail.
  final List<OverlayTutorialWidgetHint> overlayTutorialHints;

  OverlayTutorialEntry({
    @required this.widgetKey,
    this.padding = EdgeInsets.zero,
    this.radius = Radius.zero,
    this.overlayTutorialHints = const [],
  });
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

class OverlayTutorialWidgetHint {
  final Widget child;

  /// The offset from a [OverlayTutorialEntry].
  /// If and only if this is null, [child] can be positioned by wrapping with
  /// [Positioned] or [Center].
  final PositionFromEntryFactory position;

  OverlayTutorialWidgetHint({
    this.position,
    @required this.child,
  });
}
