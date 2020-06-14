part of swlabels;

/// Extension of class [Label](https://pub.dev/documentation/spritewidget/latest/spritewidget/Label-class.html) for the needs of [SWLabels]
///
/// This class is used inside the [SWLabels] class. There is no need to use
/// separately.
///
/// The [name] property has been added to it so that you can access text label
/// by name. There is also a convenient constructor.
class SWLabel extends sw.Label {
  /// The [name] property allows you to access a text label by name.
  String name;

  /// Set the properties of the text label when creating
  ///
  /// The [text] parameter is what will be displayed on the screen. Parameter
  /// [position] sets the position inside the [SWLabels]. The [name] parameter
  /// allows you to specify a name so that in the future you can access the text
  /// label from [SWLabels]
  SWLabel(String text, ui.Offset position, [this.name]) : super(text) {
    super.position = position;
  }
}
