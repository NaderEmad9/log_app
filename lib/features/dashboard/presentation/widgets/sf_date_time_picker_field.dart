import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';

class SfDateTimePickerField extends StatelessWidget {
  final DateTime? dateTime;
  final ValueChanged<DateTime?> onDateTimeChanged;
  final String label;
  final Color cardColor;
  const SfDateTimePickerField({required this.dateTime, required this.onDateTimeChanged, required this.label, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final date = dateTime;
    final time = dateTime != null ? TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute) : null;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: cardColor,
              side: const BorderSide(color: AppColors.white, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onPressed: () async {
              DateTime? picked;
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    content: SizedBox(
                      width: 400,
                      height: 480,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
                        child: SfDateRangePicker(
                          initialSelectedDate: date ?? DateTime.now(),
                          selectionColor: AppColors.blueAccent,
                          todayHighlightColor: const Color.fromARGB(255, 25, 93, 212),
                          backgroundColor: cardColor,
                          startRangeSelectionColor: AppColors.cardBorder,
                          endRangeSelectionColor: AppColors.cardBorder,
                          rangeSelectionColor: AppColors.cardBorder.withOpacity(0.77),
                          selectionTextStyle: AppTextStyles.okButton.copyWith(color: Colors.black),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            textStyle: AppTextStyles.dateButton,
                            todayTextStyle: AppTextStyles.okButton,
                          ),
                          headerStyle: DateRangePickerHeaderStyle(
                            backgroundColor: AppColors.cardBorder,
                            textAlign: TextAlign.center,
                            textStyle: AppTextStyles.okButton.copyWith(fontSize: 16),
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            dayFormat: 'EEE',
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              textStyle: AppTextStyles.dropdown.copyWith(color: AppColors.grey400, fontWeight: FontWeight.bold),
                            ),
                            viewHeaderHeight: 50,
                          ),
                          showNavigationArrow: true,
                          headerHeight: 30,
                          onSelectionChanged: (args) {
                            if (args.value is DateTime) {
                              picked = args.value;
                            }
                          },
                          selectionMode: DateRangePickerSelectionMode.single,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppStrings.cancel, style: AppTextStyles.cancelButton),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (picked != null) {
                            onDateTimeChanged(DateTime(
                              picked!.year, picked!.month, picked!.day, time?.hour ?? 0, time?.minute ?? 0,
                            ));
                          }
                        },
                        child: Text(AppStrings.ok, style: AppTextStyles.okButton),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              date != null ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}' : '$label ${AppStrings.date}',
              style: AppTextStyles.dateButton,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: cardColor,
              side: const BorderSide(color: AppColors.white, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onPressed: () async {
              TimeOfDay? picked = time;
              await showDialog(
                context: context,
                builder: (context) {
                  TimeOfDay temp = time ?? TimeOfDay.now();
                  int selectedHour = temp.hour == 0 ? 12 : (temp.hour > 12 ? temp.hour - 12 : temp.hour);
                  List<int> allowedMinutes = [0, 10, 20, 30, 40, 50];
                  int selectedMinute = allowedMinutes.reduce((a, b) => (temp.minute - a).abs() < (temp.minute - b).abs() ? a : b);
                  String selectedPeriod = temp.period == DayPeriod.am ? AppStrings.am : AppStrings.pm;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: cardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        content: SizedBox(
                          width: 260,
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(AppStrings.hours, style: AppTextStyles.dropdownLabel),
                                        Center(
                                          child: DropdownButton<int>(
                                            value: selectedHour == 0 ? 12 : selectedHour,
                                            dropdownColor: cardColor,
                                            style: AppTextStyles.dropdown,
                                            iconEnabledColor: AppColors.blueAccent,
                                            underline: Container(height: 2, color: AppColors.blueAccent),
                                            isExpanded: true,
                                            alignment: Alignment.center,
                                            items: List.generate(12, (i) => DropdownMenuItem(
                                              value: i + 1,
                                              alignment: Alignment.center,
                                              child: Center(child: Text((i + 1).toString().padLeft(2, '0'))),
                                            )),
                                            onChanged: (v) {
                                              if (v != null) setState(() => selectedHour = v);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(AppStrings.minutes, style: AppTextStyles.dropdownLabel),
                                        Center(
                                          child: DropdownButton<int>(
                                            value: selectedMinute,
                                            dropdownColor: cardColor,
                                            style: AppTextStyles.dropdown,
                                            iconEnabledColor: AppColors.blueAccent,
                                            underline: Container(height: 2, color: AppColors.blueAccent),
                                            isExpanded: true,
                                            alignment: Alignment.center,
                                            items: [0, 10, 20, 30, 40, 50].map((i) => DropdownMenuItem(
                                              value: i,
                                              alignment: Alignment.center,
                                              child: Center(child: Text(i.toString().padLeft(2, '0'))),
                                            )).toList(),
                                            onChanged: (v) {
                                              if (v != null) setState(() => selectedMinute = v);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    children: [
                                      Text(' ', style: AppTextStyles.dropdownLabel),
                                      Center(
                                        child: DropdownButton<String>(
                                          value: selectedPeriod,
                                          dropdownColor: cardColor,
                                          style: AppTextStyles.dropdown,
                                          iconEnabledColor: AppColors.blueAccent,
                                          underline: Container(height: 2, color: AppColors.blueAccent),
                                          alignment: Alignment.center,
                                          items: [AppStrings.am, AppStrings.pm].map((p) => DropdownMenuItem(
                                            value: p,
                                            alignment: Alignment.center,
                                            child: Center(child: Text(p)),
                                          )).toList(),
                                          onChanged: (v) {
                                            if (v != null) setState(() => selectedPeriod = v);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppStrings.cancel, style: AppTextStyles.cancelButton),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              int hour = selectedHour % 12;
                              if (selectedPeriod == AppStrings.pm) hour += 12;
                              picked = TimeOfDay(hour: hour, minute: selectedMinute);
                              if (picked != null) {
                                final base = date ?? DateTime.now();
                                onDateTimeChanged(DateTime(
                                  base.year, base.month, base.day, picked!.hour, picked!.minute,
                                ));
                              }
                            },
                            child: Text(AppStrings.ok, style: AppTextStyles.okButton),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: Text(
              time != null ? time.format(context) : '$label ${AppStrings.time}',
              style: AppTextStyles.dateButton,
            ),
          ),
        ),
      ],
    );
  }
}
