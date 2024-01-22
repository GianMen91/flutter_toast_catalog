import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeToFile(String content) async {
    final file = await _localFile;

    return file.writeAsString(content);
  }

  Future<String> readFromFile() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } on FileSystemException {
      return 'no file available';
    }
  }
}
