import 'package:aloc_salas_frontend/models/alocacao.dart';
import 'package:aloc_salas_frontend/models/class.dart';
import 'package:aloc_salas_frontend/models/disponivel.dart';
import 'package:aloc_salas_frontend/models/aloc_item_aloc.dart';
import 'package:aloc_salas_frontend/providers/alocs.dart';
import 'package:aloc_salas_frontend/providers/classes.dart';
import 'package:aloc_salas_frontend/providers/classrooms.dart';
import 'package:aloc_salas_frontend/widgets/horario_sala_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HorariosScreen extends StatefulWidget {
  @override
  _HorariosScreenState createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  AlocItemAloc alocItemAloc;
  Alocs alocs;
  Classrooms classrooms;
  Alocacao aloc;
  ItemAlocacao itemAloc;
  List<Disponivel> salasDisp;
  Class turma;
  bool loading = false;

  @override
  void didChangeDependencies() {
    alocItemAloc = ModalRoute.of(context).settings.arguments as AlocItemAloc;
    itemAloc = alocItemAloc.itemAloc;
    alocs = Provider.of<Alocs>(context);
    aloc = alocItemAloc.aloc;
    turma =
        Provider.of<Classes>(context, listen: false).getById(itemAloc.idTurma);
    salasDisp = aloc.salasDisponiveis[turma.id];
    classrooms = Provider.of<Classrooms>(context);
    super.didChangeDependencies();
  }

  void aplicarMudancas(horario, sala) {
    setState(() {
      loading = true;
    });
    aloc.alocacao
        .firstWhere((item) => item.idTurma == itemAloc.idTurma)
        .horarios
        .firstWhere((hor) => hor.horario == horario)
        .sala = sala;
    alocs.updateAlocacao(aloc).then((value) {
      setState(() {
        loading = false;
        // print(alocs.items[0].id);
        salasDisp = alocs.getById(aloc.id).salasDisponiveis[itemAloc.idTurma];
      });
    });
    // .then((value) => Navigator.of(context).pop());
  }

  double taxaTurma(Class turma, ItemAlocacao itemAlocacao) {
    double taxa = 0;
    itemAlocacao.horarios.forEach((horarioSala) {
      int tamnhoSala = classrooms.getById(horarioSala.sala).numero_cadeiras;
      taxa += (tamnhoSala - turma.numero_alunos) / tamnhoSala;
    });

    return taxa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Horarios alocados'),
      ),
      body: Container(
        height: 600,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turma:   ${turma.disciplina}',
                style: TextStyle(fontSize: 16)),
            Text('Curso:   ${turma.curso}', style: TextStyle(fontSize: 16)),
            Text('Professor:   ${turma.professor}',
                style: TextStyle(fontSize: 16)),
            Text('Periodo:   ${turma.periodo}', style: TextStyle(fontSize: 16)),
            Text('N. alunos:   ${turma.numero_alunos}',
                style: TextStyle(fontSize: 16)),
            const Divider(),
            const SizedBox(height: 10),
            Text('Taxa:   ${taxaTurma(turma, itemAloc)}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            !loading
                ? Container(
                    height: 400,
                    child: Column(
                      children: itemAloc.horarios
                          .map(
                            (horario) => HorarioSalaItem(
                              horarioSala: horario,
                              salasDisp: salasDisp,
                              aplicarMudancas: aplicarMudancas,
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Container(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
          ],
        ),
      ),
    );
  }
}
