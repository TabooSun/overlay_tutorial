part of overlay_tutorial;

abstract class OverlayTutorialEntry {
  /// The [GlobalKey] of the target widget that requires hole.
  final GlobalKey widgetKey;

  /// Optional hint that can be placed beside the hole as the position of the
  /// target widget is provided. See [PositionFromEntryFactory] for detail.
  final List<OverlayTutorialWidgetHint> overlayTutorialHints;

  OverlayTutorialEntry({
    @required this.widgetKey,
    this.overlayTutorialHints = const [],
  });
}

/// Draw a hole as a circle on the widget.
class OverlayTutorialCircleEntry extends OverlayTutorialEntry {
  /// The radius of the hole.
  final double radius;

  /// See [OverlayTutorialEntry] for arguments detail.
  OverlayTutorialCircleEntry({
    @required GlobalKey widgetKey,
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    this.radius,
  }) : super(
          widgetKey: widgetKey,
          overlayTutorialHints: overlayTutorialHints,
        );

  static Rect applyDesignToEntry(
    Rect widgetRect,
    OverlayTutorialCircleEntry entry,
  ) {
    return Rect.fromCircle(
      center: widgetRect.center,
      radius: entry.radius,
    );
  }
}

/// Draw a hole as a rectangular on the widget.
class OverlayTutorialRectEntry extends OverlayTutorialEntry {
  /// The corner radius of the hole.
  final Radius radius;

  /// The padding of the hole.
  final EdgeInsetsGeometry padding;

  /// See [OverlayTutorialEntry] for arguments detail.
  OverlayTutorialRectEntry({
    @required GlobalKey widgetKey,
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    this.padding,
    this.radius,
  }) : super(
          widgetKey: widgetKey,
          overlayTutorialHints: overlayTutorialHints,
        );

  static RRect applyDesignToEntry(
    BuildContext context,
    Rect widgetRect,
    OverlayTutorialRectEntry entry,
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

/// * [rect] refers to the [Rect] of [OverlayTutorialEntry.widgetKey].
///
/// * [path] allows to be used for drawing custom shape of the [OverlayTutorialEntry].
typedef OverlayTutorialPaintFactory = Path Function(Rect rect, Path path);

/// Allows to draw custom shape as a hole on the widget.
class OverlayTutorialCustomShapeEntry extends OverlayTutorialEntry {
  /// Builder for building custom shape.
  final OverlayTutorialPaintFactory shapeBuilder;

  /// See [OverlayTutorialEntry] for arguments detail.
  OverlayTutorialCustomShapeEntry({
    @required GlobalKey widgetKey,
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    this.shapeBuilder,
  }) : super(
          widgetKey: widgetKey,
          overlayTutorialHints: overlayTutorialHints,
        );
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

/// * [rect] is the pure [Rect] of [OverlayTutorialEntry].
///
/// * [rRect] is a [RRect] which is a [Rect] of [OverlayTutorialEntry] with
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
