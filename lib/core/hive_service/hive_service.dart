import 'package:hive/hive.dart';

class HiveService {
  static BoxCollection? database;

  static Future<void> initDataBase() async {
    database = await BoxCollection.open("local_database", {"users"});
  }

  Future<void> addNewUser(String userName) async {
    final usersList = await database?.openBox<String>("users");
    await usersList?.put(userName, userName);
  }
}
