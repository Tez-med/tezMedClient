import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool showError;
  const CustomCard({
    super.key,
    required this.child,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: showError ? Colors.red : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }
}
