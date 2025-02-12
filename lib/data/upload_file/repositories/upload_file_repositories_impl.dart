import 'dart:io';

import 'package:tez_med_client/data/upload_file/source/upload_file_source.dart';
import 'package:tez_med_client/domain/upload_file/repository/upload_file_repository.dart';


class UploadFileRepositoriesImpl implements UploadFileRepository {
  final UploadFileSource _fileSource;
  UploadFileRepositoriesImpl(this._fileSource);
  @override
  Future<String> uploadFile(File file,
      {Function(double progress)? onProgress}) async {
    return await _fileSource.uploadFile(
      file,
      onProgress: onProgress,
    );
  }
}
