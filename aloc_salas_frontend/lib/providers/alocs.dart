import 'dart:convert';

import 'package:aloc_salas_frontend/models/alocacao.dart';
// import 'package:aloc_salas_frontend/models/class.dart';
import 'package:aloc_salas_frontend/models/disponivel.dart';
import 'package:aloc_salas_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alocs with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/alocacao';
  List<Alocacao> _items = [];
  // Map<String, List<Disponivel>> _salasDisponiveis = new Map();
  // List<Disponivel> salasDisponiveisOf(String id) => _salasDisponiveis[id];

  Alocs() {
    loadAlocacoes();
  }

  List<Alocacao> get items => [..._items];

  int get countItems => _items.length;

  Alocacao getById(String id) {
    return _items.singleWhere((el) => el.id == id);
  }

  List<ItemAlocacao> transformarAlocacao(Map<String, dynamic> aloc) {
    List<ItemAlocacao> list = [];
    aloc.forEach((key, value) {
      List<HorarioSala> listHorarios = [];
      value.forEach((k, v) {
        listHorarios.add(new HorarioSala(horario: k, sala: v));
      });
      list.add(new ItemAlocacao(idTurma: key, horarios: listHorarios));
    });
    return list;
  }

  Map<String, dynamic> toJson(List<ItemAlocacao> aloc) {
    Map<String, dynamic> map = {};
    aloc.forEach((itemAloc) {
      Map<String, String> horarios = {};
      itemAloc.horarios.forEach((horarioSala) {
        horarios[horarioSala.horario] = horarioSala.sala;
      });
      map[itemAloc.idTurma] = horarios;
    });
    return map;
  }

  Future<void> loadAlocacoes() async {
    final response = await http.get("$_baseUrl");
    List<dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      await data.forEach((alocData) async {
        Alocacao aloc = new Alocacao(
          id: alocData['id'],
          taxaDesocupacao: alocData['taxaDesocupacao'],
          alocacao: transformarAlocacao(alocData['alocacao']),
        );
        aloc.salasDisponiveis = await loadSalasDisponiveis(aloc);
        _items.add(aloc);
        notifyListeners();
      });
      print('loadAlocacoes');
    }
    return Future.value();
  }

  Future<Map<String, List<Disponivel>>> loadSalasDisponiveis(
      Alocacao aloc) async {
    Map<String, List<Disponivel>> disponiveis = new Map();
    await aloc.alocacao.forEach((alocItem) async {
      List<Disponivel> list;
      await getDisponiveis(alocItem.idTurma, aloc.alocacao)
          .then((value) => list = value);
      disponiveis[alocItem.idTurma] = list;
    });
    print('loadSalasDisponiveis');
    return Future.value(disponiveis);
  }

  Future<void> updateAlocacao(Alocacao alocacao) async {
    final response = await http.put(
      "$_baseUrl/${alocacao.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(toJson(alocacao.alocacao)),
    );
    print('updateAlocacao');
    await loadAlocacoes();
    if (response.statusCode >= 400) {
      print(response.body);
    }
  }

  Future<void> deleteAlocacao(String id) async {
    final index = _items.indexWhere((aloc) => aloc.id == id);
    if (index >= 0) {
      final aloc = _items[index];
      _items.remove(aloc);
      notifyListeners();
      final response = await http.delete("$_baseUrl/${aloc.id}");

      if (response.statusCode >= 400) {
        _items.insert(index, aloc);
        notifyListeners();
      }
    }
    print('deleteAlocacao');
  }

  Future<List<Disponivel>> getDisponiveis(
      String idTurma, List<ItemAlocacao> aloc) async {
    List<Disponivel> list = [];
    final response = await http.post(
      '${Constants.BASE_API_URL}/salas-disponiveis/$idTurma',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(toJson(aloc)),
    );
    Map<String, dynamic> data = json.decode(response.body);
    data.forEach((key, value) {
      list.add(Disponivel(horario: value[0], sala: value[1]));
    });
    return Future.value(list);
  }

  Future<void> run() async {
    final response = await http.get(
      '${Constants.BASE_API_URL}/run',
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
    );
    print('Alocacao status: ${response.statusCode}');
    await loadAlocacoes();
    // return Future.value();
  }
}

  // Future<void> addAlocacao(Alocacao newAlocacao) async {
  //   final response = await http.post(
  //     "$_baseUrl",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode(toJson(newAlocacao.alocacao)),
  //   );
  //   _items.add(Alocacao(
  //     id: response.body,
  //     alocacao: newAlocacao.alocacao,
  //   ));
  //   notifyListeners();
  // }