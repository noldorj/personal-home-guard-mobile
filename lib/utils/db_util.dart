import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'alerts.db'),
      onCreate: (db, version) {
        //print('onCreate...');
        return db.execute(
            'CREATE TABLE alerts (id TEXT PRIMARY KEY, cameraName TEXT, regionName TEXT, date INTEGER, hour TEXT, objectDetected TEXT,  textAlert TEXT, urlImageFirebase TEXT, urlImageDownload TEXT, urlImageLocal TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> deleteDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(path.join(dbPath, 'alerts.db'));
    //print('deleteDatabase');
  }

  static Future<void> deleteAll() async {
    // Get a reference to the database.
    final db = await DbUtil.database();

    // Remove the Dog from the Database.
    await db.delete('alerts');
    //print('deleleteAll...');
  }

  static Future<void> deleteAlert(String id) async {
    // Get a reference to the database.
    final db = await DbUtil.database();

    //print('deleteAlert:: id: $id');

    // Remove the Dog from the Database.
    await db.delete(
      'alerts',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    //print('db_util::insert');
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAlertByDate(
      DateTime date) async {
    final db = await DbUtil.database();
    DateFormat format = new DateFormat("MM-dd-yyyy");

    var newDate = format.format(date);

    int dateMill = format.parse(newDate).millisecondsSinceEpoch;

    //print('db_util::getAlertByDate date: $newDate');

    return db.query('alerts', where: "date = ?", whereArgs: [dateMill]);
  }

  static Future<List<Map<String, dynamic>>> getAlertAfterDate(
      DateTime date) async {
    final db = await DbUtil.database();

    DateFormat format = new DateFormat("MM-dd-yyyy");
    var newDate = format.format(date);
    int dateMill = format.parse(newDate).millisecondsSinceEpoch;

    //print('db_util::getAlertAfterDate date: $newDate');

    return db.query('alerts', where: "date >= ? ", whereArgs: [dateMill]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
