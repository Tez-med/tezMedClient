import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ClientDataSkeleton extends StatelessWidget {
  final bool online;
  const ClientDataSkeleton({super.key, required this.online});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      body: Stack(
        children: [
          Skeletonizer(
            enabled: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildPersonalInfoCard(context),
                    _buildImagePickerCard(),
                    _buildPaymentCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      elevation: 0,
                    ),
                    onPressed: null,
                    child: Text(
                      S.of(context).my_self,
                      style: AppTextstyle.nunitoBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonBackColor,
                      elevation: 0,
                    ),
                    onPressed: null,
                    child: Text(
                      S.of(context).for_another,
                      style: AppTextstyle.nunitoBold.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Full Name Field
            Text(
              S.of(context).fio,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                hintText: S.of(context).fio,
                filled: true,
                fillColor: AppColor.buttonBackColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Phone Number Field
            Text(
              S.of(context).phone_number,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                hintText: "+998 90 123 45 67",
                filled: true,
                fillColor: AppColor.buttonBackColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Birth Date Field
            Text(
              S.of(context).birthday,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                hintText: "YYYY-MM-DD",
                filled: true,
                fillColor: AppColor.buttonBackColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gender Selection
            Text(
              S.of(context).gender,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.buttonBackColor,
                        border: Border.all(color: AppColor.buttonBackColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.buttonBackColor,
                        border: Border.all(color: AppColor.buttonBackColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rasm",
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.buttonBackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.add_photo_alternate_outlined, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.payment_type,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 10),
            Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
