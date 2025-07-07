import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import 'sf_date_time_picker_field.dart';

class DateFilterBar extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback? onClear;
  const DateFilterBar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.onClear,
  });

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '--';
    return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.card;
    final hasFilter = startDate != null || endDate != null;
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(AppStrings.dateTimeFilter, style: AppTextStyles.title),
            ),
            const SizedBox(height: 18),
            if (hasFilter) ...[
              OutlinedButton(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  side: BorderSide(color: AppColors.blueGrey.withOpacity(0.3)),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: Text(AppStrings.clearFilter, style: AppTextStyles.button),
              ),
              const SizedBox(height: 18),
            ],
            if (hasFilter)
              Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blueGrey.withOpacity(0.4), width: 1.2),
                ),
                child: Text(
                  "${AppStrings.showingLogsFrom}${_formatDateTime(startDate)}${AppStrings.to}${_formatDateTime(endDate)}'",
                  style: AppTextStyles.filterValue,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(AppStrings.startDateTime, style: AppTextStyles.filterLabel),
                      const SizedBox(height: 12),
                      SfDateTimePickerField(
                        dateTime: startDate,
                        onDateTimeChanged: onStartDateChanged,
                        label: AppStrings.start,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(AppStrings.endDateTime, style: AppTextStyles.filterLabel),
                      const SizedBox(height: 12),
                      SfDateTimePickerField(
                        dateTime: endDate,
                        onDateTimeChanged: onEndDateChanged,
                        label: AppStrings.end,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
