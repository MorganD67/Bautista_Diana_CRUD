import 'package:flutter_crud_didi/modelos/notas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Operaciones{
  static Future<Database> _openDB() async {
    try{
      return await openDatabase(
      join(await getDatabasesPath(), 'notas.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE IF NOT EXIST notas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, descripcion TEXT)",
        );
      },
      version: 1,
    );
  } catch (e){
    print('Error al abrir la base de datos: $e');
    throw Exception('Error al abrir la base de datos');
  }
}

    // Callback para notificar cambios
    static void Function()? _onDatabaseChange;

    // Método para establecer el callback de cambio
    static void setOnDatabaseChange(void Function()? onChanged) {
      _onDatabaseChange = onChanged;
    }

    // Método para notificar cambios
    static void notifyListeners() {
      if (_onDatabaseChange != null) {
        _onDatabaseChange!();
      }
    }

  static Future<void> insertarOperacion(Nota nota) async{
    Database db = await _openDB();
    db.insert('notas', nota.toMap());
    notifyListeners();
  }

  static Future<void> actualizarOperacion(Nota nota) async {
    Database db = await _openDB();
    await db.update('notas', nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
    notifyListeners(); // notifica cambios
  }

  static Future eliminarOperacion(Nota nota) async {
    Database db = await _openDB();
    db.delete('notas', where: 'id = ?', whereArgs: [nota.id]);
    notifyListeners();
  }

  static Future<List<Nota>> obtenerNotas() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> notasMaps = await db.query('notas');

    return List.generate(notasMaps.length, (i) {
      return Nota(
      id: notasMaps [i]['id'],
      titulo: notasMaps[i]['titulo'], 
      descripcion: notasMaps [i]['descripcion'],
      );
    });
  }
}