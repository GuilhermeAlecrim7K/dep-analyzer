class InvalidFileExtensionException implements Exception {}

class InvalidFileFormatException implements Exception {
  final String message;

  InvalidFileFormatException(this.message);

  @override
  String toString() {
    return 'Invalid File Format: $message';
  }
}

class InvalidFileEncodingException implements Exception {
  @override
  String toString() {
    return 'Invalid File Encoding. Expected UTF-8.';
  }
}

class EmptyFileException implements Exception {}
