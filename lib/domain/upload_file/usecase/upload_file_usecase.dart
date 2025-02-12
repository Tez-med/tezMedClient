import 'dart:io';

import 'package:tez_med_client/domain/upload_file/repository/upload_file_repository.dart';

class UploadFileUsecase {
  final UploadFileRepository _uploadFileRepository;
  UploadFileUsecase(UploadFileRepository uploadFileRepository)
      : _uploadFileRepository = uploadFileRepository;

  Future<String> uploadFile(File file,
      {Function(double progress)? onProgress}) async {
    return await _uploadFileRepository.uploadFile(file, onProgress: onProgress);
  }
}
