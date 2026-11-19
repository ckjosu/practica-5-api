import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/gasto.dart';

class DbService {
  static Database? _db;

  static Future<Database> _abrir() async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'gastos.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, v) => db.execute('''
        CREATE TABLE gastos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          concepto TEXT NOT NULL,
          monto REAL NOT NULL,
          categoria TEXT NOT NULL,
          latitud REAL,
          longitud REAL,
          fecha TEXT NOT NULL
        )
      '''),
    );
    return _db!;
  }

  static Future<void> insertar(Gasto g) async {
    final db = await _abrir();
    await db.insert('gastos', g.toMap()..remove('id'));
  }

  static Future<List<Gasto>> listar() async {
    final db = await _abrir();
    final filas = await db.query('gastos', orderBy: 'id DESC');
    return filas.map(Gasto.fromMap).toList();
  }

  static Future<void> eliminar(int id) async {
    final db = await _abrir();
    await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }
}
