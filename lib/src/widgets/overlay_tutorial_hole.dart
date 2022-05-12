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

  const OverlayTutorialHole({
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
    return RenderOverlayTutorialHole(
      overlayTutorialHole: this,
      context: context,
      overlayTutorialEntry: overlayTutorialEntry,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderOverlayTutorialHole renderObject,
  ) {
    renderObject
      ..context = context
      ..overlayTutorialEntry = overlayTutorialEntry
      ..enabled = enabled;
  }
}

class RenderOverlayTutorialHole extends RenderProxyBox {
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

  RenderOverlayTutorialHole({
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
  void paint(PaintingContext context, Offset offset) {
    if (!enabled || child == null) {
      super.paint(context, offset);
    } else {
      context.pushLayer(
        OverlayTutorialHoleLayer(
          updateChildRect: updateChildRect,
        ),
        super.paint,
        offset,
      );
    }

    updateChildRect();
  }

  void updateChildRect() {
    final overlayTutorialScopeState =
        context.findAncestorStateOfType<OverlayTutorialScopeState>();
    if (overlayTutorialScopeState == null) return;

    if (!enabled) {
      overlayTutorialScopeState._overlayTutorialHoles
          .remove(_overlayTutorialHole);
    } else {
      final newOverlayTutorialScopeModel = OverlayTutorialScopeModel(
        context: context,
        rect: computeChildRect(),
        overlayTutorialEntry: overlayTutorialEntry,
      );

      if (overlayTutorialScopeState._overlayTutorialHoles
              .containsKey(_overlayTutorialHole) &&
          overlayTutorialScopeState
                  ._overlayTutorialHoles[_overlayTutorialHole] ==
              newOverlayTutorialScopeModel) {
        return;
      }

      overlayTutorialScopeState._overlayTutorialHoles[_overlayTutorialHole] =
          newOverlayTutorialScopeModel;
    }

    overlayTutorialScopeState._updateChildren();
  }

  Rect computeChildRect() {
    if (child == null || !child!.hasSize || child!.size == Size.infinite) {
      return Rect.zero;
    }
    if (child!.localToGlobal(Offset.zero) == Offset.infinite) return Rect.zero;
    return child!.localToGlobal(Offset.zero) & child!.size;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<OverlayTutorialEntry>(
        'overlayTutorialEntry',
        overlayTutorialEntry,
      ),
    );
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<BuildContext>('context', context));
    properties.add(
      DiagnosticsProperty<OverlayTutorialHole>(
        '_overlayTutorialHole',
        _overlayTutorialHole,
      ),
    );
  }
}
