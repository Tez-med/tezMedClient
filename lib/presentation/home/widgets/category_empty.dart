import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

class CategoryEmpty extends StatelessWidget {
  const CategoryEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.category_outlined,
                  size: 100,
                  color: AppColor.primaryColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Hozircha ushbu kategoriyada\nma\'lumotlar mavjud emas',
              textAlign: TextAlign.center,
              style: AppTextstyle.nunitoRegular.copyWith(
                fontSize: 20,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Boshqa kategoriyalarni tekshirib ko\'ring',
              textAlign: TextAlign.center,
              style: AppTextstyle.nunitoRegular.copyWith(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
