import 'dart:io';
import 'package:path_provider/path_provider.dart';

// A utility class for handling file storage operations
class Storage {
  // Get the local directory path where files can be stored
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the local file path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  // Write content to a file
  Future<File> writeToFile(String content) async {
    final file = await _localFile;

    return file.writeAsString(content);
  }

  // Read content from a file
  Future<String> readFromFile() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } on FileSystemException {
      return 'no file available';
    }
  }
}
