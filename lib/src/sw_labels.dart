
part of swlabels;

/// Extension of class [Label](https://pub.dev/documentation/spritewidget/latest/spritewidget/Label-class.html) for the needs of [SWLabels]
class SWLabel extends sw.Label {
  String name;

  SWLabel(
      String text,
      ui.Offset position,
      [this.name]):
        super(text) {
    super.position = position;
  }
}

/// Класс позволяет очень быстро и удобно выводить текстовые метки в [SpriteWidget](https://pub.dev/packages/spritewidget)
///
/// Все параметры задаются при вызове конструктора [SWLabels]. Объект класса
/// представляет собой набор объектов [SWLabel], которые располагаются в столбик.
/// Метки можно выводить с указанием индекса, а также им можно присваивать имена,
/// тогда не нужно будет запоминать координаты. Также есть возможность выводить
/// в стиле терминала, когда весь набор строк будет скроллироваться.
///
/// Класс очень удобен для двух целей:
/// * для отладки, когда удобнее видеть значения сразу на экране
/// * для быстрого прототипирования игрового интерфейса (очки, жизни), чтобы
/// временно выводить просто строки, пока графика ещё не разработана
class SWLabels extends sw.Node {
  /// Максимальное количество меток
  final maxCount;
  /// Шаг строк
  final double stepY;
  // Смещение первой метки от заголовка
  double _titleDY;
  /// Заголовок
  final String title;
  // Список всех меток
  final List<SWLabel> _labels;

  /// Количество меток в текущий момент
  int get length => _labels.length;

  /// Конструктор объекта [SWLabels]. Позволяет сразу задать необходимые параметры.
  /// Первый параметр [size] определяет размеры
  SWLabels({
      @required this.maxCount,
      @required ui.Offset position,
      @required this.stepY,
      this.title }):
        assert(maxCount >= 1),
        assert(position != null),
        assert(stepY > 0),
        _labels = List<SWLabel>()
  {
    super.position = position;
    if (title == null) {
      _titleDY = 0.0;
    } else {
      _titleDY = stepY*1.3;
      final titleLabel = sw.Label(title,
          textStyle: mat.TextStyle(fontWeight: mat.FontWeight.bold));
      titleLabel.position = ui.Offset(0, 0);
      addChild(titleLabel);
    }
  }

  /// Возвращает объект как строку
  @override
  String toString() => _labels.toString();

  // Если количество строк достигло [maxCount], то первый удаляется, а
  // координаты остальных сдвигаются вверх.
  void _scroll() {
    if (_labels.length > 1 && _labels.length == maxCount) {
      for (int i = _labels.length - 1; i >= 1; i--) {
        _labels[i].position = _labels[i - 1].position;
      }
      removeChild(_labels[0]);
      _labels.removeAt(0);
    }
  }

  /// Добавляет пустую строку
  void skipLine() {
    _scroll();
    _labels.add(null);
  }

  // Координаты SWLabel по индексу в списке
  ui.Offset _labelOffset(int index) => ui.Offset(0, _titleDY + stepY*index);

  // Добавляет строку в конец.
  //
  // Если количество строк достигло [maxCount], то список сдвигается вверх,
  // новое значение помещается в конец, а первое удаляется.
  void _printWithScroll(
      String text,
      String name) {
    _scroll();
    final label = SWLabel(text, _labelOffset(_labels.length), name);
    _labels.add(label);
    addChild(label);
  }

  /// Добавляет строку в конец, при необходимости сдвигая список вверх.
  ///
  /// При желании, можно задать имя [name] для значения. Это позволит в
  /// дальнейшем обращаться к нему по имени. Если имя не задано, или пока ещё не
  /// имеется в списке, то новая строка добавляется в конец. Если количество
  /// строк достигло [maxCount], то список сдвигается вверх, новое значение
  /// помещается в конец, а первое удаляется.
  ///
  /// Если же строка с таким именем уже есть в любой позиции, то новая строка не
  /// добавляется, просто значение с именем [name] заменяется на новое.
  void print(
      String text,
      [String name]) {
    if (name == null) {
      _printWithScroll(text, null);
    } else {
      final label = _labels.firstWhere(
          (element) => element.name == name,
          orElse: () => null);
      if (label == null) {
        _printWithScroll(text, name);
      } else {
        label.text = text;
      }
    }
  }

  // Расширяет список до индекса [rowIndex] и заполняет координаты элементов
  void _extend(int rowIndex) {
    assert (rowIndex >= 0 && rowIndex < maxCount);
    final prevLength = _labels.length;
    if (rowIndex >= prevLength) {
      _labels.length = rowIndex + 1;
      for (int i = prevLength; i < _labels.length; i++) {
        _labels[i] = SWLabel(null, _labelOffset(i));
        addChild(_labels[i]);
      }
    }
  }

  /// Заменяет значение в указанной позиции
  ///
  /// При желании, можно задать имя [name] для значения. Это позволит в
  /// дальнейшем обращаться к нему по имени при помощи метода [print(..)].
  /// Если задано [name], но в списке такое имя уже есть, то старая
  /// позиция [rowIndex] сравнивается с новой, и если они отличаются, то
  /// значение в старой позиции удаляется, и значение помещается в новую
  /// позицию с присваиванием имени.
  void printTo(
      String text,
      int rowIndex,
      [String name]) {
    assert(rowIndex >= 0 && rowIndex < maxCount);
    _extend(rowIndex);
    if (name == null) { // Если [name] не задан
      _labels[rowIndex]
        ..text = text
        ..name = null;
    } else { // Если [name] задан
      final label = _labels.firstWhere(
          (element) => element.name == name,
          orElse: () => null);
      if (label == null) { // Если имени [name] ещё нет в списке
        _labels[rowIndex]
          ..text = text
          ..name = name;
      } else { // Если уже есть элемент с именем [name]
        label.text = text;
      }
    }
  }

  void delete() {
    removeAllChildren();
    _labels.clear();
  }
}