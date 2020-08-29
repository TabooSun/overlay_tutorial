## [0.1.0] - 29/8/2020

- Improve performance by preventing canvas from drawing continuously.

* ## [0.0.8] - 28/8/2020

* Bugfix & Improve documentation

* ## [0.0.7] - 28/8/2020

* Breaking API Changes: `OverlayTutorialEntry` is now an abstract class, use `OverlayTutorialRectEntry` instead.
* Introduce `OverlayTutorialCircleEntry` & `OverlayTutorialCustomShapeEntry` for drawing other shape.
* Change use of `addPersistentFrameCallback` to `addTimingsCallback` as the former will cause Flutter Inspector Select Widget mode to be malfunction.

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
