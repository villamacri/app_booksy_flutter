import 'dart:convert';

dynamic safeJsonDecode(
  String source, {
  String errorMessage = 'Error de conexion, datos incompletos',
}) {
  try {
    if (source.trim().isEmpty) {
      throw const FormatException('Empty response body');
    }

    return jsonDecode(source);
  } on FormatException {
    throw Exception(errorMessage);
  }
}
