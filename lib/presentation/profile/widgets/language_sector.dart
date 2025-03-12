import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _showLanguageOverlay(context, state),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.language, color: AppColor.primaryColor),
                title: Text(
                  S.of(context).language,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.locale.languageCode.toUpperCase(),
                    style: AppTextstyle.nunitoBold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageOverlay(BuildContext context, LanguageState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LanguageOverlay(
          currentLocale: state.locale,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

class _LanguageOverlay extends StatelessWidget {
  final Locale currentLocale;
  final VoidCallback onDismiss;

  const _LanguageOverlay({
    required this.currentLocale,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.buttonBackColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).language,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 24),
            _buildLanguageOption(context, 'uz', S.of(context).uzbek),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'ru', S.of(context).russian),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'en', S.of(context).english),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String langCode, String langName) {
    bool isSelected = currentLocale.languageCode == langCode;
    return InkWell(
      onTap: () {
        BlocProvider.of<LanguageBloc>(context)
            .add(ChangeLanguage(Locale(langCode)));
        onDismiss();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColor.primaryColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              langName,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
