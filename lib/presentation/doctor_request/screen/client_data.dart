import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/auth/widgets/phone_input.dart';
import 'package:tez_med_client/presentation/doctor_request/bloc/doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/request/widgets/custom_loading_succes.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/date_picker_widget.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/image_picker_widget.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/text_feild_widget.dart';

import '../../../core/error/error_handler.dart';
import '../../request/widgets/location_widget.dart';
import '../widgets/gender_selection_feild.dart';

@RoutePage()
class ClientData extends StatefulWidget {
  final bool online;
  final String id;
  const ClientData({
    super.key,
    required this.id,
    required this.online,
  });

  @override
  State<ClientData> createState() => _ClientDatasState();
}

class _ClientDatasState extends State<ClientData> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneInputController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController entranceController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();
  final TextEditingController accessCodeController = TextEditingController();
  String clientId = "";
  final formKey = GlobalKey<FormState>();

  bool _isForSelf = true;

  DateTime? _selectedDate;

  final ValueNotifier<List<String>> _imagesNotifier =
      ValueNotifier<List<String>>([]);

  void _updateImageFiles(List<String> newImageFiles) {
    _imagesNotifier.value = newImageFiles;
  }

  String formatPhoneNumber(String phoneNumber) {
    return "+998${phoneNumber.replaceAll(' ', '')}";
  }

  Future<void> _submitForm() async {
    final data = DoctorRequestModel(
      accessCode: accessCodeController.text,
      address: addressController.text,
      apartment: apartmentController.text,
      clientBody: !_isForSelf
          ? ClientBody(
              birthday: _birthDateController.text,
              createdAt: "",
              districtId: "",
              extraPhone: "",
              fullName: _fullNameController.text,
              gender: _genderController.text,
              latitude: "",
              longitude: "",
              phoneNumber: _phoneInputController.text,
              photo: "")
          : ClientBody(
              birthday: "",
              createdAt: "",
              districtId: "",
              extraPhone: "",
              fullName: "",
              gender: "",
              latitude: "",
              longitude: "",
              phoneNumber: "",
              photo: ""),
      clientId: clientId,
      date: "",
      doctorAffairsId: "",
      doctorId: "",
      entrance: entranceController.text,
      floor: floorController.text,
      house: houseController.text,
      latitude: latController.text,
      longitude: longController.text,
      photo: _imagesNotifier.value.isEmpty ? "" : _imagesNotifier.value.first,
      price: 0,
      status: "booked",
      time: "",
    );

    context.read<DoctorRequestBloc>().add(DoctorRequest(data, widget.id));
  }

  void _toggleUserType() {
    setState(() {
      _isForSelf = !_isForSelf;
      if (!_isForSelf) {
        _fullNameController.clear();
        _phoneInputController.clear();
        _birthDateController.clear();
        _genderController.clear();
        _selectedDate = null;
      }
    });
  }

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppColor.buttonBackColor,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
        title: Text(
          S.of(context).your_details,
          style: AppTextstyle.nunitoBold.copyWith(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is ProfileLoaded) {
                final data = state.clientModel;
                if (_isForSelf) {
                  _fullNameController.text = data.fullName;
                  _birthDateController.text = data.birthday;
                  _phoneInputController.text = data.phoneNumber.substring(4);
                  _genderController.text = data.gender;
                  clientId = data.id;
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _isForSelf
                                              ? AppColor.primaryColor
                                              : AppColor.buttonBackColor,
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          if (!_isForSelf) _toggleUserType();
                                        },
                                        child: Text(
                                          "O'zim uchun",
                                          style:
                                              AppTextstyle.nunitoBold.copyWith(
                                            color: _isForSelf
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: !_isForSelf
                                              ? AppColor.primaryColor
                                              : AppColor.buttonBackColor,
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          if (_isForSelf) _toggleUserType();
                                        },
                                        child: Text(
                                          "Boshqa uchun",
                                          style:
                                              AppTextstyle.nunitoBold.copyWith(
                                            color: !_isForSelf
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextFeildWidget(
                                  readOnly: _isForSelf,
                                  title: S.of(context).fio,
                                  hintText: _isForSelf
                                      ? data.fullName
                                      : S.of(context).fio,
                                  controller: _fullNameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(context).please_fullname;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).phone_number,
                                      style: AppTextstyle.nunitoExtraBold
                                          .copyWith(fontSize: 17),
                                    ),
                                    const SizedBox(height: 5),
                                    PhoneInputField(
                                      isFlag: false,
                                      readOnly: _isForSelf,
                                      phoneController: _phoneInputController,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                DatePickerWidget(
                                  onTap: !_isForSelf,
                                  controller: _birthDateController,
                                  selectedDate: _selectedDate,
                                  onDateSelected: (newDate) {
                                    if (!_isForSelf) {
                                      setState(() {
                                        _selectedDate = newDate;
                                        _birthDateController.text =
                                            "${_selectedDate!.year.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day}";
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                GenderSelectionField(
                                  controller: _genderController,
                                  readOnly: _isForSelf,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _genderController.text = value;
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                ImagePickerWidget(
                                  maxImages: 1,
                                  onImagesUpdated: _updateImageFiles,
                                ),
                                const SizedBox(height: 20),
                                widget.online
                                    ? LocationWidget(
                                        addressController: addressController,
                                        entranceController: entranceController,
                                        floorController: floorController,
                                        apartmentController:
                                            apartmentController,
                                        houseController: houseController,
                                        landmarkController: landmarkController,
                                        latController: latController,
                                        longController: longController,
                                        accessCodeController:
                                            accessCodeController,
                                        formKey: formKey,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                if (state.error.code == 400) {
                  return NoInternetConnectionWidget(
                    onRetry: () =>
                        context.read<ProfileBloc>().add(GetProfileData()),
                  );
                } else if (state.error.code == 500) {
                  return ServerConnection(
                    onRetry: () =>
                        context.read<ProfileBloc>().add(GetProfileData()),
                  );
                }
                return Center(
                  child: Text(
                    S.of(context).unexpected_error,
                    style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
                  ),
                );
              }
              return const SizedBox.expand();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return BlocListener<DoctorRequestBloc, DoctorRequestState>(
                  listener: (context, state) {
                    if (state is DoctorRequestLoaded ||
                        state is DoctorRequestLoading) {
                      if (state is DoctorRequestLoaded) {
                        context.router.maybePop();
                      }
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => UnifiedLoadingAnimation(
                          isSuccess: state is DoctorRequestLoaded,
                          theme: const LoadingDialogTheme(
                            primaryColor: Colors.blue,
                            backgroundColor: Colors.white,
                          ),
                          text: LoadingDialogText(
                            loadingTitle: S.of(context).loading,
                            loadingSubtitle: S.of(context).please_wait,
                            successTitle: S.of(context).successful,
                            successSubtitle:
                                S.of(context).order_successfully_created,
                          ),
                          onComplete: () {
                            context.router.pushAndPopUntil(
                              const MainRoute(),
                              predicate: (route) => false,
                            );
                          },
                        ),
                      );
                    } else if (state is DoctorRequestError) {
                      ErrorHandler.showError(context, state.error.code);
                      context.maybePop();
                    }
                  },
                  child: BottomAppBar(
                    color: Colors.transparent,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: const Size(double.maxFinite, 50),
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          profileState is ProfileLoading ? null : _submitForm,
                      child: Text(
                        S.of(context).Continue,
                        style: AppTextstyle.nunitoBold
                            .copyWith(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
