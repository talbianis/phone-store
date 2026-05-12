// lib/views/sales/widgets/date_filter_dialog.dart

import 'package:flutter/material.dart';
import 'package:phone_shop/core/utils/date_formater.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';

class DateFilterDialog extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const DateFilterDialog({
    Key? key,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<DateFilterDialog> createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<DateFilterDialog> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate ?? DateTime.now();
    _endDate = widget.endDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.date_range,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.selectDateRange,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Start Date
            _buildDateSelector(
              l10n.startDate,
              _startDate,
              (date) => setState(() => _startDate = date),
            ),

            const SizedBox(height: 16),

            // End Date
            _buildDateSelector(
              l10n.endDate,
              _endDate,
              (date) => setState(() => _endDate = date),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sidebarBackground,
                  ),
                  onPressed: _handleApply,
                  child: const Text(
                    'Apply Filter',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime date,
    Function(DateTime) onDateSelected,
  ) {
    return InkWell(
      onTap: () => _selectDate(date, onDateSelected),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatDate(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    DateTime initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _handleApply() {
    final l10n = AppLocalizations.of(context);
    if (_startDate.isAfter(_endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.dateRangeInvalid),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'start': _startDate,
      'end': _endDate,
    });
  }
}
