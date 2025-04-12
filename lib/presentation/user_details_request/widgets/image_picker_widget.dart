import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/profile/widgets/image_picker.dart';
import 'package:tez_med_client/presentation/request/bloc/file_upload/file_upload_bloc.dart';
import '../../../gen/assets.gen.dart';

class ImagePickerWidget extends StatefulWidget {
  final int maxImages;
  final String? title; 
  final Function(List<String>) onImagesUpdated;

  const ImagePickerWidget({
    super.key,
    this.maxImages = 5,
    required this.onImagesUpdated,
    this.title, // title optional
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget>
    with SingleTickerProviderStateMixin {
  final List<File> _images = [];
  final List<String> _imagesUrl = [];
  late final AnimationController _animationController;
  File? _loadingImage;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: source);
      if (selectedImage != null && mounted) {
        setState(() => _loadingImage = File(selectedImage.path));
        context
            .read<FileUploadBloc>()
            .add(ImageUpload("image", _loadingImage!));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        _showErrorSnackbar(S.of(context).photo_error);
      }
    }
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
          setState(() => _loadingImage = selectedFile);
          context
              .read<FileUploadBloc>()
              .add(ImageUpload("image", _loadingImage!));
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        _showErrorSnackbar(S.of(context).photo_error);
      }
    }
  }

  void _handleImageSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ImagePickerModal(
        showDelete: _canDeleteImage,
        onCameraTap: () {
          _pickImage(ImageSource.camera);
          context.router.maybePop();
        },
        onGalleryTap: () async {
          await _pickImageFromGallery();
          context.router.maybePop();
        },
        onDeleteTap: _canDeleteImage
            ? () {
                setState(() {
                  _loadingImage = null;
                });
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    AnimatedCustomSnackbar.show(
      context: context,
      message: message,
      type: SnackbarType.error,
    );
  }

  bool get _canDeleteImage => _loadingImage != null;

  void _removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      setState(() {
        _images.removeAt(index);
        _imagesUrl.removeAt(index);
      });
      _updateParent();
    }
  }

  void _updateParent() {
    widget.onImagesUpdated(_imagesUrl);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileUploadBloc, FileUploadState>(
      listener: (context, state) {
        if (state is ImageUploadProgress) {
          setState(() {
            _isUploading = true;
            _uploadProgress = state.progress;
          });
        } else if (state is ImageUploadSucces) {
          setState(() {
            if (_loadingImage != null) {
              _images.add(_loadingImage!);
              _imagesUrl.add(state.uploadedFileUrl.toString());
              _loadingImage = null;
              _isUploading = false;
              _uploadProgress = 0.0;
            }
          });
          _updateParent();
        } else if (state is FileUploadError) {
          setState(() {
            _loadingImage = null;
            _isUploading = false;
            _uploadProgress = 0.0;
          });
          AnimatedCustomSnackbar.show(
            context: context,
            message: S.of(context).image_not_loaded,
            type: SnackbarType.error,
          );
        }
      },
      builder: (context, state) {
        final totalImages = _images.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title faqat berilgan bo'lsagina ko'rsatiladi
            if (widget.title != null)
              Text(
                widget.title!,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
              ),
            Column(
              children: [
                if (totalImages > 0 || _loadingImage != null)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: totalImages + (_loadingImage != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == totalImages && _loadingImage != null) {
                          return _buildLoadingImageItem();
                        }
                        return _buildLocalImageItem(index);
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                if (totalImages < widget.maxImages && !_isUploading)
                  GestureDetector(
                    onTap: _handleImageSelection,
                    child: Hero(
                      tag: 'imagePickerHero',
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.buttonBackColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.camera.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                S.of(context).open_camera,
                                style: AppTextstyle.nunitoBold.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocalImageItem(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.buttonBackColor),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _showImageFullscreen(_images[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _images[index],
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.7), // withValues o'rniga withOpacity
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingImageItem() {
    return Container(
      width: 80,
      height: 100,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.buttonBackColor),
      ),
      child: Stack(
        children: [
          if (_loadingImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _loadingImage!,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black
                  .withOpacity(0.5), // withValues o'rniga withOpacity
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.white
                        .withOpacity(0.2), // withValues o'rniga withOpacity
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageFullscreen(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(child: Image.file(imageFile)),
          ),
        ),
      ),
    );
  }
}
