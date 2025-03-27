import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/presentation/category/bloc/species_get_bloc/species_get_by_id_bloc.dart';
import 'package:tez_med_client/presentation/category/widgets/category_nurse_loading.dart';
import 'package:tez_med_client/presentation/category/widgets/category_nurse_main.dart';
import 'package:tez_med_client/presentation/home/bloc/category_bloc/category_bloc.dart';
import '../../../generated/l10n.dart';

@RoutePage()
class CategoryScreenNurse extends StatefulWidget {
  final String title;
  final String id;
  final String district;
  final RequestModel requestModel;

  const CategoryScreenNurse(
      {super.key,
      required this.title,
      required this.id,
      required this.district,
      required this.requestModel});

  @override
  State<CategoryScreenNurse> createState() => _CategoryScreenNurseState();
}

class _CategoryScreenNurseState extends State<CategoryScreenNurse> {
  @override
  void initState() {
    context
        .read<SpeciesGetByIdBloc>()
        .add(GetByIdSpecies(widget.id, widget.district));
    context.read<CategoryBloc>().add(GetCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: AppColor.buttonBackColor,
        centerTitle: true,
        title: Text(
          widget.title,
          style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<SpeciesGetByIdBloc, SpeciesGetByIdState>(
        builder: (context, state) {
          if (state is SpeciesGetByIdLoading) {
            return CategoryNurseLoading(widget: widget);
          } else if (state is SpeciesGetByIdError) {
            return _handleCategoryError(state);
          } else if (state is SpeciesGetByIdLoaded) {
            if (state.speciesModel.type == 'nurse') {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return CategoryNurseLoading(widget: widget);
                  } else if (state is CategoryLoaded) {
                    return CategoryNurseMain(
                      category: state.category,
                      requestModel: widget.requestModel.copyWith(
                        nurseTypeId: state.category.first.departments.first
                            .affairs.first.service.first.type.id,
                      ),
                    );
                  }
                  return SizedBox();
                },
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _handleCategoryError(SpeciesGetByIdError state) {
    if (state.error.code == 400) {
      return NoInternetConnectionWidget(
        onRetry: () {
          context.read<SpeciesGetByIdBloc>().add(GetByIdSpecies(widget.id));
        },
      );
    } else if (state.error.code == 500) {
      return ServerConnection(
        onRetry: () {
          context.read<SpeciesGetByIdBloc>().add(GetByIdSpecies(widget.id));
        },
      );
    }
    return Center(
      child: Text(
        S.of(context).unexpected_error,
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }
}
