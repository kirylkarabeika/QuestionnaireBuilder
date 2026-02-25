import 'package:flutter/material.dart';

class OptionalDateTimeField extends StatelessWidget {
  const OptionalDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.includeTime = true,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool includeTime;

  @override
  Widget build(BuildContext context) {
    final enabled = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: enabled,
              onChanged: (v) {
                if (v == true) {
                  // default when enabling: now (rounded) in local time
                  final now = DateTime.now();
                  onChanged(
                    DateTime(
                      now.year,
                      now.month,
                      now.day,
                      now.hour,
                      now.minute,
                    ),
                  );
                } else {
                  onChanged(null);
                }
              },
            ),
            Expanded(child: Text(label)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: enabled ? () => _pick(context) : null,
                icon: const Icon(Icons.calendar_month),
                label: Text(enabled ? _format(value!) : 'Not set'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Clear',
              onPressed: enabled ? () => onChanged(null) : null,
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final initial = value ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    if (!includeTime) {
      onChanged(DateTime(date.year, date.month, date.day));
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (time == null) return;

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  String _format(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return includeTime ? '$y-$m-$d  $hh:$mm' : '$y-$m-$d';
  }
}
