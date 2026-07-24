import 'dart:io';
import 'dart:convert';

import 'package:task_management/src/exception/exception.dart';
import 'package:task_management/src/models/task.dart';
import 'package:task_management/src/repositories/repository.dart';

List<Task> listTask = [];
const filePath = r"save.json";
final file = File(filePath);
final encoder = const JsonEncoder.withIndent('');

final Repository<Task> repository = Repository(
  filePath: filePath,
  fromJson: Task.fromJson,
  toJson: (task) => task.toJson(),
);

Priority priorityChoice(String? inputUser) {
  switch (inputUser) {
    case 'low':
      return Priority.low;
    case '':
      return Priority.low;
    case 'medium':
      return Priority.medium;
    case 'high':
      return Priority.high;
    default:
      throw PriorityException(value: inputUser);
  }
}

Future<void> addTask() async {
  Task newTask;
  DateTime? date;
  stdout.writeln("Donner le nom du travail (optionnel)");
  String? inputWorkName = stdin.readLineSync();

  String? inputTitle;
  stdout.writeln("Donner une priorité ( low, medium, high ), par défaut [low]");

  String? inputPriority = stdin.readLineSync();
  Priority priority = priorityChoice(inputPriority);

  stdout.writeln("Donner une date limite format jj-mm-aaaa(optionnel) :");
  String? inputdeadline = stdin.readLineSync();

  if (inputdeadline != null && inputdeadline != "") {
    date = dateManagement(inputdeadline);
  }

  stdout.writeln("Donner un titre:");

  do {
    inputTitle = stdin.readLineSync();
    if (inputTitle!.isEmpty || inputTitle == "") {
      stdout.writeln("veuillez donnez un titre");
    }
  } while (inputTitle.isEmpty || inputTitle == "");
  if (inputdeadline != null && inputdeadline != "" && date != null) {
    newTask = Task(
      name: inputWorkName,
      title: inputTitle,
      deadline: date,
      priority: priority,
    );
  } else {
    newTask = Task(name: inputWorkName, title: inputTitle, priority: priority);
  }
  await repository.saveData(newTask);
  print("Nouvelle tâche ajouté :)");
}

Future<void> showListTask() async {
  String? choixUtilisateur;

  if (await file.exists()) {
    listTask = await repository.readData();

    if (listTask.isEmpty) {
      throw ListException(listTask.length);
    }
    stdout.writeln("1- Tri par priorité croissante");
    stdout.writeln("2- Tri par date croissante");
    stdout.writeln("3- Tri par priorité décroissante");
    stdout.writeln("4- Tri par date décroissante");
    stdout.writeln("0- retour");

    for (int i = 0; i < listTask.length; i++) {
      stdout.writeln(
        "[${i + 1}] TITRE: ${listTask[i].title} - PRIORITE: ${listTask[i].priority.name} ${listTask[i].deadline == null ? "" : "- DATE LIMITE: ${listTask[i].deadline!.day}-${listTask[i].deadline!.month}-${listTask[i].deadline!.year}"} - STATUS: ${listTask[i].status ? "Terminé" : "En cours"}  ",
      );
    }
    do {
      stdout.write("Donnez votre choix (tri): ");
      choixUtilisateur = stdin.readLineSync();
      switch (choixUtilisateur) {
        case '1':
          listTask.sort((a, b) => a.priority.value.compareTo(b.priority.value));
          displayList();

        case '2':
          var tasksWithDeadline = listTask
              .where((t) => t.deadline != null)
              .toList();

          tasksWithDeadline.sort((a, b) => a.deadline!.compareTo(b.deadline!));
          listTask = [
            ...tasksWithDeadline,
            ...listTask.where((t) => t.deadline == null),
          ];
          displayList();
        case '3':
          listTask.sort((a, b) => b.priority.value.compareTo(a.priority.value));
          displayList();

        case '4':
          var tasksWithDeadline = listTask
              .where((t) => t.deadline != null)
              .toList();
          tasksWithDeadline.sort((a, b) => b.deadline!.compareTo(a.deadline!));
          listTask = [
            ...tasksWithDeadline,
            ...listTask.where((t) => t.deadline == null).toList(),
          ];
          displayList();
      }
    } while (choixUtilisateur != '0');
  } else {
    throw ListException(listTask.length);
  }
}

Future<void> deleteTask() async {
  String? taskTitle;

  if (await file.exists()) {
    listTask = await repository.readData();
    if (listTask.isEmpty) {
      throw ListException(listTask.length);
    }
    stdout.write("quel tâche voulez-vous supprimer? (nom de la tâche): ");
    taskTitle = stdin.readLineSync();
    if (listTask.any((task) => task.title == taskTitle)) {
      // ✅ any() s'arrête au premier match
      listTask.removeWhere((task) => task.title == taskTitle);
      stdout.writeln("cette tâche a été supprimé :(");
      final newList = encoder.convert(listTask);
      await file.writeAsString(newList);
    } else {
      print("cette tâche n'existe pas ");
    }
  } else {
    throw ListException(listTask.length);
  }
}

Future<void> changeStatus() async {
  String? inputTaskToChangeStatus;
  int? index;
  if (await file.exists()) {
    listTask = await repository.readData();
    if (listTask.isEmpty) {
      throw ListException(listTask.length);
    }
    stdout.write(
      "quel tâche voulez-vous marquer comme Terminé? (numéro de la tâche): ",
    );

    do {
      inputTaskToChangeStatus = stdin.readLineSync();
      index = int.tryParse(inputTaskToChangeStatus!);
      if (index == null || index <= 0 || index > listTask.length) {
        throw ListException(listTask.length);
      }
    } while (index <= 0);

    listTask[index - 1].modifyStatus(true);
    final newList = encoder.convert(listTask);
    await file.writeAsString(newList);
    stdout.writeln("cette tâche est terminé :)");
  } else {
    throw ListException(listTask.length);
  }
}

DateTime dateManagement(String inputDate) {
  DateTime? dateTime;
  String dateToDisplay = "";
  List<String>? date = inputDate.split("-");
  final day = inputDate.substring(0, 2);
  final month = inputDate.substring(3, 5);
  final year = inputDate.substring(6);

  for (int i = date.length - 1; i >= 0; i--) {
    dateToDisplay = "$dateToDisplay${date[i]}";
    if (i != 0) dateToDisplay = "$dateToDisplay-";
  }
  if (inputDate.length != 10) {
    throw DateException(inputDate);
  } else {
    if (inputDate[2] != '-' || inputDate[5] != '-') {
      throw DateException(inputDate);
    } else {
      if (day.length != 2 || month.length != 2 || year.length != 4) {
        throw DateException(inputDate);
      } else {
        if (int.parse(day) < 1 ||
            int.parse(day) > 31 ||
            int.parse(month) < 1 ||
            int.parse(year) > 12) {
          throw DateException(inputDate);
        }
      }
    }
    dateTime = DateTime.parse(dateToDisplay);

    return dateTime;
  }
}

void displayList() {
  for (int i = 0; i < listTask.length; i++) {
    stdout.writeln(
      "[${i + 1}] TITRE: ${listTask[i].title} - PRIORITE: ${listTask[i].priority.name} ${listTask[i].deadline == null ? "" : "- DATE LIMITE: ${listTask[i].deadline!.day}-${listTask[i].deadline!.month}-${listTask[i].deadline!.year}"} - STATUS: ${listTask[i].status ? "Terminé" : "En cours"}  ",
    );
  }
}
