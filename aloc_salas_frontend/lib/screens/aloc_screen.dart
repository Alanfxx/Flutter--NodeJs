import 'package:aloc_salas_frontend/providers/alocs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlocScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alocs = Provider.of<Alocs>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Alocação'),
      ),
      body: Text(alocs.countItems.toString()),
    );
  }
}
