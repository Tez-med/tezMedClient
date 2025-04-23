import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class SelectServiceScreen extends StatefulWidget {
  final List<Service> service;
  final Map<int, int> selectedItems;
  final Function(int, int) onUpdate;

  const SelectServiceScreen({
    super.key,
    required this.service,
    required this.selectedItems,
    required this.onUpdate,
  });

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen>
    with TickerProviderStateMixin {
  final _formatter = NumberFormat('#,###');

  // Pre-filter active services to improve performance
  late final List<Service> _activeServices =
      widget.service.where((service) => service.isActive).toList();

  // Map to store animation controllers for each item
  final Map<int, AnimationController> _animationControllers = {};

  @override
  void dispose() {
    // Dispose all animation controllers
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Get or create animation controller for an index
  AnimationController _getAnimationController(int index) {
    if (!_animationControllers.containsKey(index)) {
      _animationControllers[index] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
    }
    return _animationControllers[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: _activeServices.length,
          separatorBuilder: (_, __) => Divider(color: AppColor.buttonBackColor),
          itemBuilder: _buildServiceItem,
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, int index) {
    final service = _activeServices[index];
    final bool isSelected = widget.selectedItems.containsKey(index);
    final AnimationController controller = _getAnimationController(index);

    // Ensure controller is at correct value without animation when building
    if (isSelected && controller.status != AnimationStatus.completed) {
      controller.value = 1.0;
    } else if (!isSelected && controller.status != AnimationStatus.dismissed) {
      controller.value = 0.0;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      title: Text(
        context.toLocalized(
            uz: service.nameUz, ru: service.nameRu, en: service.nameEn),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 17,
          height: 18 / 13,
          letterSpacing: 0.01,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${_formatter.format(service.price)} ${S.of(context).sum}",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 18 / 14,
          letterSpacing: 0.01,
          color: AppColor.primaryColor,
        ),
      ),
      trailing: SizedBox(
        width: 110,
        height: 40,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                // Add button
                Positioned.fill(
                  child: Opacity(
                    opacity: 1 - controller.value,
                    child: Transform.scale(
                      scale: 1.0 - 0.2 * controller.value,
                      child: IgnorePointer(
                        ignoring: controller.value > 0.5,
                        child: _buildAddButton(index),
                      ),
                    ),
                  ),
                ),

                // Quantity control
                Positioned.fill(
                  child: Opacity(
                    opacity: controller.value,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * controller.value,
                      child: IgnorePointer(
                        ignoring: controller.value < 0.5,
                        child: _buildQuantityControl(index),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuantityControl(int index) {
    final quantity = widget.selectedItems[index] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.buttonBackColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            Icons.remove,
            () => _updateQuantity(index, quantity - 1),
            enabled: quantity > 0,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$quantity',
              key: ValueKey<int>(quantity),
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          _buildControlButton(
            Icons.add,
            () => _updateQuantity(index, quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed,
      {bool enabled = true}) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: enabled ? onPressed : null,
          child: Center(
            child: Icon(
              icon,
              color: enabled
                  ? AppColor.greyColor500
                  : AppColor.greyColor500.withValues(alpha: 0.5),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    final controller = _getAnimationController(index);

    if (newQuantity <= 0) {
      // Animate from quantity control to add button
      setState(() {
        widget.onUpdate(index, 0);
      });

      controller.reverse();
    } else if (!widget.selectedItems.containsKey(index)) {
      // Animate from add button to quantity control
      setState(() {
        widget.onUpdate(index, newQuantity);
      });

      controller.forward();
    } else {
      // Just update the quantity
      setState(() {
        widget.onUpdate(index, newQuantity);
      });
    }
  }

  Widget _buildAddButton(int index) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: OutlinedButton(
        onPressed: () => _updateQuantity(index, 1),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColor.buttonBackColor,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: Text(
          S.of(context).add,
          style: AppTextstyle.nunitoMedium.copyWith(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
