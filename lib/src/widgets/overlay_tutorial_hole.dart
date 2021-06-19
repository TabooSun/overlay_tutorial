part of overlay_tutorial;

/// Crop a hole on [child] by configuration in [overlayTutorialEntry].
class OverlayTutorialHole extends StatefulWidget {
  /// Define the shape and hint information of this hole.
  final OverlayTutorialEntry overlayTutorialEntry;

  /// Whether to enable this hole to be cropped.
  ///
  /// See also [OverlayTutorialScope.enabled].
  final bool enabled;

  final Widget child;

  OverlayTutorialHole({
    Key? key,
    required this.overlayTutorialEntry,
    required this.enabled,
    required this.child,
  }) : super(key: key);

  @override
  _OverlayTutorialHoleState createState() => _OverlayTutorialHoleState();
}

class _OverlayTutorialHoleState extends State<OverlayTutorialHole> {
  late _OverlayTutorialScopeState? _overlayTutorialScopeState;

  @override
  void didChangeDependencies() {
    _overlayTutorialScopeState =
        context.findAncestorStateOfType<_OverlayTutorialScopeState>();

    final overlayTutorialScope = _overlayTutorialScopeState;
    if (overlayTutorialScope != null) {
      if (widget.enabled) {
        overlayTutorialScope._overlayTutorialHoles[widget] = context;
      } else {
        overlayTutorialScope._overlayTutorialHoles.remove(widget);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(OverlayTutorialHole oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      final overlayTutorialScope = _overlayTutorialScopeState;
      if (overlayTutorialScope != null) {
        if (widget.enabled) {
          overlayTutorialScope._overlayTutorialHoles[widget] = context;
        } else {
          overlayTutorialScope._overlayTutorialHoles.remove(oldWidget);
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          overlayTutorialScope.updateChildren();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
