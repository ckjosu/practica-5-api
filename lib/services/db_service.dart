import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/reporte.dart';

class DbService {
  static Database? _db;

  static Future<Database> get _database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'reportes.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE reportes('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'titulo TEXT NOT NULL, '
        'descripcion TEXT NOT NULL, '
        'categoria TEXT NOT NULL, '
        'ruta_foto TEXT, '
        'latitud REAL, '
        'longitud REAL, '
        'fecha TEXT NOT NULL)',
      ),
    );
    return _db!;
  }

  static Future<int> insertar(Reporte r) async {
    final db = await _database;
    return db.insert('reportes', r.toMap()..remove('id'));
  }

  static Future<List<Reporte>> listar() async {
    final db = await _database;
    final filas = await db.query('reportes', orderBy: 'id DESC');
    return filas.map(Reporte.fromMap).toList();
  }

  static Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete('reportes', where: 'id=?', whereArgs: [id]);
  }
}
