import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/data/service_price/service_price_source.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/auth/widgets/phone_input.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/date_picker_widget.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/text_feild_widget.dart';

import '../widgets/image_picker_widget.dart';

@RoutePage()
class UserDetails extends StatefulWidget {
  final RequestModel requestModel;
  const UserDetails({super.key, required this.requestModel});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneInputController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _extraPhoneController = TextEditingController();

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
    final priceResponse =
        await ServicePriceSource(getIt<DioClientRepository>()).getPrice();
    priceResponse.fold(
      (failure) {},
      (price) {
        context.router.push(
          ServiceInfo(
            price: price,
            requestModel: widget.requestModel.copyWith(
              photos: _imagesNotifier.value,
              clientBody: ClientBody(extraPhone: _extraPhoneController.text),
            ),
          ),
        );
      },
    );
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
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            bloc: context.read<ProfileBloc>()..add(GetProfileData()),
            builder: (context, state) {
              if (state is ProfileLoading) {
                return _buildLoadingContent();
              } else if (state is ProfileLoaded) {
                final data = state.clientModel;
                _fullNameController.text = data.fullName;
                _birthDateController.text = data.birthday;
                _phoneInputController.text = data.phoneNumber.substring(4);
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
                                TextFeildWidget(
                                  readOnly: true,
                                  title: S.of(context).fio,
                                  hintText: data.fullName,
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
                                      style: AppTextstyle.nunitoBold
                                          .copyWith(fontSize: 17),
                                    ),
                                    const SizedBox(height: 5),
                                    PhoneInputField(
                                      readOnly: true,
                                      phoneController: _phoneInputController,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).additional_number,
                                      style: AppTextstyle.nunitoBold
                                          .copyWith(fontSize: 17),
                                    ),
                                    const SizedBox(height: 5),
                                    PhoneInputField(
                                      readOnly: false,
                                      phoneController: _extraPhoneController,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                DatePickerWidget(
                                  onTap: true,
                                  controller: _birthDateController,
                                  selectedDate: _selectedDate,
                                  onDateSelected: (newDate) {
                                    setState(() {
                                      _selectedDate = newDate;
                                      _birthDateController.text =
                                          "${_selectedDate!.year.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day}";
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                ImagePickerWidget(
                                  maxImages: 5,
                                  onImagesUpdated: _updateImageFiles,
                                ),
                                const SizedBox(height: 20),
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
              builder: (context, state) {
                return BottomAppBar(
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
                    onPressed: state is ProfileLoading ? null : _submitForm,
                    child: Text(
                      S.of(context).Continue,
                      style: AppTextstyle.nunitoBold
                          .copyWith(fontSize: 17, color: Colors.white),
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

  Widget _buildLoadingContent() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).phone_number,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).birthday,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).birthday,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).birthday,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).birthday,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
