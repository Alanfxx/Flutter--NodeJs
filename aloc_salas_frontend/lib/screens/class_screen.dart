import 'package:aloc_salas_frontend/providers/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classes = Provider.of<Classes>(context);
    classes.lerCSV(cenario: 1);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Turmas'),
        ),
        body: Container(
          // padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: classes.items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  title: Text(classes.items[index].disciplina),
                  trailing: Text(classes.items[index].dias_horario),
                ),
              );
            },
          ),
        ));
  }
}
