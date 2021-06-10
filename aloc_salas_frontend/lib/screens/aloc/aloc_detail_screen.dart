import 'package:aloc_salas_frontend/models/alocacao.dart';
import 'package:aloc_salas_frontend/models/aloc_item_aloc.dart';
import 'package:aloc_salas_frontend/providers/alocs.dart';
import 'package:aloc_salas_frontend/providers/classes.dart';
import 'package:aloc_salas_frontend/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlocDetailScreen extends StatefulWidget {
  @override
  _AlocDetailScreenState createState() => _AlocDetailScreenState();
}

class _AlocDetailScreenState extends State<AlocDetailScreen> {
  Alocs alocs;
  Alocacao aloc;
  List<ItemAlocacao> listAloc;
  Classes classes;

  @override
  void didChangeDependencies() async {
    aloc = ModalRoute.of(context).settings.arguments as Alocacao;
    listAloc = aloc.alocacao;
    classes = Provider.of<Classes>(context);
    alocs = Provider.of<Alocs>(context);
    // await alocs.loadSalasDisponiveis(classes.items, aloc);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detalhe Alocação'),
      ),
      body: ListView.builder(
        itemCount: aloc.alocacao.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: ListTile(
              title: Text(
                  'Turma: ${classes.items.singleWhere((el) => el.id == listAloc[index].idTurma).disciplina}'),
              subtitle: Text(
                  'Alunos matriculados: ${classes.items.singleWhere((el) => el.id == listAloc[index].idTurma).numero_alunos}'),
              trailing: Icon(Icons.search),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.HORARIOS_SCREEN,
                  arguments: AlocItemAloc(aloc, listAloc[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
