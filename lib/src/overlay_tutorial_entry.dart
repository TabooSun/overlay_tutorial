part of overlay_tutorial;

class OverlayTutorialEntry {
  final GlobalKey widgetKey;
  final EdgeInsetsGeometry padding;
  final Radius radius;

  OverlayTutorialEntry({
    @required this.widgetKey,
    this.padding = EdgeInsets.zero,
    this.radius = Radius.zero,
  });
}
