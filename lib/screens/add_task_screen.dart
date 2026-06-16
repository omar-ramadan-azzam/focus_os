import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/calendar_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة مهمة إلى التقويم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'العنوان')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: 'الوصف')),
            ListTile(
              title: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(_selectedTime.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  final startDateTime = DateTime(
                    _selectedDate.year, _selectedDate.month, _selectedDate.day,
                    _selectedTime.hour, _selectedTime.minute,
                  );
                  final endDateTime = startDateTime.add(Duration(hours: 1));
                  final granted = await CalendarService.requestPermissions();
                  if (granted) {
                    await CalendarService.addEvent(
                      title: _titleController.text,
                      description: _descController.text,
                      startDate: startDateTime,
                      endDate: endDateTime,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت الإضافة')));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('يجب منح صلاحية التقويم')));
                  }
                }
              },
              child: Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }
}
