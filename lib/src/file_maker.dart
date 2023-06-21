import 'dart:io';

mixin FileMaker {
  File makeFile({
    required String directory,
    required String name,
    required String extension,
  }) {
    return File('$directory${Platform.pathSeparator}$name.$extension');
  }
}
