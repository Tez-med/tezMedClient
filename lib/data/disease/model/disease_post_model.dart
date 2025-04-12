class DiseasePostModel {
  final String clientId;
  final String description;
  final String name;
  final List<String> photo;
  final String scheduleId;

  DiseasePostModel({
    required this.clientId,
    required this.description,
    required this.name,
    required this.photo,
    required this.scheduleId,
  });

  factory DiseasePostModel.fromJson(Map<String, dynamic> json) {
    return DiseasePostModel(
      clientId: json['client_id'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      photo: (json['photo'] as List).map((e) => e as String).toList(),
      scheduleId: json['schedule_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'description': description,
      'name': name,
      'photo': photo,
      'schedule_id': scheduleId,
    };
  }
}
