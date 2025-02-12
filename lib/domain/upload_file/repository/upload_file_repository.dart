import 'dart:io';

abstract class UploadFileRepository {
  Future<String> uploadFile(File file,{Function(double progress)? onProgress});
}
