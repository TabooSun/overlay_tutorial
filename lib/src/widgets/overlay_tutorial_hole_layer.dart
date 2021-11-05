/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class OverlayTutorialHoleLayer extends ContainerLayer {
  final void Function() updateChildRect;

  OverlayTutorialHoleLayer({
    required this.updateChildRect,
  });

  @override
  void addToScene(ui.SceneBuilder builder, [Offset layerOffset = Offset.zero]) {
    super.addToScene(builder, layerOffset);
    _scheduleUpdate();
  }

  @override
  void attach(covariant Object owner) {
    super.attach(owner);
    _scheduleUpdate();
  }

  void _scheduleUpdate() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      updateChildRect();
    });
  }
}
