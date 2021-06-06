import 'package:aloc_salas_frontend/models/class.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Classes with ChangeNotifier {
  List<Class> _items = [];

  List<Class> get items {
    return [..._items];
  }

  lerCSV({@required int cenario}) async {
    var d = new FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    final myData =
        await rootBundle.loadString("assets/csv/cenario$cenario-turmas.csv");
    List<List<dynamic>> rowsAsListOfValues =
        CsvToListConverter(csvSettingsDetector: d).convert(myData);
    List<Class> classes = [];
    rowsAsListOfValues.forEach((el) {
      if (el[0] != 'disciplina') {
        classes.add(Class(
            disciplina: el[0],
            professor: el[1],
            dias_horario: el[2],
            numero_alunos: el[3],
            curso: el[4],
            periodo: el[5],
            acessibilidade: el[6],
            qualidade: el[7]));
      }
    });
    _items = classes;
    notifyListeners();
  }
}
