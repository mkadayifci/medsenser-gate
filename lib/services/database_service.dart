import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService db = DatabaseService._();
  DatabaseService._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'medsenser_local.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='MyDevices'");
      if (tables.isEmpty) {
        await db.execute('''
                              CREATE TABLE MyDevices (
                                  deviceId INTEGER PRIMARY KEY,
                                  convertedDeviceId TEXT,
                                  lastSeen INTEGER,
                                  phoneIdentifier TEXT,
                                  batteryLevel INTEGER
                              )
                            ''');
      }
    });
  }

// Tüm cihazları getir
  Future<List<Map<String, dynamic>>> getAllDevices() async {
    final db = await database;
    final List<Map<String, dynamic>> devices = await db.query('MyDevices');
    return devices;
  }

  // Veri ekleme
  insertData(String name) async {
    final db = await database;
    var raw =
        await db.rawInsert('INSERT INTO MyTable (name) VALUES (?)', [name]);
    return raw;
  }

  insertRegisteredDevice(int deviceId, String convertedDeviceId,
      DateTime lastSeen, String phoneIndentifer, int batteryLevel) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT INTO MyDevices (deviceId,convertedDeviceId,lastSeen,phoneIdentifier,batteryLevel) VALUES (?,?,?,?,?)',
        [
          deviceId,
          convertedDeviceId,
          lastSeen.millisecondsSinceEpoch,
          phoneIndentifer,
          batteryLevel
        ]);
    return raw;
  }

  // Veri çekme
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    var response = await db.query("MyTable");
    return response;
  }
}
