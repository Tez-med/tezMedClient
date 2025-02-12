class CategoryModel {
  final String id;
  final String nameEn;
  final String nameUz;
  final String nameRu;
  final String photo;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<Department> departments;

  CategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameUz,
    required this.nameRu,
    required this.photo,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.departments,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? "",
      nameEn: json['name_en'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameRu: json['name_ru'] ?? "",
      photo: json['photo'] ?? "",
      descriptionUz: json['description_uz'] ?? '',
      descriptionRu: json['description_ru'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      departments: json['departments'] != null
          ? List<Department>.from(
              json['departments'].map((x) => Department.fromJson(x)))
          : [],
    );
  }
}

class Department {
  final String id;
  final String categoryId;
  final String nameEn;
  final String nameUz;
  final String nameRu;
  final bool isActive;
  final String photo;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final String createdAt;
  final List<Affairs> affairs;

  Department({
    required this.id,
    required this.categoryId,
    required this.nameEn,
    required this.nameUz,
    required this.nameRu,
    required this.affairs,
    required this.isActive,
    required this.photo,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.createdAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? "",
      categoryId: json['category_id'] ?? "",
      nameEn: json['name_en'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameRu: json['name_ru'] ?? "",
      affairs: json['affairss'] != null
          ? List<Affairs>.from(json['affairss'].map((x) => Affairs.fromJson(x)))
          : [],
      isActive: json['is_active'] ?? false,
      photo: json['photo'] ?? '',
      descriptionUz: json['description_uz'] ?? '',
      descriptionRu: json['description_ru'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      createdAt: json['created_at'] ?? "",
    );
  }
}

class Affairs {
  final String id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final int price;
  final List<Service> service;

  Affairs({
    required this.id,
    required this.nameUz,
    required this.nameEn,
    required this.nameRu,
    required this.price,
    required this.service,
  });

  factory Affairs.fromJson(Map<String, dynamic> json) {
    return Affairs(
      id: json['id'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameEn: json['name_en'] ?? "",
      nameRu: json['name_ru'] ?? "",
      price: json['price'] ?? 0,
      service: json['affairs'] != null
          ? List<Service>.from(json['affairs'].map((x) => Service.fromJson(x)))
          : [],
    );
  }
}

class Service {
  final String id;
  final String departmentId;
  final String nameEn;
  final String nameUz;
  final String nameRu;
  final int price;
  final bool isActive;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final TypeModel type;

  Service({
    required this.id,
    required this.departmentId,
    required this.nameEn,
    required this.nameUz,
    required this.nameRu,
    required this.price,
    required this.isActive,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.type,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? "",
      departmentId: json['department_id'] ?? "",
      nameEn: json['name_en'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameRu: json['name_ru'] ?? "",
      price: json['price'] ?? 0,
      isActive: json['is_active'] ?? false,
      descriptionUz: json['description_uz'] ?? "",
      descriptionRu: json['description_ru'] ?? "",
      descriptionEn: json['description_en'] ?? "",
      type: TypeModel.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department_id': departmentId,
      'name_en': nameEn,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'price': price,
      'is_active': isActive,
      'description_uz': descriptionUz,
      'description_ru': descriptionRu,
      'description_en': descriptionEn,
      'type': type.toJson(),
    };
  }
}

class TypeModel {
  final String id;
  final String nameUz;
  final String nameEn;
  final String nameRu;
  final int price;

  TypeModel({
    required this.id,
    required this.nameUz,
    required this.nameEn,
    required this.nameRu,
    required this.price,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameEn: json['name_en'] ?? "",
      nameRu: json['name_ru'] ?? "",
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_en': nameEn,
      'name_ru': nameRu,
      'price': price,
    };
  }
}
