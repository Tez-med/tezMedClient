import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tez_med_client/config/environment.dart';
import 'dart:developer' as developer;

import 'package:tez_med_client/data/upload_file/models/file_models.dart';

import '../../../core/error/error_handler.dart';

abstract class UploadFileSource {
  Future<String> uploadFile(File file, {Function(double progress)? onProgress});
}

class UploadFileSourceImpl implements UploadFileSource {
  final Dio _dio;

  UploadFileSourceImpl(this._dio);

  @override
  Future<String> uploadFile(
    File file, {
    Function(double progress)? onProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final fileSize = await file.length();

      // Fayl o'lchami haqida log

      developer.log('File size: $fileSize bytes: File name: $fileName',
          name: 'FileUpload');

      final mediaType = _getMediaType(fileName);
      if (mediaType == null) throw UnsupportedError('Unsupported file type');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: mediaType,
        ),
      });

      final response = await _dio.post(
        "${EnvironmentConfig.instance.apiUrl}/file/upload",
        data: formData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (count, total) {
          developer.log('Progress: $count / $total', name: 'FileUpload');
          if (total > 0) onProgress?.call(count / total);
        },
      );

      if (response.statusCode == 200) {
        return FileModels.fromJson(response.data).filename;
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } on DioException catch (e) {
      developer.log('Dio Error: ${e.toString()}', name: 'FileUpload');
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      developer.log('General Error: ${e.toString()}', name: 'FileUpload');
      rethrow;
    }
  }

  MediaType? _getMediaType(String fileName) {
    if (fileName.endsWith('.pdf')) return MediaType('application', 'pdf');
    if (fileName.endsWith('.png')) return MediaType('image', 'png');
    if (fileName.endsWith('.jpg')) return MediaType('image', 'jpg');
    if (fileName.endsWith('.m4a')) return MediaType('audio', 'm4a');
    if (fileName.endsWith('.mp3')) return MediaType('audio', 'mp3');
    return null;
  }
}
