part of swlabels;

/// The class allows you to quickly and conveniently display text labels
/// in [SpriteWidget](https://pub.dev/packages/spritewidget)
///
/// All parameters are set when creating the [SWLabels] object. A class object
/// is a set of [SWLabel]s, which are arranged in a column. Labels can be
/// displayed with an index, and they can also be assigned names, then you will
/// not need to remember the indexes. It is also possible to display in the
/// style of the terminal when the entire set of lines will be scrolled.
///
/// The class is very convenient for two purposes:
/// * for debugging, when it is more convenient to see the values immediately
/// on the screen
/// * for rapid prototyping of the game interface (scores, lives), to
/// temporarily display just lines until the graphics are developed
class SWLabels extends sw.Node {
  /// Maximum number of text labels
  final maxCount;

  /// Row step
  final double stepY;
  // Offset first label from header
  double _titleDY;

  /// Label group title
  final String title;
  // All label's list
  final List<SWLabel> _labels;

  /// Number of labels currently
  int get length => _labels.length;

  /// Allows you to immediately set the necessary parameters.
  ///
  /// The [maxCount] sets the maximum number of labels. [position] are the
  /// coordinates. All labels included in the object will be positioned relative
  /// to them. [stepY] determines which step vertical labels will be placed. If
  /// you want an object displayed the [title], you can specify it.
  SWLabels(
      {@required this.maxCount,
      @required ui.Offset position,
      @required this.stepY,
      this.title})
      : assert(maxCount >= 1),
        assert(position != null),
        assert(stepY > 0),
        _labels = List<SWLabel>() {
    super.position = position;
    if (title == null) {
      _titleDY = 0.0;
    } else {
      _titleDY = stepY * 1.3;
      final titleLabel = sw.Label(title,
          textStyle: mat.TextStyle(fontWeight: mat.FontWeight.bold));
      titleLabel.position = ui.Offset(0, 0);
      addChild(titleLabel);
    }
  }

  /// Returns an object as a string
  @override
  String toString() => _labels.toString();

  // If the number of rows reaches [maxCount], then the first is deleted,
  // and the coordinates of the rest are scrolled up.
  void _scroll() {
    if (_labels.length > 1 && _labels.length == maxCount) {
      for (int i = _labels.length - 1; i >= 1; i--) {
        _labels[i].position = _labels[i - 1].position;
      }
      removeChild(_labels[0]);
      _labels.removeAt(0);
    }
  }

  /// Adds an empty string (skips)
  void skipLine() {
    _scroll();
    _labels.add(null);
  }

  // Returns [SWLabel] coordinates by index in a list
  ui.Offset _labelOffset(int index) => ui.Offset(0, _titleDY + stepY * index);

  // Adds a text row to the end.
  //
  // If the number of rows reaches [maxCount], then the list scroll up, the new
  // value is placed at the end, and the first is deleted.
  void _printWithScroll(String text, String name) {
    _scroll();
    final label = SWLabel(text, _labelOffset(_labels.length), name);
    _labels.add(label);
    addChild(label);
  }

  /// Adds a text label to the end, moving the list up if necessary.
  ///
  /// Optionally, you can specify the [name] for the value. This will allow in
  /// further access him by name. If no name is specified, or not yet is listed,
  /// then a new label is added to the end. If the quantity lines reached
  /// [maxCount], then the list scroll up, the new value placed at the end, and
  /// the first is deleted. If a label with the same name is already in any
  /// position, then the new label is not is added, just the value with the
  /// [name] is replaced with a new one.
  void print(String text, [String name]) {
    if (name == null) {
      _printWithScroll(text, null);
    } else {
      final label = _labels.firstWhere((element) => element.name == name,
          orElse: () => null);
      if (label == null) {
        _printWithScroll(text, name);
      } else {
        label.text = text;
      }
    }
  }

  // Expands the list to the index [rowIndex] and fills the coordinates of
  // the elements
  void _extend(int rowIndex) {
    assert(rowIndex >= 0 && rowIndex < maxCount);
    final prevLength = _labels.length;
    if (rowIndex >= prevLength) {
      _labels.length = rowIndex + 1;
      for (int i = prevLength; i < _labels.length; i++) {
        _labels[i] = SWLabel(null, _labelOffset(i));
        addChild(_labels[i]);
      }
    }
  }

  /// Replaces the text value at the specified index
  ///
  /// Optionally, you can specify the [name] for the label. This will allow in
  /// further access it by name using the [print] method. If [name] is
  /// specified, but the name is already in the list, then the old
  /// the [rowIndex] position is compared to the new one, and if they differ,
  /// then the value in the old position is deleted and the value is placed in
  /// the new naming position.
  void printTo(String text, int rowIndex, [String name]) {
    assert(rowIndex >= 0 && rowIndex < maxCount);
    _extend(rowIndex);
    if (name == null) {
      // if [name] not found
      _labels[rowIndex]
        ..text = text
        ..name = null;
    } else {
      // if [name] specified
      final label = _labels.firstWhere((element) => element.name == name,
          orElse: () => null);
      if (label == null) {
        // if the name is not present in list
        _labels[rowIndex]
          ..text = text
          ..name = name;
      } else {
        // if label with [name] already in the list
        label.text = text;
      }
    }
  }

  /// Manual destructor. It is recommended to use it before deleting SWLabels
  void delete() {
    removeAllChildren();
    _labels.clear();
  }
}
