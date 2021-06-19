part of overlay_tutorial;

class OverlayTutorialScopeModel with EquatableMixin {
  /// The [BuildContext] of [OverlayTutorialHole].
  BuildContext? context;

  /// A cached [Rect] of [OverlayTutorialHole].
  Rect? rect;

  Rect computeRect() {
    final renderBox = context?.findRenderObject() as RenderBox?;

    if (renderBox == null || !renderBox.attached) {
      return Rect.zero;
    }

    return (renderBox.localToGlobal(Offset.zero)) & renderBox.size;
  }

  @override
  List<Object?> get props => [
        context,
        rect,
      ];
}
