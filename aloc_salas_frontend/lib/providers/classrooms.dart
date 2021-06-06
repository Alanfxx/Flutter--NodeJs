import 'package:aloc_salas_frontend/models/classroom.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Classrooms with ChangeNotifier {
  List<Classroom> _items = [];

  List<Classroom> get items {
    return [..._items];
  }

  lerCSV({@required int cenario}) async {
    var d = new FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    final myData =
        await rootBundle.loadString("assets/csv/cenario$cenario-salas.csv");
    List<List<dynamic>> rowsAsListOfValues =
        CsvToListConverter(csvSettingsDetector: d).convert(myData);
    List<Classroom> classrooms = [];
    rowsAsListOfValues.forEach((el) {
      if (el[0] != 'id_sala') {
        classrooms.add(Classroom(
            id_sala: el[0],
            numero_cadeiras: el[1],
            acessivel: el[2],
            qualidade: el[3]));
      }
    });
    _items = classrooms;
    notifyListeners();
  }
}
