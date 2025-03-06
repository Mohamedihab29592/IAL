import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('incident_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create tables for static data
    await db.execute('''
    CREATE TABLE incident_types (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE siteId (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE incident_location (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
    ''');


    // Create latLong table with a foreign key linking to siteId
    await db.execute('''
  CREATE TABLE latLong (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    site_id INTEGER NOT NULL,
    latitude TEXT NOT NULL,
    longitude TEXT NOT NULL,
    FOREIGN KEY (site_id) REFERENCES siteId(id) ON DELETE CASCADE
  )
  ''');

    // Create site_addresses table with a foreign key linking to siteId
    await db.execute('''
  CREATE TABLE site_addresses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    site_id INTEGER NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (site_id) REFERENCES siteId(id) ON DELETE CASCADE
  )
  ''');


    await db.execute('''
    CREATE TABLE area_owner (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
    ''');





    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert incident types
    for (String type in [
      "Theft",
      "Vandalism",
      "Fire",
      "Other"
    ]) {
      await db.insert('incident_types', {'name': type});
    }

    List<Map<String, dynamic>> siteData = [
      {"id": 1, "name": "4"},
      {"id": 2, "name": "5"},
      {"id": 3, "name": "10"},
      {"id": 4, "name": "13"},
      {"id": 5, "name": "15"},
      {"id": 6, "name": "25"},
      {"id": 7, "name": "27"},
      {"id": 8, "name": "30"},
    ];

    for (var site in siteData) {
      await db.insert('siteId', site);
    }
    for (String incLocation in [
      "Cairo",
      "Giza",
      "Alexandria",
      "Luxor",
      "Aswan",
      "Kafr EL Shekih",
      "Sinai",
    ]) {
      await db.insert('incident_location', {'name': incLocation});
    }

    // Insert lat/long data linked to siteId
    List<Map<String, dynamic>> latLongData = [
      {"site_id": 1, "latitude": "30.0749409", "longitude": "31.2258187"},
      {"site_id": 2, "latitude": "30.0595563", "longitude": "31.2171789"},
      {"site_id": 3, "latitude": "30.0554273", "longitude": "31.1839322"},
      {"site_id": 4, "latitude": "30.0973368", "longitude": "31.3401697"},
      {"site_id": 5, "latitude": "30.0617849", "longitude": "31.20301"},
      {"site_id": 6, "latitude": "30.0781571", "longitude": "31.2660163"},
      {"site_id": 7, "latitude": "30.1186787", "longitude": "31.3471576"},
      {"site_id": 8, "latitude": "30.068507", "longitude": "31.2626386"},
    ];

    for (var location in latLongData) {
      await db.insert('latLong', location);
    }
    // Insert addresses linked to siteId
    List<Map<String, dynamic>> addressData = [
      {"site_id": 1, "address": "سطح العقار رقم 118 شارع ترعة جزيره بدران - روض الفرج - القاهره"},
      {"site_id": 2, "address": "اعلي سطح العقار رقم 23 شارع الركيبيه عمارة فتح الباب - القلعه - القاهره"},
      {"site_id": 3, "address": "4 شارع ترعة الزمر - الجيزه"},
      {"site_id": 4, "address": "16 ش الزهور من شارع العروبة مصر الجديدة"},
      {"site_id": 5, "address": "24 شارع الفريق على عامر مصر الجديده - القاهره"},
      {"site_id": 6, "address": "مصنع غزل عبدالله بسيوني - الكيلو 2,5 شارع مصر للبترول - مسطرد - القليوبيه"},
      {"site_id": 7, "address": "77 شارع عبد الحميد بدوي - مصر الجديدة"},
      {"site_id": 8, "address": "180 شارع رمسيس"},
    ];


    for (var address in addressData) {
      await db.insert('site_addresses', address);
    }







    for (String member in [
 "Mohamed Essam Hussien",
   " Abdullah Osman",
   " Mahmoud Sayed-Beshir",
    "Ramy Mohamed-Eid",
    "Mohamed Kamal-Mourad",

    ]) {
      await db.insert('area_owner', {'name': member});
    }




  }


  // Helper methods to get data
  Future<List<Map<String, dynamic>>> getIncidentTypes() async {
    final db = await instance.database;
    return await db.query('incident_types');
  }

  Future<List<Map<String, dynamic>>> getLocation() async {
    final db = await instance.database;
    return await db.query('siteId');
  }
  Future<List<Map<String, dynamic>>> getIncLocation() async {
    final db = await instance.database;
    return await db.query('incident_location');
  }

  Future<Map<String, dynamic>?> getSiteDetails(int siteId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT s.id, s.name AS site_name, l.latitude, l.longitude, a.address
    FROM siteId s
    LEFT JOIN latLong l ON s.id = l.site_id
    LEFT JOIN site_addresses a ON s.id = a.site_id
    WHERE s.id = ?
  ''', [siteId]);

    if (result.isNotEmpty) {
      return result.first; // Return the first (and only) matching record
    } else {
      return null;
    }
  }




  Future<List<Map<String, dynamic>>> getAreaOwner() async {
    final db = await instance.database;
    return await db.query('area_owner');
  }





  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}