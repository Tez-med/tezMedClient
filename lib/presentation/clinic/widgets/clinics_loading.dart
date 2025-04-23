
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/presentation/clinic/widgets/clinic_loaded_widget.dart';

class ClinicsLoading extends StatelessWidget {
  const ClinicsLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ClinicsLoadedView(
        clinicsModel: ClinicsModel(
          clinics: List.generate(
            5,
            (index) => Clinic(
              id: "clinic-${index + 1}",
              districtId: "district-${index + 1}",
              regionId: "region-${index + 1}",
              countryId: "country-1",
              nameUz: "Tibbiyot markazi ${index + 1}",
              nameRu: "Медицинский центр ${index + 1}",
              nameEn: "Medical Center ${index + 1}",
              longitude: "69.${index}42850",
              latitude: "41.${index}11100",
              description:
                  "Bu yerda klinika haqida batafsil ma'lumot bo'ladi",
              phoneNumber: ["+998 90 123 45 ${index + 10}"],
              address:
                  "Toshkent shahri, Chilonzor ${index + 1}-mavze, ${10 + index}-uy",
              photo: [
                "https://example.com/clinic-image-${index + 1}.jpg"
              ],
              instagramLink: "https://instagram.com/clinic${index + 1}",
              tgLink: "https://t.me/clinic${index + 1}",
              rating: 4,
              hours: [],
              amenities: [],
            ),
          ),
        ),
      ),
    );
  }
}