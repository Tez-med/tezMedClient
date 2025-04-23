import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/generated/l10n.dart';

class DescriptionSection extends StatefulWidget {
  final String description;

  const DescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Method to calculate if text exceeds maxLines
  bool _hasTextOverflow(
      String text, TextStyle style, double maxWidth, int maxLines) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.description.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klinika haqida ma\'lumot mavjud emas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // Get screen width for text painter
    final screenWidth =
        MediaQuery.of(context).size.width - 32; // Padding hisobga olingan

    // Text style for description
    final textStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[800],
      height: 1.4,
    );

    // Check if text exceeds 3 lines
    final needsToggle =
        _hasTextOverflow(widget.description, textStyle, screenWidth, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).description,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        needsToggle
            ? _buildAnimatedDescription(textStyle)
            : _buildSimpleDescription(),
        if (needsToggle)
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    _isExpanded ? "Yashirish" : "Barchasini ko'rish",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.primaryColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedDescription(TextStyle textStyle) {
    return LayoutBuilder(builder: (context, constraints) {
      // Umumiy TextPainter yaratish
      final textPainter = TextPainter(
        text: TextSpan(text: widget.description, style: textStyle),
        maxLines: 3,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: constraints.maxWidth);

      final visibleTextLength = textPainter
          .getPositionForOffset(
              Offset(constraints.maxWidth, textPainter.height))
          .offset;

      // Agar matn 3 qatorga sig'sa, to'liq matni ko'rsatamiz
      if (!textPainter.didExceedMaxLines) {
        return Text(
          widget.description,
          style: textStyle,
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Birinchi 3 qator
          Text(
            _isExpanded
                ? widget.description
                : widget.description.substring(0, visibleTextLength),
            style: textStyle,
            maxLines: _isExpanded ? null : 3,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ],
      );
    });
  }

  Widget _buildSimpleDescription() {
    return Text(
      widget.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[800],
        height: 1.4,
      ),
    );
  }
}
