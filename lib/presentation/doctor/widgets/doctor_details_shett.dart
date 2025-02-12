import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/presentation/doctor/bloc/doctor_details/doctor_details_bloc.dart';
import 'package:tez_med_client/presentation/doctor/widgets/custom_calendar_widget.dart';

class DoctorDetailSheet extends StatefulWidget {
  final String id;
  final bool online;
  final ScrollController controller;

  const DoctorDetailSheet(
      {super.key, required this.id, required this.controller, required this.online});

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
          child: ElevatedButton(
            onPressed: selectedDateId.isEmpty
                ? null
                : () {
                    context.router.push(ClientData(id: selectedDateId,online: widget.online));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              elevation: 0,
            ),
            child: Text(
              "Ro'yxatdan o'tish",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
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
              return Center(child: CupertinoActivityIndicator());
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
                        "Doctor",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.greyTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFF5F7FB),
                                    ),
                                    child: const Icon(
                                      Icons.work_outline,
                                      size: 25,
                                      color: Color(0xFF4C75D9),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ish tajribasi",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.greyTextColor,
                                        ),
                                      ),
                                      Text(
                                        "${data.experience} yil",
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
                            ),
                            Container(
                              width: 1.5,
                              height: 40,
                              color: AppColor.buttonBackColor,
                            ),
                            SizedBox(width: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF5F7FB),
                                  ),
                                  child: const Icon(
                                    Icons.star_border_rounded,
                                    size: 25,
                                    color: Color(0xFFFFB800),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reyting",
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
                            "Sanani va vaqtni tanlang",
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
