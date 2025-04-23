import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/domain/disease/entitiy/disease_entity.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/auth/widgets/button_widget.dart';
import 'package:tez_med_client/presentation/disease/bloc/disease_bloc.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/image_picker_widget.dart';

class VideoCallCompletionBottomSheet extends StatefulWidget {
  final String clientId;
  final String scheduleId;

  const VideoCallCompletionBottomSheet({
    super.key,
    required this.clientId,
    required this.scheduleId,
  });

  @override
  State<VideoCallCompletionBottomSheet> createState() =>
      _VideoCallCompletionBottomSheetState();
}

class _VideoCallCompletionBottomSheetState
    extends State<VideoCallCompletionBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _photos = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitDisease() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).fill_all_fields,
        type: SnackbarType.error,
      );
      return;
    }

    final disease = DiseasePost(
      clientId: widget.clientId,
      description: _descriptionController.text,
      name: _nameController.text,
      photo: _photos,
      scheduleId: widget.scheduleId,
    );

    context.read<DiseaseBloc>().add(CreateDisease(disease));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DiseaseBloc, DiseaseState>(
      listener: (context, state) {
        if (state is DiseaseLoadedPost) {
          context.read<DiseaseBloc>().add(FetchDiseases());
          AnimatedCustomSnackbar.show(
              context: context,
              message: S.of(context).data_saved_successfully,
              type: SnackbarType.success);

          Navigator.pop(context);
        } else if (state is DiseaseError) {
          ErrorHandler.showError(context, state.error.code);
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  S.of(context).video_call_ended,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  S.of(context).video_call_exit_message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Name field with subtle label
              Text(
                S.of(context).disease_name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description field
              Text(
                S.of(context).description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Document picker with simplified design
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ImagePickerWidget(
                    maxImages: 5,
                    onImagesUpdated: (images) {
                      setState(() {
                        _photos = images;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Buttons row
              BlocBuilder<DiseaseBloc, DiseaseState>(
                builder: (context, state) {
                  final isLoading = state is DiseaseLoading;
                  return ButtonWidget(
                      consent: !isLoading,
                      onPressed: _submitDisease,
                      isLoading: isLoading);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
