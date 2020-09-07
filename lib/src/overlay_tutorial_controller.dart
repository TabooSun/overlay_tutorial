part of overlay_tutorial;

/// Create a [OverlayTutorialController] and assign to
/// [OverlayTutorial.controller]. You will be able to show and hide the
/// overlay tutorial with the controller.
class OverlayTutorialController {
  _OverlayTutorialState _state;

  /// This is for showing the overlay tutorial.
  void showOverlayTutorial() => _state?.showOverlayTutorial();

  /// This is for hiding the overlay tutorial.
  void hideOverlayTutorial() => _state?.hideOverlayTutorial();

  /// This is for updating the overlay tutorial after it is shown.
  void updateOverlayTutorial() => _state?.retrieveEntryRects();
}
