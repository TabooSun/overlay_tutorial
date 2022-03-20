/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

part of overlay_tutorial;

class OverlayTutorialHoleLayer extends ContainerLayer {
  final void Function() updateChildRect;

  OverlayTutorialHoleLayer({
    required this.updateChildRect,
  });

  @override
  void addToScene(ui.SceneBuilder builder) {
    super.addToScene(builder);
    _scheduleUpdate();
  }

  @override
  void attach(covariant Object owner) {
    super.attach(owner);
    _scheduleUpdate();
  }

  void _scheduleUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      updateChildRect();
    });
  }
}
