// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:minhasnotas/extensoes/lista/filtro.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;
// import 'crud_excecoes.dart';

// class ServicoNotas {
//   Database? _db;

//   List<DatabaseNota> _notas = [];

//   DatabaseUsuario? _usuario;

//   static final ServicoNotas _shared = ServicoNotas._instanciaDividida();
//   ServicoNotas._instanciaDividida() {
//     _notasStreamController = StreamController<List<DatabaseNota>>.broadcast(
//       onListen: () {
//         _notasStreamController.sink.add(_notas);
//       },
//     );
//   }
//   factory ServicoNotas() => _shared;

//   late final StreamController<List<DatabaseNota>> _notasStreamController;

//   Stream<List<DatabaseNota>> get todasAsNotas =>
//       _notasStreamController.stream.filter((nota) {
//         final currentUser = _usuario;
//         if (currentUser != null) {
//           return nota.usuarioId == currentUser.id;
//         } else {
//           throw UsuarioDeveriaSerDefinidoAntesDeLerTodasAsNotas();
//         }
//       });

//   Future<DatabaseUsuario> pegaOuCriaUsuario({
//     required String email,
//     bool defineComoUsuarioAtual = true,
//   }) async {
//     try {
//       final usuario = await pegaUsuario(email: email);
//       if (defineComoUsuarioAtual) {
//         _usuario = usuario;
//       }
//       return usuario;
//     } on NaoEncontrouUsuario {
//       final criadoUsuario = await criarUsuario(email: email);
//       if (defineComoUsuarioAtual) {
//         _usuario = criadoUsuario;
//       }
//       return criadoUsuario;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotas() async {
//     final todasNotas = await pegaTodasAsNotas();
//     _notas = todasNotas.toList();
//     _notasStreamController.add(_notas);
//   }

//   Future<DatabaseNota> updateNota({
//     required DatabaseNota nota,
//     required String texto,
//   }) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     // ter certeza que a nota existe
//     await pegaNota(id: nota.id);
//     // update DB
//     final updatesContador = await db.update(
//       notasTabela,
//       {
//         textoColuna: texto,
//         estaSincronizadoComNuvemColuna: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [nota.id],
//     );

//     if (updatesContador == 0) {
//       throw NaoConseguiuAtualizarNota();
//     } else {
//       final updateNota = await pegaNota(id: nota.id);
//       _notas.removeWhere((nota) => nota.id == updateNota.id);
//       _notas.add(updateNota);
//       _notasStreamController.add(_notas);
//       return updateNota;
//     }
//   }

//   Future<Iterable<DatabaseNota>> pegaTodasAsNotas() async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final notas = await db.query(notasTabela);

//     return notas.map((notasLinha) => DatabaseNota.deLinha(notasLinha));
//   }

//   Future<DatabaseNota> pegaNota({required int id}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final notas = await db.query(
//       notasTabela,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notas.isEmpty) {
//       throw NaoEncontrouNota();
//     } else {
//       final nota = DatabaseNota.deLinha(notas.first);
//       _notas.removeWhere((nota) => nota.id == id);
//       _notas.add(nota);
//       _notasStreamController.add(_notas);
//       return nota;
//     }
//   }

//   Future<int> deletarTodasAsNotas() async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final numeroDeDelecoes = await db.delete(notasTabela);
//     _notas = [];
//     _notasStreamController.add(_notas);
//     return numeroDeDelecoes;
//   }

//   Future<void> deletaNota({required int id}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final deletadaConta = await db.delete(
//       notasTabela,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletadaConta == 0) {
//       throw NaoConseguiuDeletarNota();
//     } else {
//       _notas.removeWhere((nota) => nota.id == id);
//       _notasStreamController.add(_notas);
//     }
//   }

//   Future<DatabaseNota> criarNota({required DatabaseUsuario owner}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();

//     // tenha certeza que o dono existe no database com o id correto
//     final dbUsuario = await pegaUsuario(email: owner.email);
//     if (dbUsuario != owner) {
//       throw NaoEncontrouUsuario();
//     }

//     const texto = '';
//     // criar a nota
//     final notaId = await db.insert(notasTabela, {
//       usuarioIdColuna: owner.id,
//       textoColuna: texto,
//       estaSincronizadoComNuvemColuna: 1,
//     });

//     final nota = DatabaseNota(
//       id: notaId,
//       usuarioId: owner.id,
//       texto: texto,
//       estaSincadoComNuvem: true,
//     );

//     _notas.add(nota);
//     _notasStreamController.add(_notas);

//     return nota;
//   }

//   Future<DatabaseUsuario> pegaUsuario({required String email}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();

//     final resultados = await db.query(
//       usuarioTabela,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (resultados.isEmpty) {
//       throw NaoEncontrouUsuario();
//     } else {
//       return DatabaseUsuario.deLinha(resultados.first);
//     }
//   }

//   Future<DatabaseUsuario> criarUsuario({required String email}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final resultados = await db.query(
//       usuarioTabela,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (resultados.isNotEmpty) {
//       throw UsuarioJaExiste();
//     }

//     final usuarioId = await db.insert(usuarioTabela, {
//       emailColuna: email.toLowerCase(),
//     });

//     return DatabaseUsuario(
//       id: usuarioId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _garantirDbAberto();
//     final db = _pegaDatabaseOuJoga();
//     final deletadaConta = await db.delete(
//       usuarioTabela,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletadaConta != 1) {
//       throw NaoConseguiuDeletarUsuario();
//     }
//   }

//   Database _pegaDatabaseOuJoga() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNaoAberto();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNaoAberto();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _garantirDbAberto() async {
//     try {
//       await open();
//     } on DatabaseJaAbertoExcecao {
//       //vazio
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseJaAbertoExcecao();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbNome);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // criar a tabela de usuário
//       await db.execute(criarTabelaUsuario);
//       // criar tabela de nota
//       await db.execute(criarTabelaNota);
//       await _cacheNotas();
//     } on MissingPlatformDirectoryException {
//       throw IncapazDePegarDiretorioDocumentos();
//     }
//   }
// }

// @immutable
// class DatabaseUsuario {
//   final int id;
//   final String email;
//   const DatabaseUsuario({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUsuario.deLinha(Map<String, Object?> map)
//       : id = map[idColuna] as int,
//         email = map[emailColuna] as String;

//   @override
//   String toString() => 'Pessoa, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUsuario other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNota {
//   final int id;
//   final int usuarioId;
//   final String texto;
//   final bool estaSincadoComNuvem;

//   DatabaseNota({
//     required this.id,
//     required this.usuarioId,
//     required this.texto,
//     required this.estaSincadoComNuvem,
//   });

//   DatabaseNota.deLinha(Map<String, Object?> map)
//       : id = map[idColuna] as int,
//         usuarioId = map[usuarioIdColuna] as int,
//         texto = map[textoColuna] as String,
//         estaSincadoComNuvem =
//             (map[estaSincronizadoComNuvemColuna] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Nota, ID = $id, usuarioId = $usuarioId, estaSincadoComNuvem = $estaSincadoComNuvem, texto = $texto';

//   @override
//   bool operator ==(covariant DatabaseUsuario other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbNome = 'notas.db';
// const notasTabela = 'nota';
// const usuarioTabela = 'usuario';
// const idColuna = 'id';
// const emailColuna = 'email';
// const usuarioIdColuna = 'usuario_id';
// const textoColuna = 'texto';
// const estaSincronizadoComNuvemColuna = 'esta_sincronizado_com_a_nuvem';
// const criarTabelaUsuario = '''CREATE TABLE IF NOT EXISTS "usuario" (
// 	      "id"	INTEGER NOT NULL,
// 	      "email"	TEXT NOT NULL UNIQUE,
// 	      PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
// const criarTabelaNota = '''CREATE TABLE IF NOT EXISTS "nota" (
// 	      "id"	INTEGER NOT NULL,
// 	      "usuario_id"	INTEGER NOT NULL,
// 	      "texto"	TEXT,
// 	      "esta_sincronizado_com_a_nuvem"	INTEGER NOT NULL DEFAULT 0,
// 	      FOREIGN KEY("usuario_id") REFERENCES "usuario"("id"),
// 	      PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
