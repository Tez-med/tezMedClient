import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tez_med_client/core/extension/space_extensions.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/enviroment_dialog.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/profile/widgets/delete_account.dart';
import 'package:tez_med_client/presentation/profile/widgets/profile_menu_widget.dart';
import 'package:tez_med_client/presentation/profile/widgets/wallet.dart';
import '../widgets/profile_header.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _actionButtonPressCount = 0;
  DateTime? _lastPressTime;

  // Action button press handler
  void _handleActionButtonPress() {
    final now = DateTime.now();
    final isDoubleClick = _lastPressTime != null &&
        now.difference(_lastPressTime!) <= const Duration(milliseconds: 300);

    _actionButtonPressCount = isDoubleClick ? _actionButtonPressCount + 1 : 1;
    _lastPressTime = now;

    if (_actionButtonPressCount == 4) {
      _showEnvironmentDialog();
      _actionButtonPressCount = 0;
    }
  }

  // Show environment dialog
  void _showEnvironmentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EnvironmentDialog(),
    );
  }

  // Profile data refresh handler
  Future<void> _onRefresh() async {
    context.read<ProfileBloc>().add(GetProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: context.read<ProfileBloc>()..add(GetProfileData()),
          builder: (context, state) {
            return state is ProfileError
                ? ErrorWidget(state: state)
                : state is ProfileLoaded || state is ProfileLoading
                    ? _buildProfileScreen(state)
                    : const SizedBox();
          },
        ),
      ),
    );
  }

  // AppBar widget
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).profile,
      ),
      actions: [
        GestureDetector(
          onTap: _handleActionButtonPress,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Profile screen content
  Widget _buildProfileScreen(ProfileState state) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(clientModel: state.clientModel),
            WalletAndRating(clientModel: state.clientModel),
            16.h,
            _buildDiseaseCardSection(context),
            16.h,
            const ProfileMenuWidget(),
            const DeleteAccountSection(),
            24.h,
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  // Kasallik varaqalari uchun maxsus sektsiya
  Widget _buildDiseaseCardSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor,
            AppColor.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.router.push(DiseasesRoute()),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_information_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).diseaseCards,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.of(context).disease_info,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Version info widget
  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox();
        }
        final packageInfo = snapshot.data!;
        return Center(
          child: Text(
            'Version ${packageInfo.version} (${packageInfo.buildNumber})',
            style: AppTextstyle.nunitoMedium.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final ProfileState state;

  const ErrorWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.error.code == 400) {
      return NoInternetConnectionWidget(
        onRetry: () => context.read<ProfileBloc>().add(GetProfileData()),
      );
    } else if (state.error.code == 500) {
      return ServerConnection(
        onRetry: () => context.read<ProfileBloc>().add(GetProfileData()),
      );
    }
    return Center(
      child: Text(
        'Unexpected Error',
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }
}
