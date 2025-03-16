import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService db = DatabaseService._();
  DatabaseService._();

  Future<Database> get database async {
    //resetDatabase();
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }
Future<void> resetDatabase() async {
  String path = join(await getDatabasesPath(), 'medsenser_local.db');
  await deleteDatabase(path); // Veritabanını sil
  _database = null; // Bellekteki referansı temizle
}

  initDB() async {
    String path = join(await getDatabasesPath(), 'medsenser_local.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Devices table
      await db.execute('''
        create table devices
        (
            deviceId          INTEGER primary key,
            convertedDeviceId TEXT,
            lastSeen          INTEGER,
            batteryLevel      INTEGER
        );
      ''');
      
      // Measurements table
      await db.execute('''
        CREATE TABLE measurements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deviceId INTEGER,
            timestamp INTEGER,
            temperatureValue REAL,
            isSyncedWithServer INTEGER DEFAULT 0,
            FOREIGN KEY (deviceId) REFERENCES devices (deviceId) ON DELETE CASCADE
        )
      ''');
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) async {
  
    });
  }


  Future<int> insertMeasurement(int deviceId, int timestamp, double temperatureValue) async {
    final db = await database;
    return await db.insert('measurements', {
      'deviceId': deviceId,
      'timestamp': timestamp,
      'temperatureValue': temperatureValue,
      'isSyncedWithServer': 0 // Assuming 0 means not synced
    });
  }

  // Get all devices
  Future<List<Map<String, dynamic>>> getAllDevices() async {
    final db = await database;
    final List<Map<String, dynamic>> devices = await db.query('devices');
    return devices;
  }

  // Insert data
  insertData(String name) async {
    final db = await database;
    var raw =
        await db.rawInsert('INSERT INTO MyTable (name) VALUES (?)', [name]);
    return raw;
  }

  // Register device
  insertRegisteredDevice(int deviceId, String convertedDeviceId,
      DateTime lastSeen, int batteryLevel) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT INTO devices (deviceId, convertedDeviceId, lastSeen, batteryLevel) VALUES (?, ?, ?, ?)',
        [
          deviceId,
          convertedDeviceId,
          lastSeen.millisecondsSinceEpoch,
          batteryLevel,
        ]);
    return raw;
  }
  
  // Save measurement
  // Future<int> insertMeasurement(int deviceId, MeasurementNode measurement) async {
  //   final db = await database;
  //   return await db.insert('measurements', {
  //     'deviceId': deviceId,
  //     'timestamp': measurement.timestamp.millisecondsSinceEpoch / 1000,
  //     'temperatureValue': measurement.temperatureValue,
  //     'isSyncedWithServer': measurement.isSyncedWithServer ? 1 : 0
  //   });
  // }
  // Get unsynchronized measurements
  Future<List<Map<String, dynamic>>> getUnsyncedMeasurements() async {
    final db = await database;
    return await db.query(
      'measurements',
      where: 'isSyncedWithServer = ?',
      whereArgs: [0],
      orderBy: 'timestamp ASC'
    );
  }
  
  // Mark measurements as synchronized
  Future<int> markMeasurementsAsSynced(List<int> measurementIds) async {
    final db = await database;
    return await db.update(
      'measurements',
      {'isSyncedWithServer': 1},
      where: 'id IN (${List.filled(measurementIds.length, '?').join(', ')})',
      whereArgs: measurementIds
    );
  }

  // Get measurements for a specific device
  Future<List<Map<String, dynamic>>> getDeviceMeasurements(int deviceId) async {
    final db = await database;
    return await db.query(
      'measurements',
      where: 'deviceId = ?',
      whereArgs: [deviceId],
      orderBy: 'timestamp ASC'
    );
  }
  
  // Update device's last seen time
  Future<int> updateDeviceLastSeen(int deviceId, DateTime lastSeen) async {
    final db = await database;
    return await db.update(
      'devices',
      {'lastSeen': lastSeen.millisecondsSinceEpoch},
      where: 'deviceId = ?',
      whereArgs: [deviceId]
    );
  }

  // Insert or update device
  Future<int> insertDevice(int deviceId, String convertedDeviceId, int lastSeen, int batteryLevel) async {
    final db = await database;
    
    // Check if device exists
    final List<Map<String, dynamic>> existingDevices = await db.query(
      'devices',
      where: 'deviceId = ?',
      whereArgs: [deviceId]
    );
    
    if (existingDevices.isNotEmpty) {
      // Update existing device
      return await db.update(
        'devices',
        {
          'convertedDeviceId': convertedDeviceId,
          'lastSeen': lastSeen,
          'batteryLevel': batteryLevel
        },
        where: 'deviceId = ?',
        whereArgs: [deviceId]
      );
    } else {
      // Insert new device
      return await db.insert('devices', {
        'deviceId': deviceId,
        'convertedDeviceId': convertedDeviceId,
        'lastSeen': lastSeen,
        'batteryLevel': batteryLevel
      });
    }
  }

  // Get data
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    var response = await db.query("MyTable");
    return response;
  }
}
