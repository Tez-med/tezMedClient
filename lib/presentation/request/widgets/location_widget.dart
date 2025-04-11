import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/bloc/my_address/my_address_bloc.dart';
import 'package:tez_med_client/presentation/request/widgets/addres_error.dart';
import 'package:tez_med_client/presentation/request/widgets/my_adress_empty.dart';
import 'package:tez_med_client/presentation/request/widgets/my_adress_loading.dart';
import 'package:tez_med_client/presentation/request/widgets/select_table_feild.dart';

class LocationWidget extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController houseController;
  final TextEditingController landmarkController;
  final TextEditingController latController;
  final TextEditingController longController;
  final TextEditingController accessCodeController;
  final GlobalKey<FormState> formKey;

  const LocationWidget({
    super.key,
    required this.addressController,
    required this.entranceController,
    required this.floorController,
    required this.apartmentController,
    required this.houseController,
    required this.landmarkController,
    required this.latController,
    required this.longController,
    required this.accessCodeController,
    required this.formKey,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  bool _isApartmentSelected = false;
  bool _autovalidateMode = false;
  bool _isValid = false;

  void _validateInputs() {
    setState(() {
      _isValid = widget.houseController.text.isNotEmpty ||
          widget.apartmentController.text.isNotEmpty;
    });
  }

  void _fillAddressDetails(Map<String, dynamic> selectedLocation) {
    widget.addressController.text = selectedLocation['name'] ?? '';
    widget.latController.text = selectedLocation['latitude']?.toString() ?? '';
    widget.longController.text =
        selectedLocation['longitude']?.toString() ?? '';
    widget.houseController.text = selectedLocation['house'] ?? '';
    widget.apartmentController.text = selectedLocation['apartment'] ?? '';
    widget.floorController.text = selectedLocation['floor'] ?? '';
    widget.entranceController.text = selectedLocation['entrance'] ?? '';

    setState(() {
      _isApartmentSelected = selectedLocation['apartment'] != null;
    });

    _validateInputs();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).address,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      minChildSize: 0.7,
                      maxChildSize: 0.98,
                      builder: (context, scrollController) {
                        return BlocBuilder<MyAddressBloc, MyAddressState>(
                          bloc: context.read<MyAddressBloc>()
                            ..add(FetchMyAddress()),
                          builder: (context, state) {
                            return Column(
                              children: [
                                _buildSelectAddressButton(context),
                                Expanded(
                                    child: _buildAddressContent(state,
                                        scrollController)), // Manzil ro‘yxati
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: AbsorbPointer(
              child: TextFormField(
                onChanged: (value) {
                  widget.formKey.currentState!.validate();
                },
                controller: widget.addressController,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).please_select_address;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.buttonBackColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _autovalidateMode &&
                              (widget.addressController.text.isEmpty)
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _autovalidateMode &&
                              (widget.addressController.text.isEmpty)
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _autovalidateMode &&
                              (widget.addressController.text.isEmpty)
                          ? Colors.red
                          : AppColor.primaryColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(Icons.location_on, color: Colors.blue[700]),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  hintText: S.of(context).select_address,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SelectTableFeild(
                  isValid: _isValid,
                  context: context,
                  title: S.of(context).house,
                  controller: widget.houseController,
                  onChanged: (value) {
                    _validateInputs();
                    widget.formKey.currentState!.validate();

                    if (value.isNotEmpty) {
                      setState(() {
                        _isApartmentSelected = false;
                        widget.apartmentController.clear();
                      });
                    }
                  }),
              const SizedBox(width: 12),
              SelectTableFeild(
                  isValid: _isValid,
                  context: context,
                  title: S.of(context).apartment,
                  controller: widget.apartmentController,
                  onChanged: (value) {
                    widget.formKey.currentState!.validate();

                    _validateInputs();
                    if (value.isNotEmpty) {
                      setState(() {
                        _isApartmentSelected = true;
                        widget.houseController.clear();
                      });
                    }
                  }),
            ],
          ),
          if (_isApartmentSelected) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _buildNumberField(
                  onChanged: (p0) {
                    widget.formKey.currentState!.validate();
                  },
                  title: S.of(context).floor,
                  controller: widget.floorController,
                  isRequired: true,
                ),
                const SizedBox(width: 12),
                _buildNumberField(
                  onChanged: (p0) {
                    widget.formKey.currentState!.validate();
                  },
                  title: S.of(context).entrance,
                  controller: widget.entranceController,
                  isRequired: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.accessCodeController,
              decoration: InputDecoration(
                hintText: S.of(context).access_code,
                hintStyle: AppTextstyle.nunitoMedium,
                errorStyle:
                    AppTextstyle.nunitoMedium.copyWith(color: Colors.red),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColor.greyTextColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColor.primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColor.buttonBackColor,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).destination_additional_information,
                style: AppTextstyle.nunitoMedium.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.landmarkController,
                decoration: InputDecoration(
                  hintText: S.of(context).example,
                  hintStyle: AppTextstyle.nunitoMedium,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColor.primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColor.greyTextColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColor.greyTextColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressContent(
      MyAddressState state, ScrollController scrollController) {
    if (state is MyAddressLoading) {
      return MyAdreessLoadingWidget();
    } else if (state is MyAddressLoaded) {
      if (state.locationModel.isEmpty) {
        return MyAdressEmpty(context: context);
      }

      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 0),
        itemCount: state.locationModel.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[300],
          indent: 50,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final data = state.locationModel[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final selectedLocation = {
                  'name': data.name.isEmpty ? null : data.name,
                  'latitude': data.latitude,
                  'longitude': data.longitude,
                  'house': data.house.isEmpty ? null : data.house,
                  'apartment': data.apartment.isEmpty ? null : data.apartment,
                  'floor': data.floor.isEmpty ? null : data.floor,
                  'entrance': data.entrance.isEmpty ? null : data.entrance,
                };

                _fillAddressDetails(selectedLocation);
                Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Center(
                      child: Icon(
                        data.house.isEmpty
                            ? CupertinoIcons.building_2_fill
                            : Icons.house_rounded,
                        color: AppColor.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name.isNotEmpty
                                ? data.name
                                : 'Nomi kiritilmagan',
                            style: AppTextstyle.nunitoMedium.copyWith(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getFullAddress(data),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColor.primaryColor.withValues(alpha: 0.7),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (state is MyAddressError) {
      if (state.error.code == 41) {
        return AddreesError(context: context);
      }
      return AddressError2(context: context);
    }

    return const SizedBox.expand();
  }

  String _getFullAddress(dynamic data) {
    List<String> addressParts = [];
    if (data.house.isNotEmpty) {
      addressParts.add("${S.of(context).house} ${data.house}");
    }
    if (data.apartment.isNotEmpty) {
      addressParts.add("${S.of(context).apartment} ${data.apartment}");
    }
    if (data.floor.isNotEmpty) {
      addressParts.add("${S.of(context).floor} ${data.floor}");
    }
    if (data.entrance.isNotEmpty) {
      addressParts.add("${S.of(context).entrance} ${data.entrance}");
    }
    return addressParts.join(", ");
  }

  Widget _buildSelectAddressButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await context.router.push<Map<String, dynamic>>(
              const YandexMapRoute(),
            );

            if (result != null) {
              setState(() {
                _autovalidateMode = false;
                _isApartmentSelected = false;
              });
              widget.addressController.text = result['address'];
              widget.latController.text = result['latitude'].toString();
              widget.longController.text = result['longitude'].toString();
              widget.apartmentController.text = '';
              widget.entranceController.text = '';
              widget.floorController.text = '';
              widget.houseController.text = '';
            }
            context.router.maybePop();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    S.of(context).another_address,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black87,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String title,
    required TextEditingController controller,
    bool isRequired = false,
    void Function(String)? onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextstyle.nunitoMedium.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (value) => onChanged?.call(value),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return S.of(context).required_field;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: '№',
              hintStyle: AppTextstyle.nunitoMedium,
              errorStyle: AppTextstyle.nunitoMedium.copyWith(color: Colors.red),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color:
                      _autovalidateMode && isRequired && controller.text.isEmpty
                          ? Colors.red
                          : AppColor.greyTextColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color:
                      _autovalidateMode && isRequired && controller.text.isEmpty
                          ? Colors.red
                          : AppColor.primaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColor.buttonBackColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
