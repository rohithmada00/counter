// lib/screens/create_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:counter/models/task.dart';
import 'package:counter/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController(text: '1');

  RecurrenceFrequency _selectedRecurrence = RecurrenceFrequency.none;
  DateTime? _selectedExpiryDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetCountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedExpiryDate ??
          DateTime.now().add(
            const Duration(days: 7),
          ), // Default 7 days from now
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      helpText: 'Select Expiry Date', // Custom help text for picker
      cancelText: 'Not now',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // Customize date picker theme
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Primary color
              onPrimary: Colors.white, // Text on primary color
              onSurface: Colors.black, // Text on surface color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(
                      context,
                    ).primaryColor, // Color for "OK", "CANCEL" buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedExpiryDate) {
      setState(() {
        // Clear time components for consistent date storage
        _selectedExpiryDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text.trim();
      final String description = _descriptionController.text.trim();
      final int targetCount = int.tryParse(_targetCountController.text) ?? 1;

      final newTask = Task(
        id: const Uuid().v4(),
        title: title,
        description: description,
        targetCount: targetCount,
        recurrenceFrequency: _selectedRecurrence,
        expiryDate: _selectedExpiryDate,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the theme for consistent styling

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g., Drink 7 liters of water',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'e.g., Helps with hydration and health',
                ),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetCountController,
                decoration: const InputDecoration(
                  labelText: 'Target Count',
                  hintText: 'e.g., 7 for water, 40 for companies',
                  prefixIcon: Icon(Icons.numbers), // Add a subtle icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a target count';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RecurrenceFrequency>(
                value: _selectedRecurrence,
                decoration: const InputDecoration(
                  labelText: 'Recurrence Frequency',
                  prefixIcon: Icon(Icons.repeat), // Add a subtle icon
                ),
                items:
                    RecurrenceFrequency.values.map((frequency) {
                      return DropdownMenuItem(
                        value: frequency,
                        child: Text(
                          frequency.name.replaceFirst(
                            frequency.name[0],
                            frequency.name[0].toUpperCase(),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRecurrence = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Expiry Date Picker
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  leading: Icon(
                    Icons.calendar_today,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    _selectedExpiryDate == null
                        ? 'Select Expiry Date (Optional)'
                        : 'Expiry Date: ${MaterialLocalizations.of(context).formatShortDate(_selectedExpiryDate!)}',
                    style:
                        _selectedExpiryDate == null
                            ? theme
                                .inputDecorationTheme
                                .labelStyle // Use label style for hint
                            : theme.textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 24),
              Hero(
                // Add a Hero animation for a smooth transition
                tag:
                    'add-task-fab', // Match with FAB tag on Home Screen if you want animation
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Add Task',
                    style:
                        theme
                            .textTheme
                            .labelLarge, // Use theme's labelLarge style
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
