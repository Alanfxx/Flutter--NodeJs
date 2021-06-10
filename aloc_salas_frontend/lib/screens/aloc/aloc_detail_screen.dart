import 'package:aloc_salas_frontend/models/alocacao.dart';
import 'package:aloc_salas_frontend/models/aloc_item_aloc.dart';
import 'package:aloc_salas_frontend/models/class.dart';
import 'package:aloc_salas_frontend/providers/alocs.dart';
import 'package:aloc_salas_frontend/providers/classes.dart';
import 'package:aloc_salas_frontend/providers/classrooms.dart';
import 'package:aloc_salas_frontend/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlocDetailScreen extends StatefulWidget {
  @override
  _AlocDetailScreenState createState() => _AlocDetailScreenState();
}

class _AlocDetailScreenState extends State<AlocDetailScreen> {
  Alocs alocs;
  Classes classes;
  Alocacao aloc;
  Classrooms classrooms;
  List<ItemAlocacao> alocacao;
  List<ItemAlocacao> alocacoesFiltradas;
  // String filtro;

  @override
  void didChangeDependencies() async {
    aloc = ModalRoute.of(context).settings.arguments as Alocacao;
    alocacao = aloc.alocacao;
    alocacoesFiltradas = aloc.alocacao;
    classes = Provider.of<Classes>(context);
    alocs = Provider.of<Alocs>(context);
    classrooms = Provider.of<Classrooms>(context);
    super.didChangeDependencies();
  }

  updateFiltroAloc(String filtro) {
    setState(() {
      filtro = filtro.toLowerCase();
      alocacoesFiltradas = alocacao
          .where((item) => classes
              .getById(item.idTurma)
              .disciplina
              .toLowerCase()
              .contains(filtro))
          .toList();
    });
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
        title: Text('Detalhe Alocação'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    enableSuggestions: true,
                    onChanged: (value) {
                      updateFiltroAloc(value);
                    },
                  ),
                ),
                Icon(Icons.search),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: alocacoesFiltradas.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: ListTile(
                      title: Text(
                          'Turma: ${classes.getById(alocacoesFiltradas[index].idTurma).disciplina}'),
                      subtitle: Text(
                          'Alunos matriculados: ${classes.getById(alocacoesFiltradas[index].idTurma).numero_alunos}'),
                      trailing: Text(
                          'Taxa: ${taxaTurma(classes.getById(alocacoesFiltradas[index].idTurma), alocacoesFiltradas[index]).toStringAsFixed(4)}'),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.HORARIOS_SCREEN,
                          arguments:
                              AlocItemAloc(aloc, alocacoesFiltradas[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
