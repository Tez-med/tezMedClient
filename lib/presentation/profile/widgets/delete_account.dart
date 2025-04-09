import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/generated/l10n.dart';

class DeleteAccountSection extends StatelessWidget {
  const DeleteAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showDeleteAccountConfirmation(context),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.delete,
                        color: Color(0xFFFF3B30),
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        S.of(context).deleteAccount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        color: Color(0xFFC7C7CC),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).deleteAccountTitle),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(S.of(context).deleteAccountConfirmation),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              _confirmFinalDeletion(context);
            },
            child: Text(S.of(context).Continue),
          ),
        ],
      ),
    );
  }

  void _confirmFinalDeletion(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).confirm),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(S.of(context).deleteAccountFinalWarning),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              _startAccountDeletion(context);
            },
            child: Text(S.of(context).deleteAccount),
          ),
        ],
      ),
    );
  }

  void _startAccountDeletion(BuildContext context) {
    // Joriy state'ni saqlab olamiz

    // Yuklash dialogini ko'rsatamiz
    final loadingDialogKey = GlobalKey<State>();
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CupertinoAlertDialog(
        key: loadingDialogKey,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(height: 16),
              Text(S.of(context).deletingAccount),
            ],
          ),
        ),
      ),
    );

    // O'chirish jarayonini kuzatib borish va xatoliklarni qayta ishlash uchun alohida bloc qo'shamiz
    final deleteAccountBloc = ProfileBloc(
      context.read<ProfileBloc>().getClientUsecase,
    );

    // Tinglovchini qo'shamiz
    deleteAccountBloc.stream.listen((state) {
      if (state is ProfileDeletionSuccess) {
        // Yuklash dialogini yopamiz
        if (loadingDialogKey.currentContext != null) {
          Navigator.of(loadingDialogKey.currentContext!, rootNavigator: true)
              .pop();
        }

        // Muvaffaqiyat xabarini ko'rsatamiz
        _showSuccessMessage(context);
      } else if (state is ProfileDeletionError) {
        // Yuklash dialogini yopamiz
        if (loadingDialogKey.currentContext != null) {
          Navigator.of(loadingDialogKey.currentContext!, rootNavigator: true)
              .pop();
        }

        // Xato xabarini ko'rsatamiz
        ErrorHandler.showError(context, state.error.code);
      }
    });

    // O'chirish jarayonini boshlaymiz
    deleteAccountBloc.add(DeleteProfile());
  }

  void _showSuccessMessage(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).successful),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(S.of(context).accountDeletedSuccessfully),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              LocalStorageService().clearAll();
              context.router.replaceAll([PhoneInputRoute()]);
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }
}
