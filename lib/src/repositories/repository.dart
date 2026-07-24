import 'dart:convert';
import 'dart:io';

// une classe qui va permettre de gerer les données

class Repository<T> {
  final String filePath;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  Repository({
    required this.filePath,
    required this.fromJson,
    required this.toJson,
  });

  // une fonction qui va permettre de lire les données
  Future<List<T>> readData() async {
    final file = File(filePath);
    if (!await file.exists()) {
      return [];
    }
    try {
      String jsonText = await file.readAsString();
      List data = jsonDecode(jsonText);

      return data
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erreur lors de la lecture: $e");
      return [];
    }
  }

  // une fonction qui va permettre de sauvegarder les données
  Future<void> saveData(T data) async {
    final file = File(filePath);
    final dataMap = toJson(data);
    if (await file.exists()) {
      final jsonContent = await file.readAsString();
      List content = jsonDecode(jsonContent);
      content.add(dataMap);

      final jsonList = encoder.convert(content);
      await file.writeAsString(jsonList);
    } else {
      final jsonText = encoder.convert([dataMap]);
      await file.writeAsString(jsonText);
    }
    print("Données sauvegardées");
  }
}
