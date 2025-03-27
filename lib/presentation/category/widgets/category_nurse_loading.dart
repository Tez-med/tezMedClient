import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/presentation/category/widgets/category_nurse_main.dart';
import '../screen/category_screen_nurse.dart';

class CategoryNurseLoading extends StatelessWidget {
  const CategoryNurseLoading({super.key, required this.widget});

  final CategoryScreenNurse widget;

  static List<CategoryModel> loadingCategories = List.generate(
      2,
      (index) => CategoryModel(
            id: "",
            nameEn: "Loading",
            nameUz: "Loading",
            nameRu: "Loading",
            photo: "",
            descriptionUz: "Loading",
            descriptionRu: "Loading",
            descriptionEn: "Loading",
            isActive: true,
            createdAt: "",
            updatedAt: "",
            departments: List.generate(
                4,
                (deptIndex) => Department(
                      id: "",
                      categoryId: "",
                      categoryNameUz: "Loading",
                      categoryNameRu: "Loading",
                      categoryNameEn: "Loading",
                      nameUz: "Loading",
                      nameRu: "Loading",
                      nameEn: "Loading",
                      isActive: false,
                      photo: "",
                      descriptionUz: "Loading",
                      descriptionRu: "Loading",
                      descriptionEn: "Loading",
                      orderNumber: deptIndex + 1,
                      affairs: List.generate(
                          2,
                          (affairIndex) => Affairs(
                                id: "",
                                nameUz: "Loading",
                                nameEn: "Loading",
                                nameRu: "Loading",
                                price: 0,
                                service: List.generate(
                                    2,
                                    (serviceIndex) => Service(
                                          id: "",
                                          departmentId: "",
                                          regionAffairId: "",
                                          nameEn: "Loading",
                                          nameUz: "Loading",
                                          nameRu: "Loading",
                                          price: 0,
                                          isActive: true,
                                          descriptionUz: "Loading",
                                          descriptionRu: "Loading",
                                          descriptionEn: "Loading",
                                          type: TypeModel(
                                            id: "",
                                            nameUz: "Loading",
                                            nameEn: "Loading",
                                            nameRu: "Loading",
                                            price: 0,
                                          ),
                                        )),
                              )),
                    )),
          ));

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CategoryNurseMain(
        category: loadingCategories,
        requestModel: widget.requestModel,
      ),
    );
  }
}
