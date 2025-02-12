part of 'file_upload_bloc.dart';

abstract class FileUploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}



class ImageUpload extends FileUploadEvent {
  final String key;
  final File file;
  ImageUpload(this.key, this.file);

  @override
  List<Object?> get props => [file, key];

  get type => null;
}