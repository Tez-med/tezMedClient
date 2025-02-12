import 'dart:convert';

FileModels fileModelsFromJson(String str) =>
    FileModels.fromJson(json.decode(str));

String fileModelsToJson(FileModels data) => json.encode(data.toJson());

class FileModels {
  final String filename;

  FileModels({
    required this.filename,
  });

  factory FileModels.fromJson(Map<String, dynamic> json) => FileModels(
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
      };
}

class Url {
  final String filename;
  final String type;
  final String url;
  final String urlPreview;
  final String duration;

  Url({
    required this.filename,
    required this.type,
    required this.url,
    required this.urlPreview,
    required this.duration,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        filename: json["filename"],
        type: json["type"],
        url: json["url"],
        urlPreview: json["url_preview"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "type": type,
        "url": url,
        "url_preview": urlPreview,
        "duration": duration,
      };
}
