
import 'dart:io';

import 'package:task_management/src/exception/exception.dart';
import 'package:task_management/task_management.dart';

void main(List<String> arguments) async {
  String? choixUtilisateur;

  stdout.writeln("1- Pour ajouter une nouvelle tâche");
  stdout.writeln("2- Pour Lister toutes les tâches");
  stdout.writeln("3- Pour supprimer une tâche");
  stdout.writeln("4- Pour marquer une tâche comme terminé");
  stdout.writeln("0- Pour quitter");

  do {
    stdout.write("Donnez votre choix (Menu):");
    choixUtilisateur = stdin.readLineSync();
    switch (choixUtilisateur) {
      case '1':
        try {
          await addTask();
        } on PriorityException catch (e) {
          print(e);
        } on DateException catch (e) {
          print(e);
        }
      case '2':
        try {
          await showListTask();
        } on ListException catch (e) {
          print(e);
        }
      case '3':
        try {
          await deleteTask();
        } on ListException catch (e) {
          print(e);
        }

      case '4':
        try {
          await changeStatus();
        } on ListException catch (e) {
          print(e);
        }

      case '0':
        print("Merci pour l'utilisation");
      default:
        print("Vous devez faire un choix parmis ceux qui sont cités");
    }
  } while (choixUtilisateur != '0');
}
