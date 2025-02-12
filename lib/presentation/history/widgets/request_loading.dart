import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/presentation/history/widgets/request_card.dart';

class RequestLoadingWidget extends StatelessWidget {
  const RequestLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: 3, // Show 3 skeleton items while loading
        itemBuilder: (context, index) {
          return Skeletonizer(
            enabled: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RequestCard(
                data: Requestss(
                  comment: "",
                  id: "loading_id",
                  clientId: "loading_client",
                  number: 12345,
                  nurseRating: 0,
                  price: 100000,
                  nurseName: "",
                  nursePhoto: "",
                  longitude: "0.0",
                  latitude: "0.0",
                  startTime: "2004/01/12 12:55",
                  address: "Loading address...",
                  house: "1",
                  floor: "1",
                  apartment: "1",
                  entrance: "1",
                  photos: ["loading_photo"],
                  requestAffairs: [
                    RequestAffairGet(
                        startDate: "2025-01-11 12:57",
                        affairId: "",
                        hour: "2025-01-11 12:57",
                        count: 0,
                        createdAt: "2025-01-11 12:57",
                        nameUz: "",
                        nameEn: "",
                        nameRu: "",
                        typeModel: TypeModel(
                            id: "",
                            nameUz: "",
                            nameEn: "",
                            nameRu: "",
                            price: 0),
                        price: 0),
                  ],
                  status: "loading",
                  createdAt: DateTime.now().toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
