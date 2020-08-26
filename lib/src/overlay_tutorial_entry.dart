part of overlay_tutorial;

class OverlayTutorialEntry {
  final GlobalKey widgetKey;
  final EdgeInsetsGeometry padding;
  final Radius radius;
  final List<OverlayTutorialHint> overlayTutorialHints;

  OverlayTutorialEntry({
    @required this.widgetKey,
    this.padding = EdgeInsets.zero,
    this.radius = Radius.zero,
    this.overlayTutorialHints = const [],
  });
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
/// [target] is the [Size] of the [OverlayTutorialHint].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

abstract class OverlayTutorialHint {
  /// The offset from a [OverlayTutorialEntry].
  final PositionFromEntryFactory position;

  OverlayTutorialHint(this.position);
}

class OverlayTutorialWidgetHint extends OverlayTutorialHint {
  final Widget child;

  OverlayTutorialWidgetHint(
    PositionFromEntryFactory position, {
    @required this.child,
  }) : super(position);
}