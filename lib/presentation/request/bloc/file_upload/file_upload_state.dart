part of 'file_upload_bloc.dart';

abstract class FileUploadState extends Equatable {
  final File? file;
  final String? fileName;

  const FileUploadState({this.file, this.fileName});

  @override
  List<Object?> get props => [file, fileName];

  get progress => null;
}

class FileUploadInitial extends FileUploadState {
  const FileUploadInitial() : super();
}



class FileUploadLoading extends FileUploadState {
  const FileUploadLoading({
    required File file,
    required String fileName,
  }) : super(file: file, fileName: fileName);
}

class FileUploadProgress extends FileUploadState {
  @override
  final double progress;

  const FileUploadProgress(
    this.progress, {
    required File file,
    required String fileName,
  }) : super(file: file, fileName: fileName);

  @override
  List<Object?> get props => [...super.props, progress];
}

class ImageUploadProgress extends FileUploadState {
  @override
  final double progress;

  const ImageUploadProgress(
    this.progress, {
    required File file,
    required String fileName,
  }) : super(file: file, fileName: fileName);

  @override
  List<Object?> get props => [...super.props, progress];
}

class FileUploadSucces extends FileUploadState {
  final String uploadedFileUrl;

  const FileUploadSucces(
    this.uploadedFileUrl, {
    required File file,
    required String fileName,
  }) : super(file: file, fileName: fileName);

  @override
  List<Object?> get props => [...super.props, uploadedFileUrl];
}

class ImageUploadSucces extends FileUploadState {
  final String uploadedFileUrl;

  const ImageUploadSucces(
    this.uploadedFileUrl, {
    required File file,
    required String fileName,
  }) : super(file: file, fileName: fileName);

  @override
  List<Object?> get props => [...super.props, uploadedFileUrl];
}


class FileUploadError extends FileUploadState {
  final String message;

  const FileUploadError(
    this.message, {
    super.file,
    super.fileName,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
