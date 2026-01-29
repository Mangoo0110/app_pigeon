import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerField({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
  });

  static DateTime _currentDate = DateTime.now();
  static final TextEditingController _controller = TextEditingController();

  String _formateDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if(selectedDate != null) _currentDate  = selectedDate!;
    _controller.text = selectedDate != null
        ? _formateDate(selectedDate!)
        : '';
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _currentDate,
          firstDate: now,
          lastDate: DateTime(now.year + 5),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
          _currentDate = pickedDate;
          _controller.text = _formateDate(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: label,
            suffixIcon: const Icon(Icons.calendar_today, color: Color.from(alpha: 1, red: 0.451, green: 0.451, blue: 0.451),),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          controller: _controller,
        ),
      ),
    );
  }
}
