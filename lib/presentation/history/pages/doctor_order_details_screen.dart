import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:flutter/gestures.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/schedule_id/schedule_get_id_bloc.dart';
import 'package:tez_med_client/presentation/home/order_details/widgets/photo_view.dart';

@RoutePage()
class DoctorOrderDetailsScreen extends StatefulWidget {
  final String id;

  const DoctorOrderDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<DoctorOrderDetailsScreen> createState() =>
      _DoctorOrderDetailsScreenState();
}

class _DoctorOrderDetailsScreenState extends State<DoctorOrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  void _fetchScheduleData() {
    context.read<ScheduleGetIdBloc>().add(GetScheduleId(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: .5,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      title: Text(
        S.of(context).order_info,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ScheduleGetIdBloc, ScheduleGetIdState>(
      builder: (context, state) {
        if (state is ScheduleGetIdLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ScheduleGetIdError) {
          return _handleError(state);
        } else if (state is ScheduleGetIdSuccess) {
          return _buildScheduleDetails(state.data);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _handleError(ScheduleGetIdError state) {
    if (state.error.code == 500) {
      return Center(
        child: NoInternetConnectionWidget(
          onRetry: _fetchScheduleData,
        ),
      );
    } else if (state.error.code == 400) {
      return Center(
        child: ServerConnection(
          onRetry: _fetchScheduleData,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorHandler.getErrorMessage(context, state.error.code);
    });

    return const SizedBox.shrink();
  }

  Widget _buildScheduleDetails(Schedule schedule) {
    final format = NumberFormat("#,###");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order info section
          _buildSectionCard(
            title: S.of(context).order_info,
            child: Column(
              children: [
                _buildInfoRow(
                  title: S.of(context).order_date,
                  value: schedule.date,
                ),
                _buildDivider(),
                _buildInfoRow(
                  title: S.of(context).startTimeLabel,
                  value: schedule.time,
                ),
                _buildDivider(),
                _buildInfoRow(
                  title: S.of(context).priceLabel,
                  value:
                      "${format.format(schedule.price)} ${S.of(context).sum}",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Order photo section - conditional
          if (schedule.photo.isNotEmpty) ...[
            _buildSectionCard(
              title: S.of(context).order_photo,
              child: GestureDetector(
                onTap: () => _showFullImage(0, [schedule.photo]),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primaryColor,
                        Colors.deepPurple.withValues(alpha: .3)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Asosiy rasm
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomCachedImage(
                              image: schedule.photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Patient medical card section - conditional
          if (schedule.diseases.isNotEmpty)
            _buildSectionCard(
              title: S.of(context).patient_medical_card,
              child: Column(
                children: [
                  for (int i = 0; i < schedule.diseases.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _buildDiseaseCard(schedule.diseases[i]),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Divider(color: AppColor.buttonBackColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Colors.grey[200],
        height: 1,
      ),
    );
  }

  Widget _buildDiseaseCard(Disease disease) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disease name
          Text(
            disease.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Disease description - conditional
          if (disease.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              disease.description,
              style: const TextStyle(fontSize: 14),
            ),
          ],

          // Disease photos - conditional
          if (disease.photo.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              S.of(context).attached_images,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: _buildPhotoGallery(disease.photo),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(List<String> photos) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: photos.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showFullImage(index, photos),
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomCachedImage(image: photos[index]),
            ),
          ),
        );
      },
    );
  }

  void _showFullImage(int index, List<String> photos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: photos,
          initialIndex: index,
        ),
      ),
    );
  }
}
