class DiseasePost {
  final String clientId;
  final String description;
  final String name;
  final List<String> photo;
  final String scheduleId;

  DiseasePost({
    required this.clientId,
    required this.description,
    required this.name,
    required this.photo,
    required this.scheduleId,
  });
}