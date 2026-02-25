import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:web/web.dart' as web;

Future<String?> openTextFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    withData: true,
  );
  if (result == null) return null;

  final file = result.files.single;
  final bytes = file.bytes;
  if (bytes == null) return null;

  return utf8.decode(bytes);
}

Future<void> saveTextFile({
  required String suggestedName,
  required String content,
}) async {
  final encoded = Uri.encodeComponent(content);
  final url = 'data:application/json;charset=utf-8,$encoded';

  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = suggestedName
    ..style.display = 'none';

  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
