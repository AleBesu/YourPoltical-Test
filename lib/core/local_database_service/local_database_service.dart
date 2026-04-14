import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_political_test/core/entities/political_result.dart';

class LocalDatabaseService {
  static BoxCollection? _database;

  static Future<void> initDataBase() async {
    _database = await BoxCollection.open("local_database", {
      "historial",
    }, path: (await getApplicationDocumentsDirectory()).path);
  }

  static Future<void> addNewResultToHistorial(PoliticalResult result) async {
    final testHistorialList = await _database?.openBox<Map>("historial");
    await testHistorialList?.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      result.toJson(),
    );
  }

  static Future<List<PoliticalResult>> getTestListHistorial() async {
    final testHistorialList = await _database?.openBox<Map>("historial");
    if (testHistorialList == null) return [];
    return (await testHistorialList.getAllValues()).values
        .map((e) => PoliticalResult.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }
}
