import 'package:aloc_salas_frontend/providers/alocs.dart';
import 'package:aloc_salas_frontend/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlocScreen extends StatefulWidget {
  @override
  _AlocScreenState createState() => _AlocScreenState();
}

class _AlocScreenState extends State<AlocScreen> {
  Alocs alocs;
  bool loading = false;

  @override
  void didChangeDependencies() {
    alocs = Provider.of<Alocs>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final alocs = Provider.of<Alocs>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Alocações'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 40,
            width: 250,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: TextButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  alocs.run().then((value) => loading = false);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gerar uma alocação'),
                  SizedBox(width: 15),
                  loading
                      ? Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : Icon(Icons.run_circle_outlined)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: alocs.countItems,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.account_tree_outlined),
                    title: Text('ID: ${alocs.items[index].id}'),
                    subtitle: Text(
                        'Taxa Desocupação: ${alocs.items[index].taxaDesocupacao.toStringAsFixed(10)}'),
                    trailing: IconButton(
                      onPressed: () {
                        alocs.deleteAlocacao(alocs.items[index].id);
                      },
                      icon: Icon(Icons.delete_forever),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          AppRoutes.ALOC_DETAIL_SCREEN,
                          arguments: alocs.items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
