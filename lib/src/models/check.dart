//interface pour vérifier si une tâche est fini ou non
abstract class Check {
  bool get status;
  void modifyStatus(bool value);
}
