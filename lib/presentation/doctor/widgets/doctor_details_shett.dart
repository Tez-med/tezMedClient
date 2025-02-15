import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
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
  final ScrollController controller;

  const DoctorDetailSheet(
      {super.key,
      required this.id,
      required this.controller,
      required this.online,
      required this.type,
      required this.price});

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
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
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
                backgroundColor: AppColor.primaryColor,
                elevation: 0,
              ),
              child: Text(
                S.of(context).sign_up,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xffF9F9F9),
        body: BlocBuilder<DoctorDetailsBloc, DoctorDetailsState>(
          builder: (context, state) {
            if (state is DoctorDetailsError) {
              if (state.error.code == 400) {
                return NoInternetConnectionWidget(
                  onRetry: () => context
                      .read<DoctorDetailsBloc>()
                      .add(GetIdDoctor(widget.id)),
                );
              } else if (state.error.code == 500) {
                return ServerConnection(
                  onRetry: () => context
                      .read<DoctorDetailsBloc>()
                      .add(GetIdDoctor(widget.id)),
                );
              }
              return Center(child: Text("Xatolik yuz berdi"));
            }
            if (state is DoctorDetailsLoading) {
              return DoctorDetailsSkeleton();
            }
            if (state is DoctorDetailsLoaded) {
              final data = state.data;
              return SingleChildScrollView(
                controller: widget.controller,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xffB6B6B6),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomCachedImage(
                        image: data.photo,
                        isProfile: true,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        data.fullName,
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
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.greyTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withValues(alpha: 0.1),
                          //     spreadRadius: 2,
                          //     blurRadius: 8,
                          //     offset: const Offset(0, 2),
                          //   ),
                          // ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF5F7FB),
                                  ),
                                  child: Assets.icons.expirense.svg(),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).work_experience,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.greyTextColor,
                                      ),
                                    ),
                                    Text(
                                      "${data.experience} ${S.of(context).year}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1C1E),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 1.5,
                              height: 40,
                              color: AppColor.buttonBackColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF5F7FB),
                                  ),
                                  child: Assets.icons.doctorStar.svg(),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).rating,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.greyTextColor,
                                      ),
                                    ),
                                    Text(
                                      data.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1C1E),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            S.of(context).choose_date_time,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 16.94 / 14,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomCalendarWidget(
                          data: data.schedules,
                          onDateSelected: _onDateSelected,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text("Ma'lumotlar topilmadi"));
          },
        ),
      ),
    );
  }
}
