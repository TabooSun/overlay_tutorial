library overlay_tutorial;

import 'dart:collection';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'src/overlay_tutorial_entry.dart';

part 'src/widgets/overlay_tutorial_hole.dart';

part 'src/widgets/overlay_tutorial_scope.dart';

typedef EntryRectCalculationFactory = void Function(
    HashMap<BuildContext, Rect>);
