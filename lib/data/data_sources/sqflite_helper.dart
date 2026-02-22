import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';
import '../models/visit_model.dart';

class SqfliteHelper {

  static final SqfliteHelper _instance = SqfliteHelper._internal();
  factory SqfliteHelper() => _instance;
  SqfliteHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      fullPath,
      version: AppConstants.databaseVersion,
      onCreate: _createTables,
    );
  }


  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.visitsTable} (
        id        TEXT    PRIMARY KEY,
        farmerName TEXT   NOT NULL,
        village   TEXT    NOT NULL,
        cropType  TEXT    NOT NULL,
        notes     TEXT,
        imagePath TEXT    NOT NULL,
        visitDate TEXT    NOT NULL,
        latitude  REAL    NOT NULL,
        longitude REAL    NOT NULL,
        isSynced  INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertVisit(VisitModel visit) async {
    final db = await database;
    await db.insert(
      AppConstants.visitsTable,
      visit.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<VisitModel>> getVisits() async {
    final db = await database;
    final rows = await db.query(
      AppConstants.visitsTable,
      orderBy: 'visitDate DESC',
    );
    return rows.map((row) => VisitModel.fromJson(row)).toList();
  }


  Future<void> updateVisit(VisitModel visit) async {
    final db = await database;
    await db.update(
      AppConstants.visitsTable,
      visit.toJson(),
      where: 'id = ?',
      whereArgs: [visit.id],
    );
  }


  Future<List<VisitModel>> getPendingVisits() async {
    final db = await database;
    final rows = await db.query(
      AppConstants.visitsTable,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return rows.map((row) => VisitModel.fromJson(row)).toList();
  }
}