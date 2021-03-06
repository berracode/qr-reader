

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async{
    if(_database!=null)return _database;
    _database = await initDb();

    return _database;
  }

  Future<Database> initDb() async{

    //ruta de donde almacenamos la bd
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,'ScansDB.db');
    print(path);

    return await openDatabase(
        path,
      readOnly: false,
      version: 2,
      onOpen: (db){},
      onCreate: (Database db, int version)async{
          await db.execute('''
          CREATE TABLE SCANS(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          );
          ''');
      }
    );

  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async{
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor =nuevoScan.valor;

    final db = await database;
    final res = await db.rawInsert(
      '''
      INSERT INTO Scans(id, tipo, valor)
      VALUES($id, '$tipo', '$valor')
      '''
    );

    return res;

  }

  //fforma optima de insertar
  Future<int> nuevoScan(ScanModel nuevoScan) async{


    final db = await database;
    final respuesta = await db.insert('Scans', nuevoScan.toJson());
    print('NUMERO EXTRAÑO: $respuesta');
    return respuesta;//id del ultimo registro insertado

  }

  Future<ScanModel> getScanById(int id) async{
    final db = await database;
    final respuesta = await db.query('Scans', where:'id=?', whereArgs: [id]);

    return respuesta.isNotEmpty
        ? ScanModel.fromJson(respuesta.first)
        : null;
  }

  Future<List<ScanModel>> getTodosScans() async{
    final db = await database;
    final respuesta = await db.query('Scans');

    return respuesta.isNotEmpty
        ? respuesta.map((e) => ScanModel.fromJson(e)).toList()
        : [];
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async{
    final db = await database;
    final respuesta = await db.rawQuery('''
    SELECT * FROM Scans WHERE tipo ='$tipo'
    ''');

    return respuesta.isNotEmpty
        ? respuesta.map((e) => ScanModel.fromJson(e)).toList()
        : [];
  }


  Future<int> eliminarTodos() async{


    final db = await database;
    final respuesta = await db.delete('Scans');
    print('NUMERO EXTRAÑO 2: $respuesta');
    return respuesta;

  }


}

