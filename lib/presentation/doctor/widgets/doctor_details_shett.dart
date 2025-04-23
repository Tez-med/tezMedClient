import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/doctor/bloc/doctor_details/doctor_details_bloc.dart';
import 'package:tez_med_client/presentation/doctor/widgets/custom_calendar_widget.dart';
import 'package:tez_med_client/presentation/doctor/widgets/loading.dart';

class DoctorDetailSheet extends StatefulWidget {
  final String id;
  final bool online;
  final String type;
  final String price;

  const DoctorDetailSheet({
    super.key,
    required this.id,
    required this.online,
    required this.type,
    required this.price,
  });

  @override
  State<DoctorDetailSheet> createState() => _DoctorDetailSheetState();
}

class _DoctorDetailSheetState extends State<DoctorDetailSheet> {
  String selectedDateId = "";

  @override
  void initState() {
    context.read<DoctorDetailsBloc>().add(GetIdDoctor(widget.id));
    super.initState();
  }

  void _onDateSelected(String dateId) {
    setState(() {
      selectedDateId = dateId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDetailsBloc, DoctorDetailsState>(
      builder: (context, state) {
        if (state is DoctorDetailsError) {
          if (state.error.code == 400) {
            return NoInternetConnectionWidget(
              onRetry: () =>
                  context.read<DoctorDetailsBloc>().add(GetIdDoctor(widget.id)),
            );
          } else if (state.error.code == 500) {
            return ServerConnection(
              onRetry: () =>
                  context.read<DoctorDetailsBloc>().add(GetIdDoctor(widget.id)),
            );
          }
          return const Center();
        }
        if (state is DoctorDetailsLoading) {
          return DoctorDetailsSkeleton();
        }
        if (state is DoctorDetailsLoaded) {
          final data = state.data;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCachedImage(
                    image: data.photo,
                    isProfile: true,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Text(
                        data.fullName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          height: 26.63 / 22,
                          letterSpacing: 0.5,
                          color: AppColor.textColor,
                        ),
                      ),
                      Text(
                        widget.type,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColor.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                          icon: Assets.icons.expirense.svg(),
                          title: S.of(context).work_experience,
                          value: "${data.experience} ${S.of(context).year}",
                        ),
                        Container(
                          width: 1.5,
                          height: 40,
                          color: AppColor.buttonBackColor,
                        ),
                        _buildInfoItem(
                          icon: Assets.icons.doctorStar.svg(),
                          title: S.of(context).rating,
                          value: data.rating.toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).choose_date_time,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 16.94 / 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomCalendarWidget(
                      online: widget.online,
                      data: data.schedules,
                      onDateSelected: _onDateSelected,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: selectedDateId.isEmpty
                            ? null
                            : () {
                                context.router.push(ClientData(
                                    id: selectedDateId,
                                    online: widget.online,
                                    type: widget.type,
                                    price: widget.price));
                              },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          backgroundColor: AppColor.primaryColor,
                          elevation: 0,
                        ),
                        child: Text(
                          S.of(context).sign_up,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center();
      },
    );
  }

  Widget _buildInfoItem(
      {required Widget icon, required String title, required String value}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F7FB),
            ),
            child: icon,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.greyTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C1E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
