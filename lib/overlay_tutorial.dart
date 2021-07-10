/*
 * Copyright (C) TabooSun and contributors - All Rights Reserved
 * Written by TabooSun <taboosun1996@gmail.com>, 2021.
 */

library overlay_tutorial;

import 'dart:collection';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'src/overlay_tutorial_entry.dart';

part 'src/widgets/overlay_tutorial_hole.dart';

part 'src/widgets/overlay_tutorial_scope.dart';

part 'src/model/overlay_tutorial_scope_model.dart';

typedef EntryRectCalculationFactory = void Function();
