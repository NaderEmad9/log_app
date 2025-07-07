import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
    final cardColor = Theme.of(context).cardColor;
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
              child: Text('DateTime Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(height: 18),
            if (hasFilter) ...[
              OutlinedButton(
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.blueGrey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Clear Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
                  border: Border.all(color: Colors.blueGrey.withOpacity(0.4), width: 1.2),
                ),
                child: Text(
                  "Showing logs from '${_formatDateTime(startDate)}' to '${_formatDateTime(endDate)}'",
                  style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.2),
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
                      const Text('Start Date & Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 12),
                      _SfDateTimePickerField(
                        dateTime: startDate,
                        onDateTimeChanged: onStartDateChanged,
                        label: 'Start',
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
                      const Text('End Date & Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 12),
                      _SfDateTimePickerField(
                        dateTime: endDate,
                        onDateTimeChanged: onEndDateChanged,
                        label: 'End',
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

class _SfDateTimePickerField extends StatelessWidget {
  final DateTime? dateTime;
  final ValueChanged<DateTime?> onDateTimeChanged;
  final String label;
  final Color cardColor;
  const _SfDateTimePickerField({required this.dateTime, required this.onDateTimeChanged, required this.label, required this.cardColor});

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
              side: const BorderSide(color: Colors.white, width: 1.2),
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
                      width: 400, // Increased width
                      height: 480, // Increased height
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 8), // Less bottom padding
                        child: SfDateRangePicker(
                          
                          initialSelectedDate: date ?? DateTime.now(),
                          selectionColor: Colors.blueAccent,
                          todayHighlightColor: const Color.fromARGB(255, 25, 93, 212),
                          backgroundColor: cardColor,
                          
                          startRangeSelectionColor: Color(0xFF19294C),
                          endRangeSelectionColor:  Color(0xFF19294C),
                          rangeSelectionColor:  Color(0xC419294C),
                          selectionTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            
                            textStyle: const TextStyle(color: Colors.white),
                            todayTextStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          ),
                          headerStyle: const DateRangePickerHeaderStyle(
                            
                            backgroundColor: Color(0xFF19294C),
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            dayFormat: 'EEE', // Show Sun, Mon, Tue, etc.
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            viewHeaderHeight: 50,
                          ),
                          // Add a custom header to insert vertical space below the header
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
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
                        child: const Text('OK', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              date != null ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}' : '$label Date',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: cardColor,
              side: const BorderSide(color: Colors.white, width: 1.2),
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
                  // Snap minute to closest allowed value
                  List<int> allowedMinutes = [0, 10, 20, 30, 40, 50];
                  int selectedMinute = allowedMinutes.reduce((a, b) => (temp.minute - a).abs() < (temp.minute - b).abs() ? a : b);
                  String selectedPeriod = temp.period == DayPeriod.am ? 'AM' : 'PM';
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
                                        const Text('hours', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 13)),
                                        Center(
                                          child: DropdownButton<int>(
                                            value: selectedHour == 0 ? 12 : selectedHour,
                                            dropdownColor: cardColor,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                            iconEnabledColor: Colors.blueAccent,
                                            underline: Container(height: 2, color: Colors.blueAccent),
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
                                        const Text('minutes', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 13)),
                                        Center(
                                          child: DropdownButton<int>(
                                            value: selectedMinute,
                                            dropdownColor: cardColor,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                            iconEnabledColor: Colors.blueAccent,
                                            underline: Container(height: 2, color: Colors.blueAccent),
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
                                      const Text(' ', style: TextStyle(fontSize: 13)),
                                      Center(
                                        child: DropdownButton<String>(
                                          value: selectedPeriod,
                                          dropdownColor: cardColor,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                          iconEnabledColor: Colors.blueAccent,
                                          underline: Container(height: 2, color: Colors.blueAccent),
                                          alignment: Alignment.center,
                                          items: ['AM', 'PM'].map((p) => DropdownMenuItem(
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
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              int hour = selectedHour % 12;
                              if (selectedPeriod == 'PM') hour += 12;
                              picked = TimeOfDay(hour: hour, minute: selectedMinute);
                              if (picked != null) {
                                final base = date ?? DateTime.now();
                                onDateTimeChanged(DateTime(
                                  base.year, base.month, base.day, picked!.hour, picked!.minute,
                                ));
                              }
                            },
                            child: const Text('OK', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      
                       ),],
                      );
                    },
                  );
                },
              );
            },        
            child: Text(
              time != null ? time.format(context) : '$label Time',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
