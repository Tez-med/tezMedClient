import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/domain/upload_file/usecase/upload_file_usecase.dart';

part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final UploadFileUsecase _uploadFileUsecase;
  File? _currentFile;
  String? _currentFileName;
  String? _currentUploadKey;

  FileUploadBloc(this._uploadFileUsecase) : super(const FileUploadInitial()) {
    on<ImageUpload>(_onImageUpload);
  }

  File? getCurrentFile() => _currentFile;
  String? getCurrentFileName() => _currentFileName;
  String? getCurrentUploadKey() => _currentUploadKey;

  Future<void> _onImageUpload(
      ImageUpload event, Emitter<FileUploadState> emit) async {
    _currentFile = event.file;
    _currentFileName = event.file.path.split('/').last;
    _currentUploadKey = event.key;

    emit(FileUploadLoading(file: _currentFile!, fileName: _currentFileName!));

    try {
      final result = await _uploadFileUsecase.uploadFile(
        event.file,
        onProgress: (progress) {
          if (event.key == 'image') {
            emit(ImageUploadProgress(progress,
                file: _currentFile!, fileName: _currentFileName!));
          }
        },
      );
      emit(ImageUploadSucces(result,
          file: _currentFile!, fileName: _currentFileName!));

      // Clear current file data after successful upload
      _currentFile = null;
      _currentFileName = null;
      _currentUploadKey = null;
    } catch (e) {
      emit(FileUploadError(e.toString(),
          file: _currentFile, fileName: _currentFileName));

      // Clear current file data on error
      _currentFile = null;
      _currentFileName = null;
      _currentUploadKey = null;
    }
  }
}
