import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/presentation/category/bloc/species_get_bloc/species_get_by_id_bloc.dart';
import 'package:tez_med_client/presentation/doctor/screen/category_doctor.dart';
import 'package:tez_med_client/presentation/home/bloc/category_bloc/category_bloc.dart';
import '../../../generated/l10n.dart';

@RoutePage()
class CategoryScreenDoctor extends StatefulWidget {
  final String title;
  final String id;
  const CategoryScreenDoctor(
      {super.key, required this.title, required this.id});

  @override
  State<CategoryScreenDoctor> createState() => _CategoryScreenDoctorState();
}

class _CategoryScreenDoctorState extends State<CategoryScreenDoctor> {
  @override
  void initState() {
    context.read<SpeciesGetByIdBloc>().add(GetByIdSpecies(widget.id));
    context.read<CategoryBloc>().add(GetCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          widget.title,
        ),
      ),
      body: BlocBuilder<SpeciesGetByIdBloc, SpeciesGetByIdState>(
        builder: (context, state) {
          if (state is SpeciesGetByIdLoading) {
            return Skeletonizer(child: CategoryDoctor(type: widget.title));
          } else if (state is SpeciesGetByIdError) {
            return _handleCategoryError(state);
          } else if (state is SpeciesGetByIdLoaded) {
            if (state.speciesModel.type == 'doctor') {
              return CategoryDoctor(type: widget.title);
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
