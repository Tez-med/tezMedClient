import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/auth/widgets/button_widget.dart';
import 'package:tez_med_client/presentation/auth/widgets/phone_input.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_update/profile_update_bloc.dart';
import 'package:tez_med_client/presentation/profile/widgets/format_phone_number.dart';
import 'package:tez_med_client/presentation/profile/widgets/image_picker.dart';
import 'package:tez_med_client/presentation/profile/widgets/profile_image.dart';
import 'package:tez_med_client/presentation/request/bloc/file_upload/file_upload_bloc.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/date_picker_widget.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/gender_selection_widget.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/text_feild_widget.dart';

@RoutePage()
class ProfileUpdateScreen extends StatefulWidget {
  final ClientModel clientModel;

  const ProfileUpdateScreen({super.key, required this.clientModel});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthdayController;

  File? _imageFile;
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController =
        TextEditingController(text: widget.clientModel.fullName);
    final birthday = widget.clientModel.birthday.replaceAll('/', '-');
    _birthdayController = TextEditingController(text: birthday);
    _phoneController = TextEditingController(
      text: formatPhoneNumber(widget.clientModel.phoneNumber),
    );
    _selectedGender = widget.clientModel.gender;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  String _formatBirthday(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: source);
      if (selectedImage != null && mounted) {
        setState(() => _imageFile = File(selectedImage.path));
        context.read<FileUploadBloc>().add(ImageUpload("image", _imageFile!));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        _showErrorSnackbar(S.of(context).photo_error);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    AnimatedCustomSnackbar.show(
      context: context,
      message: message,
      type: SnackbarType.error,
    );
  }

  void _handleImageSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ImagePickerModal(
        showDelete: _canDeleteImage,
        onCameraTap: () {
          _pickImage(ImageSource.camera); //
          context.router.maybePop();
        },
        onGalleryTap: () async {
          await _pickImageFromGallery();
          context.router.maybePop();
        },
        onDeleteTap: _canDeleteImage
            ? () {
                setState(() {
                  _imageFile = null;
                  _uploadedImageUrl = null;
                });
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final selectedFile = File(result.files.single.path!);
        if (mounted) {
          setState(() => _imageFile = selectedFile);
          context.read<FileUploadBloc>().add(ImageUpload("image", _imageFile!));
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        _showErrorSnackbar(S.of(context).photo_error);
      }
    }
  }

  bool get _canDeleteImage =>
      _imageFile != null || widget.clientModel.photo.isNotEmpty;

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await getIt<NotificationRepository>().getFcmToken();
    final data = ProfileUpdateModel(
      birthday: _birthdayController.text,
      fullName: _fullNameController.text,
      gender: _selectedGender ?? '',
      fcmToken: token!,
      latitude: widget.clientModel.latitude,
      longitude: widget.clientModel.longitude,
      phoneNumber:
          "+998${_phoneController.text.replaceAll(RegExp(r'[^\d]'), '')}",
      photo: _uploadedImageUrl ?? widget.clientModel.photo,
      updatedAt: DateTime.now().toString(),
    );

    context.read<ProfileUpdateBloc>().add(ProfileUpdate(data));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
          listener: (context, state) {
            if (state is ProfileUpdateLoaded) {
              AnimatedCustomSnackbar.show(
                context: context,
                message: S.of(context).information_update,
                type: SnackbarType.success,
              );
              context.read<ProfileBloc>().add(GetProfileData());
              context.router.maybePop(true);
            } else if (state is ProfileUpdateError) {
              ErrorHandler.showError(context, state.error.code);
            }
          },
        ),
        BlocListener<FileUploadBloc, FileUploadState>(
          listener: (context, state) {
            if (state is FileUploadError) {
              _showErrorSnackbar(S.of(context).image_not_loaded);
            } else if (state is ImageUploadSucces) {
              setState(() => _uploadedImageUrl = state.uploadedFileUrl);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.buttonBackColor,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildBody(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomBar(),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      shadowColor: AppColor.buttonBackColor,
      elevation: 1,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Text(
        S.of(context).personal_information,
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildImagePicker(state),
                      const SizedBox(height: 24),
                      _buildFormFields(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePicker(FileUploadState state) {
    return GestureDetector(
      onTap: () {
        if (state is! FileUploadLoading) {
          _handleImageSelection();
        }
      },
      child: Stack(
        children: [
          ProfileImage(
            imageFile: _imageFile,
            widget: widget,
            state: state,
          ),
          if (state is! FileUploadLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColor.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFeildWidget(
          title: S.of(context).fio,
          hintText: S.of(context).enter_fullname,
          controller: _fullNameController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
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
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 5),
            PhoneInputField(phoneController: _phoneController),
          ],
        ),
        const SizedBox(height: 20),
        DatePickerWidget(
          controller: _birthdayController,
          selectedDate: _selectedDate,
          onDateSelected: (newDate) {
            setState(() {
              _selectedDate = newDate;
              _birthdayController.text = _formatBirthday(newDate);
            });
          },
        ),
        const SizedBox(height: 20),
        GenderSelectionWidget(
          selectedGender: _selectedGender,
          onGenderSelected: (gender) {
            setState(() => _selectedGender = gender);
          },
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
      builder: (context, state) {
        return BottomAppBar(
          color: Colors.transparent,
          child: ButtonWidget(
            consent: state is! ProfileUpdateLoading,
            onPressed: _handleSubmit,
            isLoading: state is ProfileUpdateLoading,
          ),
        );
      },
    );
  }
}
