import 'package:client/src/project/data/project_model.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  int runButton = 0;
  Project? _project;

  Project? get project => _project;

  void setProject(Project project) {
    _project = project;
    notifyListeners();
  }

  void setrunBtn(int runButton1) {
    runButton = runButton1;
    notifyListeners();
  }
}
