import 'package:aloc_salas_frontend/models/disponivel.dart';
import 'package:flutter/material.dart';

class HorarioSala {
  final String horario;
  String sala;

  HorarioSala({
    @required this.horario,
    @required this.sala,
  });
}

class ItemAlocacao {
  final String idTurma;
  final List<HorarioSala> horarios;
  ItemAlocacao({
    @required this.idTurma,
    @required this.horarios,
  });
}

class Alocacao {
  final String id;
  final double taxaDesocupacao;
  final List<ItemAlocacao> alocacao;
  Map<String, List<Disponivel>> salasDisponiveis;

  Alocacao({
    @required this.id,
    @required this.taxaDesocupacao,
    @required this.alocacao,
    this.salasDisponiveis,
  });
}
