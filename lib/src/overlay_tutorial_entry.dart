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

  static RRect applyPaddingToWidgetEntry(
    BuildContext context,
    Rect widgetRect,
    OverlayTutorialEntry entry,
  ) {
    final padding = entry.padding.resolve(Directionality.of(context));
    return RRect.fromLTRBR(
      widgetRect.left - padding.left,
      widgetRect.top - padding.top,
      widgetRect.right + padding.right,
      widgetRect.bottom + padding.bottom,
      entry.radius,
    );
  }
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

/// [rect] is the pure [Rect] of [OverlayTutorialEntry].
/// [rRect] is a [RRect] which is a [Rect] of [OverlayTutorialEntry] with
/// [OverlayTutorialEntry.padding] & [OverlayTutorialEntry.radius] applied.
typedef WidgetFromEntryBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  RRect rRect,
);

class OverlayTutorialWidgetHint {
  final WidgetFromEntryBuilder builder;

  /// The offset from a [OverlayTutorialEntry].
  /// If and only if this is null, [child] can be positioned by wrapping with
  /// [Positioned] or [Center].
  final PositionFromEntryFactory position;

  OverlayTutorialWidgetHint({
    this.position,
    @required this.builder,
  });
}
