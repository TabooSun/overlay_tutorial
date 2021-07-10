/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

part of overlay_tutorial;

class OverlayTutorialScopeModel with EquatableMixin {
  /// The [BuildContext] of [OverlayTutorialHole].
  BuildContext? context;

  _RenderOverlayTutorialHole? renderProxyBox;

  /// A cached [Rect] of [OverlayTutorialHole].
  Rect? rect;

  bool checkShouldRebuild() {
    return rect != renderProxyBox!.computeChildRect();
  }

  void updateRectConfiguration() {
    renderProxyBox!.updateChildRect();
  }

  @override
  List<Object?> get props => [
        context,
        rect,
      ];
}
