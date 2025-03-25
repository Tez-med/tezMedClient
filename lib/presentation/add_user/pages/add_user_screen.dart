import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/models/validation_result.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/validators/form_validators.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/add_client/model/add_client_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/presentation/add_user/bloc/add_client/add_client_bloc.dart';
import 'package:tez_med_client/presentation/add_user/pages/select_region.dart';
import 'package:tez_med_client/presentation/add_user/widgets/custom_card.dart';
import 'package:tez_med_client/presentation/auth/widgets/phone_input.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';
import '../../../core/error/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../user_details_request/widgets/date_picker_widget.dart';
import '../../user_details_request/widgets/gender_selection_widget.dart';
import '../../user_details_request/widgets/text_feild_widget.dart';
import '../widgets/location_select_button.dart';
import '../widgets/register_success_dialog.dart';

@RoutePage()
class AddUserScreen extends StatefulWidget {
  final String phoneNumber;
  const AddUserScreen({super.key, required this.phoneNumber});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LocationService locationService = LocationService();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneInputController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _extraPhoneController;
  double? latitude;
  double? longitude;
  String? _selectedGender;
  DateTime? _selectedDate;
  String? _selectedRegionId;
  String? _selectedRegion;

  final ValueNotifier<ValidationResult> _nameValidation =
      ValueNotifier(ValidationResult.success());
  final ValueNotifier<ValidationResult> _dateValidation =
      ValueNotifier(ValidationResult.success());
  final ValueNotifier<ValidationResult> _phoneValidation =
      ValueNotifier(ValidationResult.success());
  final ValueNotifier<bool> _showLocationError = ValueNotifier(false);
  final ValueNotifier<bool> _showRegionError = ValueNotifier(false);
  final ValueNotifier<bool> _showGenderError = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupListeners();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController();
    _phoneInputController = TextEditingController(text: widget.phoneNumber);
    _birthDateController = TextEditingController();
    _extraPhoneController = TextEditingController();
  }

  void _setupListeners() {
    _fullNameController.addListener(() {
      final validation =
          FormValidators.validateFullName(_fullNameController.text);
      _nameValidation.value = validation;
      if (!validation.isValid) {
        _nameValidation.value = validation;
      }
    });

    _extraPhoneController.addListener(
      () {
        final validation =
            FormValidators.validatePhoneNumber(_extraPhoneController.text);
        _phoneValidation.value = validation;
        if (!validation.isValid) {
          _phoneValidation.value = validation;
        }
      },
    );

    _birthDateController.addListener(() {
      if (_selectedDate != null) {
        final validation = FormValidators.validateDate(_selectedDate);
        _dateValidation.value = validation;
      }
    });
  }

  void _showError(String message) {
    if (mounted) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: message,
        type: SnackbarType.warning,
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    try {
      final data = _prepareFormData();
      if (data != null) {
        context.read<AddClientBloc>().add(AddClient(data));
      }
    } catch (e) {
      _showError('Formani yuborishda xatolik yuz berdi');
    }
  }

  AddClientModel? _prepareFormData() {
    if (!_validateForm()) return null;

    return AddClientModel(
      regionId: _selectedRegionId!,
      extraPhone: _extraPhoneController.text.isNotEmpty
          ? FormValidators.formatPhoneNumber(_extraPhoneController.text)
          : '',
      birthday: FormValidators.formatDate(_selectedDate!),
      createdAt: DateTime.now().toIso8601String(),
      fullName: _fullNameController.text.trim(),
      gender: _selectedGender!,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
      phoneNumber: FormValidators.formatPhoneNumber(_phoneInputController.text),
    );
  }

  bool _validateForm() {
    final nameValidation =
        FormValidators.validateFullName(_fullNameController.text);
    _nameValidation.value = nameValidation;
    if (!nameValidation.isValid) {
      _showError(nameValidation.errorMessage!);
      return false;
    }
    if (_extraPhoneController.text.isNotEmpty) {
      final phoneValidation =
          FormValidators.validatePhoneNumber(_extraPhoneController.text);
      _phoneValidation.value = phoneValidation;
      if (!phoneValidation.isValid) {
        _showError(phoneValidation.errorMessage!);
        return false;
      }
    }

    final dateValidation = FormValidators.validateDate(_selectedDate);
    _dateValidation.value = dateValidation;
    if (!dateValidation.isValid) {
      _showError(dateValidation.errorMessage!);
      return false;
    }

    if (_selectedGender == null) {
      _showGenderError.value = true;
      _showError(S.of(context).please_gender);
      return false;
    }
    _showGenderError.value = false;

    if (_selectedRegionId == null) {
      _showRegionError.value = true;
      _showError(S.of(context).please_region);
      return false;
    }
    _showRegionError.value = false;

    if (latitude == null || longitude == null) {
      _showLocationError.value = true;
      _showError(S.of(context).please_location);
      return false;
    }
    _showLocationError.value = false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            _buildForm(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 1,
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
        S.of(context).sign_up,
        style: AppTextstyle.nunitoBold.copyWith(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildNameField(),
              _buildExtraPhoneField(),
              _buildDateField(),
              _buildGenderField(),
              _buildRegionField(),
              _buildLocationField(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return ValueListenableBuilder<ValidationResult>(
      valueListenable: _nameValidation,
      builder: (context, validation, _) {
        return CustomCard(
          showError: !validation.isValid,
          child: TextFeildWidget(
            title: S.of(context).fio,
            hintText: S.of(context).enter_fullname,
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                validation.isValid ? null : validation.errorMessage,
          ),
        );
      },
    );
  }

  Widget _buildExtraPhoneField() {
    return ValueListenableBuilder<ValidationResult>(
      valueListenable: _phoneValidation,
      builder: (context, validation, _) {
        return CustomCard(
          showError: !validation.isValid,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).additional_phone_number,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              PhoneInputField(
                phoneController: _extraPhoneController,
                validator: (value) =>
                    validation.isValid ? null : validation.errorMessage,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField() {
    return ValueListenableBuilder<ValidationResult>(
      valueListenable: _dateValidation,
      builder: (context, validation, _) {
        return CustomCard(
          showError: !validation.isValid,
          child: DatePickerWidget(
            controller: _birthDateController,
            selectedDate: _selectedDate,
            onDateSelected: (newDate) {
              setState(() {
                _selectedDate = newDate;
                _dateValidation.value = FormValidators.validateDate(newDate);
                if (_dateValidation.value.isValid) {
                  _birthDateController.text =
                      FormValidators.formatDate(newDate);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildGenderField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showGenderError,
      builder: (context, showError, _) {
        return CustomCard(
          showError: showError,
          child: GenderSelectionWidget(
            selectedGender: _selectedGender,
            onGenderSelected: (gender) {
              setState(() {
                _selectedGender = gender;
                _showGenderError.value = false;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildRegionField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showRegionError,
      builder: (context, showError, _) {
        return CustomCard(
          showError: showError,
          child: RegionSelector(
            selectedRegion: _selectedRegion,
            onRegionSelected: (region, regionId) {
              setState(() {
                _selectedRegion = region;
                _selectedRegionId = regionId;
                _showRegionError.value = false;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildLocationField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showLocationError,
      builder: (context, showError, _) {
        return CustomCard(
          showError: showError,
          child: LocationSelectorButton(
            locationService: locationService,
            onLocationSelected: (location) {
              setState(() {
                latitude = location.latitude;
                longitude = location.longitude;
                _showLocationError.value = false;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocListener<AddClientBloc, AddClientState>(
        listener: _handleBlocState,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              fixedSize: const Size(double.maxFinite, 50),
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _submitForm,
            child: Text(
              S.of(context).confirm,
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBlocState(BuildContext context, AddClientState state) {
    if (state is AddClientLoading) {
      _showLoadingDialog();
    } else if (state is AddClientLoaded) {
      _handleSuccess();
    } else if (state is AddClientError) {
      _handleError(state);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        onPopInvokedWithResult: (didPop, result) async => false,
        child: const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSuccess() {
    LocalStorageService().setBool(StorageKeys.isRegister, true).then((_) {
      context.router.maybePop();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          onPopInvokedWithResult: (didPop, result) async => false,
          child: const RegisterSuccessDialog(),
        ),
      );
    }).catchError((error) {
      debugPrint(
          'Ro‘yxatdan o‘tish muvaffaqiyatli yakunlandi, lekin saqlashda xatolik yuz berdi');
    });
  }

  void _handleError(AddClientError state) {
    Navigator.of(context).pop();
    ErrorHandler.showError(context, state.error.code);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneInputController.dispose();
    _birthDateController.dispose();
    _extraPhoneController.dispose();
    _nameValidation.dispose();
    _dateValidation.dispose();
    _phoneValidation.dispose();
    _showLocationError.dispose();
    _showRegionError.dispose();
    _showGenderError.dispose();

    super.dispose();
  }
}
