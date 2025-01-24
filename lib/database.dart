import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        age INTEGER,
        weight REAL,
        health TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE meal_plans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_type TEXT,
        meal_time TEXT,
        amount REAL,
        water_tracking TEXT
      )
    ''');
  }

  Future<void> insertPet(Map<String, dynamic> pet) async {
    final db = await database;
    await db.insert('pets', pet);
  }

  Future<void> insertMealPlan(Map<String, dynamic> mealPlan) async {
    final db = await database;
    await db.insert('meal_plans', mealPlan);
  }

  Future<Map<String, dynamic>?> getPetByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pets',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllPets() async {
    final db = await database;
    return await db.query('pets');
  }

  Future<List<Map<String, dynamic>>> getMealPlansByPetName(String petName) async {
    final db = await database;
    return await db.query(
      'meal_plans',
      where: 'food_type = ?',
      whereArgs: [petName],
    );
  }

  Future<void> deletePet(int id) async {
    final db = await database;
    await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}