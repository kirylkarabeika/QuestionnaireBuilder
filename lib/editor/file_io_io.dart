import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<void> saveTextFile({
  required String suggestedName,
  required String content,
}) async {
  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Save questionnaire JSON',
    fileName: suggestedName,
    allowedExtensions: ['json'],
    type: FileType.custom,
  );

  if (path == null) return;
  final file = File(path);
  await file.writeAsString(content);
}

Future<String?> openTextFile() async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Open questionnaire JSON',
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  if (result == null || result.files.single.path == null) return null;

  return File(result.files.single.path!).readAsString();
}
