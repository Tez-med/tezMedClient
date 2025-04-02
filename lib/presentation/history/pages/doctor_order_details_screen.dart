import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/schedule_id/schedule_get_id_bloc.dart';
import 'package:tez_med_client/presentation/home/order_details/widgets/photo_view.dart';

@RoutePage()
class DoctorOrderDetailsScreen extends StatefulWidget {
  final String id;
  const DoctorOrderDetailsScreen({super.key, required this.id});

  @override
  State<DoctorOrderDetailsScreen> createState() =>
      _DoctorOrderDetailsScreenState();
}

class _DoctorOrderDetailsScreenState extends State<DoctorOrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleGetIdBloc>().add(GetScheduleId(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: .5,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Text(
          S.of(context).order_info,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<ScheduleGetIdBloc, ScheduleGetIdState>(
        builder: (context, state) {
          if (state is ScheduleGetIdLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is ScheduleGetIdError) {
            if (state.error.code == 500) {
              return Center(
                child: NoInternetConnectionWidget(
                  onRetry: () => context
                      .read<ScheduleGetIdBloc>()
                      .add(GetScheduleId(widget.id)),
                ),
              );
            } else if (state.error.code == 400) {
              return Center(
                child: ServerConnection(
                  onRetry: () => context
                      .read<ScheduleGetIdBloc>()
                      .add(GetScheduleId(widget.id)),
                ),
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorHandler.getErrorMessage(context, state.error.code);
            });
            return const SizedBox.shrink();
          } else if (state is ScheduleGetIdSuccess) {
            final schedule = state.data;
            return _buildScheduleDetails(schedule);
          }
          return const Center();
        },
      ),
    );
  }

  Widget _buildScheduleDetails(Schedule schedule) {
    final format = NumberFormat("#,###");
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: S.of(context).order_info,
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  title: S.of(context).order_date,
                  value: schedule.date,
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.access_time,
                  title: S.of(context).startTimeLabel,
                  value: schedule.time,
                ),
                _buildDivider(),
                _buildInfoRow(
                  icon: Icons.monetization_on,
                  title: S.of(context).priceLabel,
                  value:
                      "${format.format(schedule.price)} ${S.of(context).sum}",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          Divider(
            color: AppColor.buttonBackColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
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
            color: valueColor,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  disease.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (disease.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              disease.description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
          if (disease.photo.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              S.of(context).attached_images,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: disease.photo.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _showFullImage(index, disease.photo),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomCachedImage(image: disease.photo[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFullImage(int index, List<String> photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: photo,
          initialIndex: index,
        ),
      ),
    );
  }
}
