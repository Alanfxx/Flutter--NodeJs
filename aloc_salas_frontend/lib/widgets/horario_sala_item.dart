import 'package:aloc_salas_frontend/models/alocacao.dart';
import 'package:aloc_salas_frontend/models/classroom.dart';
import 'package:aloc_salas_frontend/models/disponivel.dart';
import 'package:aloc_salas_frontend/models/room.dart';
import 'package:aloc_salas_frontend/providers/classrooms.dart';
import 'package:aloc_salas_frontend/widgets/classrooms_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HorarioSalaItem extends StatefulWidget {
  final HorarioSala horarioSala;
  final List<Disponivel> salasDisp;
  final Function aplicarMudancas;

  HorarioSalaItem({
    @required this.horarioSala,
    @required this.salasDisp,
    @required this.aplicarMudancas,
  });

  @override
  _HorarioSalaItemState createState() => _HorarioSalaItemState();
}

class _HorarioSalaItemState extends State<HorarioSalaItem> {
  Room _room;
  List<Room> _listClassrooms;
  Classrooms classrooms;
  Classroom sala;

  onchanged(room) {
    setState(() {
      _room = room;
    });
  }

  List<Room> criarLista() {
    List<Room> list = [];
    widget.salasDisp.forEach((e) {
      if (e.horario == widget.horarioSala.horario)
        list.add(Room(
            name:
                '${classrooms.getById(e.sala).id_sala} - ${classrooms.getById(e.sala).numero_cadeiras}',
            salaId: e.sala));
    });
    return list;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      classrooms = Provider.of<Classrooms>(context);
      sala = classrooms.getById(widget.horarioSala.sala);
      _listClassrooms = criarLista();
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HorarioSalaItem oldWidget) {
    setState(() {
      _listClassrooms = criarLista();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print('build HorarioSalaItem');

    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.horarioSala.horario}'),
              Text('${sala.id_sala} - ${sala.numero_cadeiras}'),
              if (widget.salasDisp != null)
                Row(
                  children: [
                    ClassroomsDropDown(onchanged, _listClassrooms),
                    if (_room != null)
                      IconButton(
                          onPressed: () {
                            widget.aplicarMudancas(
                                widget.horarioSala.horario, _room.salaId);
                          },
                          icon: Icon(Icons.cached))
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
