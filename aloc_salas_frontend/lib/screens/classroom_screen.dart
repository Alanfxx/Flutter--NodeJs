import 'package:aloc_salas_frontend/providers/classrooms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassroomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classrooms = Provider.of<Classrooms>(context);
    classrooms.lerCSV(cenario: 1);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Salas'),
        ),
        body: Container(
          // padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: classrooms.items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  title: Text(classrooms.items[index].id_sala.toString()),
                  trailing:
                      Text(classrooms.items[index].numero_cadeiras.toString()),
                ),
              );
            },
          ),
        ));
  }
}
