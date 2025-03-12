
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';

class DialogContent extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final List<Widget>? buttons;
  final Widget? singleButton;
  final Widget? extraContent;

  const DialogContent({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttons,
    this.singleButton,
    this.extraContent,
  }) : assert((buttons != null && singleButton == null) || 
               (buttons == null && singleButton != null),
               'Either provide buttons or singleButton, not both');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColor.secondary,
            AppColor.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            if (extraContent != null) ...[
              const SizedBox(height: 16),
              extraContent!,
            ],
            const SizedBox(height: 24),
            if (buttons != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons!,
              )
            else if (singleButton != null)
              singleButton!,
          ],
        ),
      ),
    );
  }
}
