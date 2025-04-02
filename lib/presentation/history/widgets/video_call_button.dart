import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/schedule_id/schedule_get_id_bloc.dart';
import '../../../core/routes/app_routes.gr.dart';

class VideoCallButton extends StatefulWidget {
  final String scheduleId;

  const VideoCallButton({
    super.key,
    required this.scheduleId,
  });

  @override
  State<VideoCallButton> createState() => _VideoCallButtonState();
}

class _VideoCallButtonState extends State<VideoCallButton> {
  bool _isLoading = false;
  // Bloc stateini tinglovchi StreamSubscription
  StreamSubscription? _blocSubscription;

  @override
  void dispose() {
    // Widget yo'q qilinganda tinglovchini bekor qilish
    _blocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading
            ? null
            : () async {
                final hasPermissions = await _requestPermissions();
                if (hasPermissions) {
                  _initiateVideoCall(context);
                }
              },
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x99FFFFFF),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primaryColor,
                      ),
                    ),
                  )
                : Icon(
                    CupertinoIcons.videocam_fill,
                    color: AppColor.primaryColor,
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }

  void _initiateVideoCall(BuildContext context) {
    setState(() => _isLoading = true);

    // Avvalgi tinglovchini bekor qilish (agar mavjud bo'lsa)
    _blocSubscription?.cancel();

    // Bloc eventni yuborish
    context.read<ScheduleGetIdBloc>().add(GetScheduleId(widget.scheduleId));

    // Stream subscription orqali bloc stateini tinglash
    _blocSubscription =
        context.read<ScheduleGetIdBloc>().stream.listen((state) {
      if (state is ScheduleGetIdSuccess) {
        setState(() => _isLoading = false);
        context.router.push(VideoCallRoute(url: state.data.meet.url));

        // Muvaffaqiyat bo'lgandan so'ng subscriptionni bekor qilish
        _blocSubscription?.cancel();
        _blocSubscription = null;
      } else if (state is ScheduleGetIdError) {
        setState(() => _isLoading = false);
        ErrorHandler.showError(context, state.error.code);

        // Xatolik bo'lganda ham subscriptionni bekor qilish
        _blocSubscription?.cancel();
        _blocSubscription = null;
      }
    });

    // Vaqt cheklovini o'rnatish (timeout)
    Future.delayed(const Duration(seconds: 30), () {
      if (_isLoading) {
        setState(() => _isLoading = false);
        ErrorHandler.showError(context, 500);
        _blocSubscription?.cancel();
        _blocSubscription = null;
      }
    });
  }

  Future<bool> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      return true;
    } else if (cameraStatus.isPermanentlyDenied ||
        microphoneStatus.isPermanentlyDenied) {
      _showSettingsDialog();
      return false;
    } else {
      return false;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: const EdgeInsets.all(16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 8),
        title: Column(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle_fill,
              color: AppColor.primaryColor,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).permission_required,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          S.of(context).permission_description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => context.router.maybePop(),
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  context.router.maybePop();
                  await openAppSettings();
                },
                child: Text(
                  S.of(context).settings,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
