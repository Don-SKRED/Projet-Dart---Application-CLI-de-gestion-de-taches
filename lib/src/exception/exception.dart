class ListException implements Exception {
  final int listLength;
  ListException(this.listLength);
  @override
  String toString() {
    if (listLength == 0) {
      return "Aucune tâche n'a encore été ajoutée";
    } else {
      return "l'index que vous avez donné n'existe pas";
    }
  }
}

class DateException implements Exception {
  final String dateSource;
  DateException(this.dateSource);
  @override
  String toString() {
    return "'$dateSource' est un format de date invalide. Utilisez le format: jj-mm-aaaa";
  }
}

class PriorityException implements Exception {
  final String? value;
  PriorityException({this.value});

  @override
  String toString() {
    return "Priorité invalide: '$value'. Veuillez choisir parmi: low, medium, high";
  }
}
