import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/category/bloc/nurse_type/nurse_type_bloc.dart';
import 'package:tez_med_client/presentation/doctor/bloc/doctor_get_list/doctor_bloc.dart';
import 'package:tez_med_client/presentation/doctor/widgets/doctor_card.dart';

class CategoryDoctor extends StatefulWidget {
  final String type;
  const CategoryDoctor({super.key, required this.type});

  @override
  State<CategoryDoctor> createState() => _CategoryDoctorState();
}

class _CategoryDoctorState extends State<CategoryDoctor>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseTypeBloc, NurseTypeState>(
      builder: (context, state) {
        if (state is NurseTypeLoading) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Skeletonizer(
                child: DoctorCard(
                    doc: Doctor(
                        id: "",
                        districtId: "",
                        regionId: "",
                        countryId: "",
                        speciesId: "",
                        fullName: "",
                        birthday: "",
                        gender: "",
                        passportPhoto: [],
                        diplomaPhoto: [],
                        certificate: [],
                        medicalSheet: [],
                        selfEmployed: [],
                        status: "",
                        rating: 0,
                        phoneNumber: "",
                        photo: "",
                        experience: 0,
                        consultationTime: 0,
                        consultationPrice: 0,
                        createdAt: ""),
                    type: "",
                    online: false,
                    typeDoctor: ""),
              );
            },
          );
        }
        if (state is NurseTypeError) {
          if (state.error.code == 400) {
            return NoInternetConnectionWidget(
              onRetry: () => context.read<NurseTypeBloc>().add(GetType()),
            );
          } else if (state.error.code == 500) {
            return ServerConnection(
              onRetry: () => context.read<NurseTypeBloc>().add(GetType()),
            );
          }
          return Center(child: Text(S.of(context).unexpected_error));
        }
        if (state is NurseTypeLoaded) {
          final doctorTypes = state.data.types
              .where((element) => element.type == "doctor")
              .toList();

          if (doctorTypes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 64, color: AppColor.greyTextColor),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).no_doctor_types_found,
                    style: AppTextstyle.nunitoMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          final selectedType = doctorTypes[0];
          context.read<DoctorBloc>().add(GetDoctor(selectedType.id));

          _tabController = TabController(
            length: doctorTypes.length,
            vsync: this,
          );

          return DefaultTabController(
            length: doctorTypes.length,
            child: Scaffold(
              backgroundColor: AppColor.buttonBackColor,
              appBar: AppBar(
                toolbarHeight: 0,
                surfaceTintColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.white,
                leading: const SizedBox(),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.buttonBackColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        onTap: (index) {
                          final selectedType = doctorTypes[index];
                          context
                              .read<DoctorBloc>()
                              .add(GetDoctor(selectedType.id));
                        },
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        labelColor: Colors.black,
                        unselectedLabelColor: AppColor.greyTextColor,
                        unselectedLabelStyle: AppTextstyle.nunitoMedium,
                        labelStyle:
                            AppTextstyle.nunitoBold.copyWith(fontSize: 14),
                        tabs: doctorTypes
                            .map<Widget>((type) => Tab(
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        context.toLocalized(
                                            uz: type.nameUz,
                                            ru: type.nameRu,
                                            en: type.nameEn),
                                        style: AppTextstyle.nunitoBold
                                            .copyWith(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              body: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          child: DoctorCard(
                              doc: Doctor(
                                  id: "",
                                  districtId: "",
                                  regionId: "",
                                  countryId: "",
                                  speciesId: "",
                                  fullName: "",
                                  birthday: "",
                                  gender: "",
                                  passportPhoto: [],
                                  diplomaPhoto: [],
                                  certificate: [],
                                  medicalSheet: [],
                                  selfEmployed: [],
                                  status: "",
                                  rating: 0,
                                  phoneNumber: "",
                                  photo: "",
                                  experience: 0,
                                  consultationTime: 0,
                                  consultationPrice: 0,
                                  createdAt: ""),
                              type: "",
                              online: false,
                              typeDoctor: ""),
                        );
                      },
                    );
                  }
                  if (state is DoctorLoaded) {
                    final data = state.data;
                    if (data.doctors.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sentiment_dissatisfied,
                                size: 64, color: AppColor.greyTextColor),
                            SizedBox(height: 16),
                            Text(
                              S.of(context).no_doctor_types_found,
                              style: AppTextstyle.nunitoMedium
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: data.doctors.length,
                      itemBuilder: (context, index) {
                        final item = data.doctors[index];
                        return DoctorCard(
                          typeDoctor: widget.type,
                          online: doctorTypes[_tabController.index]
                                  .nameUz
                                  .toLowerCase() !=
                              "telemeditsina",
                          doc: item,
                          type: context.toLocalized(
                              uz: doctorTypes[_tabController.index].nameUz,
                              ru: doctorTypes[_tabController.index].nameRu,
                              en: doctorTypes[_tabController.index].nameEn),
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
