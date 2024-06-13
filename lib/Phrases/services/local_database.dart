import 'package:sqflite/sqflite.dart';
import 'package:bfootlearn/Phrases/models/card_data.dart';

class LocalDatabaseHelper {
  static Future<Database> createDatabase() async {
    return await openDatabase(
      "phrases.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE series (id INTEGER PRIMARY KEY, seriesName TEXT, iconImage TEXT)',
        );
        await db.execute(
          'CREATE TABLE allData (id INTEGER PRIMARY KEY, documentId TEXT, englishText TEXT, blackfootText TEXT, blackfootAudio TEXT, seriesName TEXT)',
        );
        await db.execute(
          'CREATE TABLE lastFetchTime (id INTEGER PRIMARY KEY, fetchTime INTEGER)',
        );
      },
    );
  }

  static Future<void> insertSeries(String seriesName, String iconImage) async {
    var db = await createDatabase();
    await db.insert(
      'series',
      {'seriesName': seriesName, 'iconImage': iconImage},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertCardData(CardData cardData) async {
    var db = await createDatabase();
    await db.insert(
      'allData',
      {
        "documentId": cardData.documentId,
        "englishText": cardData.englishText,
        "blackfootText": cardData.blackfootText,
        "blackfootAudio": cardData.blackfootAudio,
        "seriesName": cardData.seriesName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> clearDatabase() async {
    var db = await createDatabase();
    await db.delete('series');
    await db.delete('allData');
  }

  static Future<List<Map<String, dynamic>>> getAllSeries() async {
    var db = await createDatabase();
    return await db.query('series');
  }

  static Future<List<Map<String, dynamic>>> getAllCardData() async {
    var db = await createDatabase();
    return await db.query('allData');
  }

  static Future<void> insertFetchTime(int fetchTime) async {
    var db = await createDatabase();
    await db.insert(
      'lastFetchTime',
      {'id': 1, 'fetchTime': fetchTime},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int?> getLastFetchTime() async {
    var db = await createDatabase();
    List<Map<String, dynamic>> result =
        await db.query('lastFetchTime', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['fetchTime'] as int?;
    }
    return null;
  }
}
