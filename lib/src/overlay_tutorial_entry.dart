part of overlay_tutorial;

class OverlayTutorialEntry {
  final GlobalKey widgetKey;
  final EdgeInsetsGeometry padding;
  final Radius radius;
  final List<OverlayTutorialHint> overlayTutorialHints;

  OverlayTutorialEntry({
    @required this.widgetKey,
    this.padding = EdgeInsets.zero,
    this.radius = Radius.zero,
    this.overlayTutorialHints = const [],
  });
}

/// [rect] is the [Rect] of [OverlayTutorialEntry].
typedef PositionFromEntryFactory = Offset Function(Rect rect);

abstract class OverlayTutorialHint {
  /// The offset from a [OverlayTutorialEntry].
  final PositionFromEntryFactory positionFromEntry;

  OverlayTutorialHint(this.positionFromEntry);
}

class OverlayTutorialImageHint extends OverlayTutorialHint {
  static final _cachedImageByteArray = <String, Uint8List>{};
  static final _cachedImages = <crypto.Digest, ui.Image>{};
  bool _isImageReady = false;

  bool get isImageReady => _isImageReady;

  Uint8List imageByteArray;

  String _assetName;

  crypto.Digest _md5Hash;

  crypto.Digest get md5Hash {
    assert(imageByteArray != null);
    _md5Hash ??= crypto.md5.convert(imageByteArray);
    return _md5Hash;
  }

  final Size size;
  final double scale;

  OverlayTutorialImageHint.asset(
    PositionFromEntryFactory positionFromEntry,
    String assetName, {
    AssetBundle bundle,
    this.size,
    this.scale,
  })  : _assetName = assetName,
        super(positionFromEntry);

  OverlayTutorialImageHint.memory(
    PositionFromEntryFactory positionFromEntry,
    this.imageByteArray, {
    this.size,
    this.scale,
  }) : super(positionFromEntry);

  Future<ui.Image> loadUiImage() async {
    if (imageByteArray == null) {
      if (_cachedImageByteArray[_assetName] == null) {
        final data = await rootBundle.load(_assetName);
        if (data == null) throw 'Unable to load asset of $_assetName';
        _cachedImageByteArray[_assetName] = data.buffer.asUint8List();
      }
      imageByteArray = _cachedImageByteArray[_assetName];
    }
    if (_cachedImages[md5Hash] == null) {
      final codec = await ui.instantiateImageCodec(imageByteArray);
      final frame = await codec.getNextFrame();
      _cachedImages[md5Hash] = frame.image;
    }
    _isImageReady = true;
    return _cachedImages[md5Hash];
  }

  ui.Image toUiImage() => _cachedImages[md5Hash];
}

class OverlayTutorialTextHint extends OverlayTutorialHint {
  final String text;

  OverlayTutorialTextHint(
    PositionFromEntryFactory positionFromEntry,
    this.text,
  ) : super(positionFromEntry);
}
