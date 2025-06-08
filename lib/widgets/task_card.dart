// lib/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:counter/models/task.dart';
import 'package:counter/providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final theme = Theme.of(context);

    // Calculate progress for the LinearProgressIndicator
    double progress =
        task.targetCount > 0 ? task.currentCount / task.targetCount : 0.0;
    if (progress > 1.0) progress = 1.0; // Cap at 100%

    // Text color and decoration based on completion
    final textColor =
        task.isComplete
            ? theme.textTheme.bodyMedium?.color?.withOpacity(0.6)
            : theme.textTheme.bodyLarge?.color;
    final textDecoration =
        task.isComplete ? TextDecoration.lineThrough : TextDecoration.none;

    return Card(
      // Card margins and shape are now defined in main.dart's CardTheme
      color:
          task.isComplete
              ? Colors.green.withOpacity(0.1)
              : theme.cardTheme.color, // Lighter green tint if complete
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Completion Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      decoration: textDecoration,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (task.isComplete)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 28,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor?.withOpacity(
                      0.8,
                    ), // Slightly faded description
                    decoration: textDecoration,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Progress Bar & Count
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color:
                  task.isComplete
                      ? Colors.green[600]
                      : theme
                          .primaryColor, // Green if complete, primary otherwise
              borderRadius: BorderRadius.circular(4.0),
              minHeight: 8.0,
            ),
            const SizedBox(height: 8),
            Text(
              '${task.currentCount} / ${task.targetCount} ${task.targetCount > 1 ? 'times' : 'time'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                decoration: textDecoration,
              ),
            ),

            // Recurrence and Expiry
            if (task.recurrenceFrequency != RecurrenceFrequency.none)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Repeats: ${task.recurrenceFrequency.name.replaceFirst(task.recurrenceFrequency.name[0], task.recurrenceFrequency.name[0].toUpperCase())}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            if (task.expiryDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.event, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Expires: ${task.expiryDate!.toLocal().toIso8601String().split('T')[0]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.undo, color: Colors.grey[600]),
                  onPressed: () => taskProvider.resetTaskCount(task),
                  tooltip: 'Reset Count',
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  onPressed: () => taskProvider.deleteTask(task),
                  tooltip: 'Delete Task',
                ),
                const SizedBox(width: 8),
                Expanded(
                  // Use Expanded to make the increment button fill available space
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: Text(task.isComplete ? 'Completed!' : 'Increment'),
                    onPressed:
                        task.isComplete
                            ? null // Disable if complete
                            : () => taskProvider.incrementTaskCount(task),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          task.isComplete
                              ? Colors.green
                              : theme.elevatedButtonTheme.style?.backgroundColor
                                  ?.resolve({}),
                    ),
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
