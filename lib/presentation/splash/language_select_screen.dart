import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';

@RoutePage()
class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 200, // maksimal kenglik
                  maxHeight: 200, // maksimal balandlik
                ),
                child: Assets.images.logoPng.image(
                  fit: BoxFit.contain,
                  filterQuality:
                      FilterQuality.medium, // rasm sifatini optimallash
                ),
              ),
              const Spacer(),
              const _LanguageButtons(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Language buttonlarini alohida widgetga ajratish
class _LanguageButtons extends StatelessWidget {
  const _LanguageButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageButton(
          language: "O'zbekcha",
          icon: Assets.icons.uz,
          locale: Locale('uz'),
        ),
        SizedBox(height: 10),
        _LanguageButton(
          language: 'Русский',
          icon: Assets.icons.ru,
          locale: Locale('ru'),
        ),
        SizedBox(height: 10),
        _LanguageButton(
          language: 'English',
          icon: Assets.icons.en,
          locale: Locale('en'),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String language;
  final AssetGenImage icon;
  final Locale locale;

  const _LanguageButton({
    required this.language,
    required this.icon,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _onLanguageSelect(context),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.buttonBackColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              icon.image(
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
              const SizedBox(width: 10),
              Text(
                language,
                style: AppTextstyle.nunitoBold.copyWith(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLanguageSelect(BuildContext context) {
    context.read<LanguageBloc>().add(ChangeLanguage(locale));
    context.router.replaceAll([OnboardingRoute()]);
  }
}
