import 'package:aloc_salas_frontend/providers/classes.dart';
import 'package:aloc_salas_frontend/providers/classrooms.dart';
import 'package:aloc_salas_frontend/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classrooms = Provider.of<Classrooms>(context);
    final classes = Provider.of<Classes>(context);
    classrooms.loadClassrooms();
    classes.loadClasses();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Alocacao de Turmas'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CLASS_SCREEN);
              },
              child: Text('Turmas'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CLASSROOM_SCREEN);
              },
              child: Text('Salas'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.ALOC_SCREEN);
              },
              child: Text('Alocação'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
