import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/get_by_id_request/get_by_id_request_bloc.dart';
import 'package:tez_med_client/presentation/order_details/bloc/comment_bloc.dart';
import 'package:tez_med_client/presentation/order_details/widgets/affairs_card_widget.dart';
import 'package:tez_med_client/presentation/order_details/widgets/nurse_details.dart';
import 'package:tez_med_client/presentation/order_details/widgets/photos_card_widget.dart';
import 'package:tez_med_client/presentation/order_details/widgets/raiting_bottom_shett.dart';
import 'package:tez_med_client/presentation/order_details/widgets/status_card_widget.dart';
import '../widgets/order_details_card.dart';

@RoutePage()
class OrderDetailsScreen extends StatefulWidget {
  final String id;
  final String number;
  final String nursePhoto;

  const OrderDetailsScreen(
      {super.key,
      required this.id,
      required this.number,
      required this.nursePhoto});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context
            .read<GetByIdRequestBloc>()
            .add(GetByIdRequestNotLoading(widget.id));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  GetByIdRequestModel get _dummyRequest => GetByIdRequestModel(
        id: '0',
        comment: "",
        clientId: '0',
        number: 000,
        accessCode: '',
        promocodeAmount: 0,
        price: 100000,
        longitude: '0.0',
        latitude: '0.0',
        nurseName: "",
        startTime: DateTime.now().toString(),
        address: 'Loading address...',
        house: 'Loading...',
        floor: 'Loading...',
        apartment: 'Loading...',
        entrance: 'Loading...',
        client: Client(
            id: widget.id,
            fullName: "",
            longitude: "",
            latitude: "",
            phoneNumber: "",
            gender: "",
            birthday: "",
            photo: "",
            createdAt: "",
            updatedAt: ""),
        nurseId: "",
        updatedAt: "",
        photos: [],
        requestAffairs: [
          RequestAffairGet(
            startDate: "",
            hour: "2025/12/12 12:23:00",
            typeModel:
                TypeModel(id: "", nameUz: "", nameEn: "", nameRu: "", price: 0),
            affairId: "",
            count: 10,
            createdAt: DateTime.now().toString(),
            nameUz: 'Loading service...',
            nameEn: "",
            nameRu: "",
            price: 50000,
          ),
        ],
        status: 'pending',
        createdAt: DateTime.now().toString(),
      );

  void _showRatingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RatingBottomSheet(
          requestId: widget.id,
          commentBloc: context.read<CommentBloc>(),
        ),
      ),
    );
  }

  Widget _buildContent(GetByIdRequestModel data, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: StatusCard(
                requestss: data,
                isFinished: data.status == "finished",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: OrderDetailsCard(requestss: data),
            ),
            const SizedBox(height: 20),
            if (!isLoading && data.photos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: PhotosCard(requestss: data),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AffairsCard(requestss: data),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetByIdRequestBloc, GetByIdRequestState>(
      bloc: context.read<GetByIdRequestBloc>()..add(GetByIdRequest(widget.id)),
      builder: (context, state) {
        final bool showRatingButton = state is GetByIdRequestLoaded &&
            state.requestss.status == "finished";
        return Scaffold(
          backgroundColor: AppColor.buttonBackColor,
          appBar: AppBar(
            centerTitle: true,
            elevation: 1,
            backgroundColor: Colors.white,
            shadowColor: AppColor.buttonBackColor,
            surfaceTintColor: Colors.white,
            title: Text(
              "${S.of(context).order} №${widget.number}",
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
              ),
            ),
            actions: [
              if (showRatingButton)
                IconButton(
                  onPressed: _showRatingBottomSheet,
                  icon: const Icon(Icons.star_border_rounded),
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is GetByIdRequestLoading) {
                return _buildContent(_dummyRequest, true);
              } else if (state is GetByIdRequestLoaded) {
                final activeRequest = state.requestss;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: StatusCard(
                          requestss: activeRequest,
                          isFinished: activeRequest.status == "finished",
                        ),
                      ),
                      activeRequest.nurseName.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: NurseDetails(
                                requestss: activeRequest,
                                nursePhoto: widget.nursePhoto,
                              ),
                            )
                          : const SizedBox(),
                      activeRequest.nurseName.isNotEmpty
                          ? const SizedBox(height: 10)
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: OrderDetailsCard(requestss: activeRequest),
                      ),
                      const SizedBox(height: 10),
                      activeRequest.photos.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: PhotosCard(requestss: activeRequest),
                            ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: AffairsCard(requestss: activeRequest),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is GetByIdRequestError) {
                if (state.error.code == 400) {
                  return NoInternetConnectionWidget(
                    onRetry: () => context
                        .read<GetByIdRequestBloc>()
                        .add(GetByIdRequest(widget.id)),
                  );
                } else if (state.error.code == 500) {
                  return ServerConnection(
                    onRetry: () => context
                        .read<GetByIdRequestBloc>()
                        .add(GetByIdRequest(widget.id)),
                  );
                }
              }
              return const SizedBox.expand();
            },
          ),
        );
      },
    );
  }
}
