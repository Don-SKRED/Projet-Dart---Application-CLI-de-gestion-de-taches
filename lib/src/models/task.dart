import 'package:task_management/src/models/check.dart';
import 'package:task_management/src/models/work.dart';
import 'package:task_management/task_management.dart';

enum Priority {
  low(value: 1),
  medium(value: 2),
  high(value: 3);

  final int value;
  const Priority({required this.value});
}

class Task extends Work implements Check {
  final String title;
  final Priority priority;
  final DateTime? deadline;
  // bool _status;
  @override
  bool status;
  Task({
    super.name,
    required this.title,
    required this.priority,
    this.deadline,
    this.status = false,
  });

  @override
  void modifyStatus(bool value) {
    status = value;
  }

  // set status(bool status) {
  //   _status = status;
  // }

  // bool get status => _status;
  Map<String, dynamic> toJson() => {
    'title': title,
    'priority': priority.name,
    'deadline': deadline?.toString(),
    'status': status,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json["name"],
      title: json['title'],
      priority: priorityChoice(json['priority']),
      deadline: json['deadline'] != null && json['deadline'] != 'null'
          ? DateTime.parse(json['deadline'] as String)
          : null,
      status: json['status'],
    );
  }
}
