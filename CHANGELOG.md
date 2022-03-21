## [2.2.2] - 21/03/2022

- Fix broken screenshot in README.

## [2.2.1] - 21/03/2022

- Fix [#36](https://github.com/TabooSun/overlay_tutorial/issues/36).

## [2.2.0] - 20/03/2022

- Fix [#34](https://github.com/TabooSun/overlay_tutorial/issues/34). `OverlayTutorialScope` never calls `OverlayTutorialWidgetHint` builder of `OverlayTutorialCustomShapeEntry`.
  ### Breaking API Changes
    - `WidgetFromEntryBuilder` no longer provides `rect` & `rRect`. We merged them into `entryRect` of
      type `OverlayTutorialEntryRect`.
        - Migration steps:
      
          From
            ```dart
            (context, rect, rRect) {
              return Positioned(
                top: rRect.top,
                left: rRect.left,
                child: Text('Hello'),
              );
            }
            ``` 
          To
            ```dart
            (context, entryRect) {
              return Positioned(
                top: entryRect.rRect!.top,
                left: entryRect.rRect!.left,
                child: Text('Hello'),
              );
            }
            ```

## [2.1.1] - 9/12/2021

- Add test
- Fix for [flutter#91753](https://github.com/flutter/flutter/pull/91753) compatibility

## [2.1.0] - 6/11/2021

- Improve package performance.
    - Previous version tends to rebuild recursively non-stop which is fixed in this release.
- Add more example
    - Check the `example` project.
    - Due to community request, concrete example for disabling widget is added. Check `SimpleCounterTutorial` widget
      in `example` project.

## [2.0.4] - 19/6/2021

- Update CHANGELOG.md.

## [2.0.3] - 19/6/2021

- Patch [#23](https://github.com/TabooSun/overlay_tutorial/issues/23).
    - Fix widget rebuild too frequently
    - Fix FlutterError due to using setState when widget has already disposed

## [2.0.2] - 10/6/2021

- Patch [#20](https://github.com/TabooSun/overlay_tutorial/issues/20). (Thanks @Guang1234567)
    - Fix `OverlayTutorialHole.enabled` does not work.

## [2.0.1] - 4/5/2021

- Patch [#15](https://github.com/TabooSun/overlay_tutorial/issues/15).
    - Fix overlay is not rendering properly in web.

## [2.0.0] - 22/3/2021

- Complete [enhancement#10](https://github.com/TabooSun/overlay_tutorial/issues/10).
  ### Breaking API Changes
    1. ~~`OverlayTutorial`~~ is removed. Use `OverlayTutorialScope` instead.
    2. `OverlayTutorialScope` does not take all the `OverlayTutorialEntry`, pass these in new
       widget, `OverlayTutorialHole`.
    3. `OverlayTutorialHole` handles the `OverlayTutorialEntry`. Wrap `OverlayTutorialHole` with your widget that
       intends to make hole. Thus, you no longer need to provide any `GlobalKey`.
    4. `OverlayTutorialEntry` no longer takes `widgetKey` as argument.
    5. ~~`OverlayTutorialController`~~ is removed. Use the property in `OverlayTutorialScope` & `OverlayTutorialHole` to
       control the visibility of the overlay tutorial.

## [1.0.0] - 10/3/2021

- Support dart null-safety.

## [0.2.1] - 7/9/2020

- Allow package to be used on flutter 1.17.5

## [0.2.0] - 5/9/2020

- Fix Overlay Entry delay in production.

## [0.1.2] - 1/9/2020

- Hotfix - Overlay not showing on first time

## [0.1.1] - 1/9/2020

- Remove print statement
- Make `shapeBuilder` required in `OverlayTutorialCustomShapeEntry`
- Improve documentation.

## [0.1.0] - 29/8/2020

- Improve performance by preventing canvas from drawing continuously.

## [0.0.8] - 28/8/2020

* Bugfix & Improve documentation

## [0.0.7] - 28/8/2020

* Breaking API Changes: `OverlayTutorialEntry` is now an abstract class, use `OverlayTutorialRectEntry` instead.
* Introduce `OverlayTutorialCircleEntry` & `OverlayTutorialCustomShapeEntry` for drawing other shape.
* Change use of `addPersistentFrameCallback` to `addTimingsCallback` as the former will cause Flutter Inspector Select
  Widget mode to be malfunction.

## [0.0.6] - 27/8/2020

* Remove print statement

## [0.0.5] - 27/8/2020

* Show `overlayTutorialEntries` & `overlayChildren` only after `showOverlayTutorial` is called.

## [0.0.4] - 27/8/2020

* Handle SafeArea

## [0.0.3] - 26/8/2020

* Add Description to `pubspec.yaml`

## [0.0.2] - 26/8/2020

* Fix README image

## [0.0.1] - 26/8/2020

* Initial release
* Add OverlayTutorial widget
