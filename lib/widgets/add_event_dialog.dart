import 'package:app/services/add_events.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<String> districts = [
    'For All Disctricts',
    'St. John',
    'St. Luke',
    'St. Mark',
    'St. Matthias',
    'St. Matthew',
    'St. Paul',
  ];
  String district = 'St. John';

  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Event Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Event Description',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Event Date: '),
                Expanded(
                  child: TextButton(
                    child: Builder(builder: (context) {
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final String formattedDate =
                          formatter.format(_selectedDate);
                      return Text(
                        formattedDate.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextRegular(
                    text: 'For district:', fontSize: 12, color: Colors.grey),
                const SizedBox()
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton(
                underline: const SizedBox(),
                value: dropdownValue,
                items: [
                  for (int i = 0; i < districts.length; i++)
                    DropdownMenuItem(
                      value: i,
                      onTap: () {
                        setState(() {
                          district = districts[i];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextRegular(
                            text: districts[i],
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    dropdownValue = int.parse(value.toString());
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            // Do something with the input data, such as saving it to a database
            String title = _titleController.text;
            String description = _descriptionController.text;
            DateTime date = _selectedDate;

            addEvents(title, description, date, date.day, date.month, date.year,
                district);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
