import 'dart:convert';
import 'dart:io';

import 'package:task_management/src/exception/exception.dart';
import 'package:task_management/src/models/task.dart';
import 'package:task_management/src/repositories/repository.dart';
import 'package:task_management/task_management.dart';
import 'package:test/test.dart';

void main() {
  // test sur les dates
  group('Tout les tests sur les dates', () {
    test("test sur la conversion en date", () {
      String dateTest = "22-07-2026";
      expect(dateManagement(dateTest), equals(DateTime.parse("2026-07-22")));
    });

    test("Rejet d'une date trop courte", () {
      expect(() => dateManagement("22-07-26"), throwsA(isA<DateException>()));
    });
  });

  // test pour la priorité
  test("test pour la Priorité", () {
    String priorityTest = "low";
    expect(priorityChoice(priorityTest), equals(Priority.low));
  });

  // test pour la méthode fromJson de Task
  test("test de la méthode fromJson de Task", () {
    Map<String, dynamic> json = {
      "name": "work test",
      "title": "test",
      "priority": "low",
      // "deadline": DateTime.parse("2026-04-23"),
      "deadline": '2026-04-23',

      "status": false,
    };
    final taskTest = Task.fromJson(json);
    expect(taskTest.name, equals("work test"));
    expect(taskTest.title, equals("test"));
    expect(taskTest.priority, equals(Priority.low));
    expect(taskTest.status, equals(false));
  });

  // test du repository
  group('Tests du Repository', () {
    final fileTemp = File('fileTemp.json');

    setUp(() async {
      if (await fileTemp.exists()) {
        await fileTemp.delete();
      }
    });

    tearDown(() async {
      if (await fileTemp.exists()) {
        await fileTemp.delete();
      }
    });

    // test de la méthode saveData
    test('test de saveData() ', () async {
      final repository = Repository<Task>(
        filePath: 'fileTemp.json',
        fromJson: Task.fromJson,
        toJson: (task) => task.toJson(),
      );

      final task = Task(title: 'titre', priority: Priority.low);
      await repository.saveData(task);

      final content = await fileTemp.readAsString();
      final List listContent = jsonDecode(content);
      expect(listContent[0]['title'], equals('titre'));
    });

    // test de la méthode readData
    test('test de readData() ', () async {
      final repository = Repository<Task>(
        filePath: 'fileTemp.json',
        fromJson: Task.fromJson,
        toJson: (task) => task.toJson(),
      );
      final tasks = await repository.readData();
      expect(tasks, isEmpty);
    });
  });
}
