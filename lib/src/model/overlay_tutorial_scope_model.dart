/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

part of overlay_tutorial;

class OverlayTutorialScopeModel with EquatableMixin {
  /// The [BuildContext] of [OverlayTutorialHole].
  final BuildContext? context;

  /// A cached [Rect] of [OverlayTutorialHole].
  final Rect? rect;

  final OverlayTutorialEntry overlayTutorialEntry;

  OverlayTutorialScopeModel({
    this.context,
    this.rect,
    required this.overlayTutorialEntry,
  });

  @override
  List<Object?> get props => [
        context,
        rect,
        overlayTutorialEntry,
      ];
}
