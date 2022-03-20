/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

part of overlay_tutorial;

/// Abstract class of Entry.
///
/// - See [OverlayTutorialCircleEntry] for circle shape entry.
/// - See [OverlayTutorialRectEntry] for rectangular shape entry.
/// - See [OverlayTutorialCustomShapeEntry] for custom shape entry.
abstract class OverlayTutorialEntry with EquatableMixin {
  /// Optional hint that can be placed beside the hole as the position of the
  /// target widget is provided. See [PositionFromEntryFactory] for detail.
  final List<OverlayTutorialWidgetHint> overlayTutorialHints;

  OverlayTutorialEntry({
    this.overlayTutorialHints = const [],
  });

  @override
  List<Object?> get props => [
        overlayTutorialHints,
      ];
}

/// Draw a hole as a circle on the widget.
class OverlayTutorialCircleEntry extends OverlayTutorialEntry {
  /// The radius of the hole.
  final double radius;

  /// See [OverlayTutorialEntry] for arguments detail.
  OverlayTutorialCircleEntry({
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    this.radius = 0.0,
  }) : super(
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

  @override
  List<Object?> get props =>
      super.props +
      [
        radius,
      ];
}

/// Draw a hole as a rectangular on the widget.
class OverlayTutorialRectEntry extends OverlayTutorialEntry {
  /// The corner radius of the hole.
  final Radius radius;

  /// The padding of the hole.
  final EdgeInsetsGeometry padding;

  /// See [OverlayTutorialEntry] for arguments detail.
  OverlayTutorialRectEntry({
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    this.padding = EdgeInsets.zero,
    this.radius = Radius.zero,
  }) : super(
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

  @override
  List<Object?> get props =>
      super.props +
      [
        radius,
        padding,
      ];
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
    List<OverlayTutorialWidgetHint> overlayTutorialHints = const [],
    required this.shapeBuilder,
  }) : super(
          overlayTutorialHints: overlayTutorialHints,
        );

  @override
  List<Object?> get props =>
      super.props +
      [
        shapeBuilder,
      ];
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

/// Builder factory for hint widget.
typedef WidgetFromEntryBuilder = Widget Function(
  BuildContext context,
  OverlayTutorialEntryRect entryRect,
);

/// This is used for placing custom widget aside your [OverlayTutorialEntry].
/// The [Rect] of the entry's widget is provided.
class OverlayTutorialWidgetHint<T extends OverlayTutorialEntryRect>
    with EquatableMixin {
  /// The builder for the hint.
  ///
  /// Impose [position] to the widget created by [builder] if [position] is not
  /// null; otherwise, [OverlayTutorialScope] renders the widget created by
  /// [builder] as it is.
  final WidgetFromEntryBuilder builder;

  /// The offset from a [OverlayTutorialEntry].
  ///
  /// If and only if this is null, you can wrap the widget before returning from
  /// [builder] with [Positioned], [Align] or [Center].
  final PositionFromEntryFactory? position;

  OverlayTutorialWidgetHint({
    this.position,
    required this.builder,
  });

  @override
  List<Object?> get props => [
        builder,
        position,
      ];
}

/// The [Rect] information of a [OverlayTutorialEntry].
class OverlayTutorialEntryRect {
  /// The pure [Rect] of [OverlayTutorialEntry].
  final Rect rect;

  /// [Rect] of [OverlayTutorialEntry] with
  /// [OverlayTutorialRectEntry.padding] & [OverlayTutorialRectEntry.radius]
  /// applied.
  ///
  /// This is null when entry is not [OverlayTutorialRectEntry].
  final RRect? rRect;

  OverlayTutorialEntryRect({
    required this.rect,
    this.rRect,
  });
}
