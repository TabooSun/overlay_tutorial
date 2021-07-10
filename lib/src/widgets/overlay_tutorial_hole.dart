/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

part of overlay_tutorial;

/// Crop a hole on [child] by configuration in [overlayTutorialEntry].
class OverlayTutorialHole extends SingleChildRenderObjectWidget {
  /// Define the shape and hint information of this hole.
  final OverlayTutorialEntry overlayTutorialEntry;

  /// Whether to enable this hole to be cropped.
  ///
  /// See also [OverlayTutorialScope.enabled].
  final bool enabled;

  OverlayTutorialHole({
    Key? key,
    required this.overlayTutorialEntry,
    required this.enabled,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverlayTutorialHole(
      overlayTutorialHole: this,
      context: context,
      overlayTutorialEntry: overlayTutorialEntry,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderOverlayTutorialHole renderObject,
  ) {
    renderObject
      ..context = context
      ..overlayTutorialEntry = overlayTutorialEntry
      ..enabled = enabled;
  }
}

class _RenderOverlayTutorialHole extends RenderProxyBox {
  @override
  bool get sizedByParent => false;

  /// The widget that holds this [RenderProxyBox]. Theoretically, this won't
  /// change by any means.
  final OverlayTutorialHole _overlayTutorialHole;

  BuildContext _context;

  BuildContext get context => _context;

  set context(BuildContext context) {
    if (_context != context) {
      _context = context;
      markNeedsPaint();
    }
  }

  OverlayTutorialEntry _overlayTutorialEntry;

  OverlayTutorialEntry get overlayTutorialEntry => _overlayTutorialEntry;

  set overlayTutorialEntry(OverlayTutorialEntry value) {
    if (_overlayTutorialEntry != value) {
      _overlayTutorialEntry = value;
      markNeedsPaint();
    }
  }

  bool _enabled;

  bool get enabled => _enabled;

  set enabled(bool enabled) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    markNeedsPaint();
  }

  _RenderOverlayTutorialHole({
    required OverlayTutorialHole overlayTutorialHole,
    required BuildContext context,
    required OverlayTutorialEntry overlayTutorialEntry,
    required bool enabled,
    RenderBox? child,
  })  : _overlayTutorialHole = overlayTutorialHole,
        _context = context,
        _overlayTutorialEntry = overlayTutorialEntry,
        _enabled = enabled,
        super(child);

  @override
  void paint(PaintingContext paintingContext, Offset offset) {
    super.paint(paintingContext, offset);
    if (child == null) return;
    updateChildRect();
  }

  void updateChildRect() {
    final overlayTutorialScopeState =
        context.findAncestorStateOfType<_OverlayTutorialScopeState>();
    if (overlayTutorialScopeState == null) return;

    if (!overlayTutorialScopeState._overlayTutorialHoles
        .containsKey(_overlayTutorialHole)) {
      overlayTutorialScopeState._overlayTutorialHoles[_overlayTutorialHole] =
          OverlayTutorialScopeModel();
    }

    final overlayTutorialScopeModel =
        overlayTutorialScopeState._overlayTutorialHoles[_overlayTutorialHole]!;
    if (enabled) {
      overlayTutorialScopeState._overlayTutorialHoles[_overlayTutorialHole] =
          overlayTutorialScopeModel
            ..context = context
            ..rect = computeChildRect()
            ..renderProxyBox = this;
    } else {
      overlayTutorialScopeState._overlayTutorialHoles
          .remove(_overlayTutorialHole);
    }

    overlayTutorialScopeState._updateChildren();
  }

  Rect computeChildRect() {
    if (child == null || !child!.hasSize || child!.size == Size.infinite)
      return Rect.zero;
    if (child!.localToGlobal(Offset.zero) == Offset.infinite) return Rect.zero;
    return child!.localToGlobal(Offset.zero) & child!.size;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<OverlayTutorialEntry>(
        'overlayTutorialEntry', overlayTutorialEntry));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(DiagnosticsProperty<OverlayTutorialHole>(
        '_overlayTutorialHole', _overlayTutorialHole));
  }
}
