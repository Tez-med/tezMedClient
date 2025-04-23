import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';

class ClinicFilterDialog extends StatefulWidget {
  final double initialDistance;
  final Function(double) onApplyFilter;

  const ClinicFilterDialog({
    super.key,
    this.initialDistance = 5.0,
    required this.onApplyFilter,
  });

  @override
  State<ClinicFilterDialog> createState() => _ClinicFilterDialogState();
}

class _ClinicFilterDialogState extends State<ClinicFilterDialog> {
  late double _maxDistance;
  
  @override
  void initState() {
    super.initState();
    _maxDistance = widget.initialDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Masofa bo\'yicha filtrlash',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Reset button
                IconButton(
                  onPressed: _resetFilter,
                  icon: const Icon(Icons.refresh, size: 20),
                  tooltip: 'Asl holatga qaytarish',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Max distance slider
            const Text(
              'Maksimal masofa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _maxDistance,
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    activeColor: AppColor.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _maxDistance = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${_maxDistance.toInt()} km',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Izoh
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sizning joylashuvingizdan ko\'rsatilgan masofada joylashgan klinikalar ko\'rsatiladi',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Bekor qilish'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilter(_maxDistance);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Qo\'llash'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _resetFilter() {
    setState(() {
      _maxDistance = 5.0; // Default qiymat
    });
  }
}