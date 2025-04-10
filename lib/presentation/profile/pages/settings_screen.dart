import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/profile/widgets/language_sector.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.maybePop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          S.of(context).settings,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LanguageSelector(),
        ],
      ),
    );
  }
}
