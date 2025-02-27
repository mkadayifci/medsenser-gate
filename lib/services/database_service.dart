import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';

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
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Devices table
      await db.execute('''
        CREATE TABLE MyDevices (
            deviceId INTEGER PRIMARY KEY,
            convertedDeviceId TEXT,
            lastSeen INTEGER,
            phoneIdentifier TEXT,
            batteryLevel INTEGER,
            firstSeen INTEGER
        )
      ''');
      
      // Measurements table
      await db.execute('''
        CREATE TABLE Measurements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deviceId INTEGER,
            timestamp INTEGER,
            temperatureValue REAL,
            isSyncedWithServer INTEGER DEFAULT 0,
            FOREIGN KEY (deviceId) REFERENCES MyDevices (deviceId)
        )
      ''');
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        // Adding Measurements table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Measurements (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              deviceId INTEGER,
              timestamp INTEGER,
              temperatureValue REAL,
              isSyncedWithServer INTEGER DEFAULT 0,
              FOREIGN KEY (deviceId) REFERENCES MyDevices (deviceId)
          )
        ''');
        
        // Adding firstSeen column to MyDevices table
        await db.execute('ALTER TABLE MyDevices ADD COLUMN firstSeen INTEGER');
      }
    });
  }

  // Get all devices
  Future<List<Map<String, dynamic>>> getAllDevices() async {
    final db = await database;
    final List<Map<String, dynamic>> devices = await db.query('MyDevices');
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
      DateTime lastSeen, String phoneIndentifer, int batteryLevel) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT INTO MyDevices (deviceId, convertedDeviceId, lastSeen, phoneIdentifier, batteryLevel, firstSeen) VALUES (?, ?, ?, ?, ?, ?)',
        [
          deviceId,
          convertedDeviceId,
          lastSeen.millisecondsSinceEpoch,
          phoneIndentifer,
          batteryLevel,
          lastSeen.millisecondsSinceEpoch // Use last seen time as first seen time
        ]);
    return raw;
  }
  
  // Save measurement
  Future<int> insertMeasurement(int deviceId, MeasurementNode measurement) async {
    final db = await database;
    return await db.insert('Measurements', {
      'deviceId': deviceId,
      'timestamp': measurement.timestamp.millisecondsSinceEpoch,
      'temperatureValue': measurement.temperatureValue,
      'isSyncedWithServer': measurement.isSyncedWithServer ? 1 : 0
    });
  }
  
  // Get unsynchronized measurements
  Future<List<Map<String, dynamic>>> getUnsyncedMeasurements() async {
    final db = await database;
    return await db.query(
      'Measurements',
      where: 'isSyncedWithServer = ?',
      whereArgs: [0],
      orderBy: 'timestamp ASC'
    );
  }
  
  // Mark measurements as synchronized
  Future<int> markMeasurementsAsSynced(List<int> measurementIds) async {
    final db = await database;
    return await db.update(
      'Measurements',
      {'isSyncedWithServer': 1},
      where: 'id IN (${List.filled(measurementIds.length, '?').join(', ')})',
      whereArgs: measurementIds
    );
  }
  
  // Update device's last seen time
  Future<int> updateDeviceLastSeen(int deviceId, DateTime lastSeen) async {
    final db = await database;
    return await db.update(
      'MyDevices',
      {'lastSeen': lastSeen.millisecondsSinceEpoch},
      where: 'deviceId = ?',
      whereArgs: [deviceId]
    );
  }

  // Get data
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    var response = await db.query("MyTable");
    return response;
  }
}
