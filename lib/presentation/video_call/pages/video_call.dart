import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/video_call/widgets/loading_indicator.dart';

import '../../../core/utils/app_color.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/round_button.dart';

@RoutePage()
class VideoCallScreen extends StatefulWidget {
  final String url;

  const VideoCallScreen({super.key, required this.url});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isFullScreen = false;
  InAppWebViewController? webViewController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool exitApp =
            await DialogHelper.showExitConfirmationDialog(context) ?? false;

        if (exitApp) {
          if (context.mounted) {
            context.router.maybePop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryDark,
        appBar: isFullScreen
            ? null
            : AppBar(
                centerTitle: true,
                title: Text(
                  S.of(context).video_chat,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColor.secondary,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () async {
                    bool exitApp =
                        await DialogHelper.showExitConfirmationDialog(
                                context) ??
                            false;

                    if (exitApp) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () => DialogHelper.showInfoDialog(context),
                  ),
                ],
              ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: InAppWebViewSettings(
                      mediaPlaybackRequiresUserGesture: false,
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) async {
                      setState(() {
                        isLoading = true;
                      });
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    onPermissionRequest: (controller, permissionRequest) async {
                      return PermissionResponse(
                        resources: permissionRequest.resources,
                        action: PermissionResponseAction.GRANT,
                      );
                    },
                  ),
                  if (isLoading) const LoadingIndicator(),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: AppColor.secondary,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    animationController: _animationController,
                    scaleAnimation: _scaleAnimation,
                    onPressed: () => _endCall(context),
                    label: S.of(context).endText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _endCall(BuildContext context) async {
    bool shouldExit =
        await DialogHelper.showExitConfirmationDialog(context) ?? false;
    if (shouldExit) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
