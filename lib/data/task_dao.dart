import 'package:flutter/material.dart';
import 'package:primeiro_projeto/components/task.dart';
import 'package:primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT, '
      '$_level INTEGER)';

  static const String _tableName = 'taskTable';
  static const String _name = 'nome';
  static const String _difficulty = 'dificuldade';
  static const String _image = 'imagem';
  static const String _level = 'nivel';

  save(Task tarefa) async {
    print('Acessando o save');
    final Database bancoDeDados = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      print('A tarefa não existia');
      return await bancoDeDados.insert(_tableName, taskMap);
    } else {
      print('A tarefa já existia');
      return await bancoDeDados.update(_tableName, taskMap,
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }
  }

  updateLevel(Task tarefa) async {
    print('Update');
    final Database bancoDeDados = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);

    print('Atualizar Tarefa');
    return await bancoDeDados.update(_tableName, taskMap,
        where: '$_name = ?', whereArgs: [tarefa.nome]);
  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('Convertendo to Map');
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    mapaDeTarefas[_level] = tarefa.nivel;
    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll...');
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result =
        await bancoDeDados.query(_tableName);
    print('Procurando dados no banco de dadaos... Encontrados $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    print('Convertendo em to List');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa =
          Task(linha[_name], linha[_image], linha[_difficulty], linha[_level]);
      tarefas.add(tarefa);
    }
    print('Lista de tarefas $tarefas');
    return tarefas;
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando Find:');
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tableName,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
    print('Tarefa econtrada: ${toList(result)}');
    return toList(result);
  }

  delete(String nomeDaTarefa) async {
    print('Deletando tarefa: $nomeDaTarefa');
    final Database bancoDeDados = await getDatabase();
    return bancoDeDados
        .delete(_tableName, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
  }
}
