import 'dart:convert';

import 'package:app_reports/src/models/report_model.dart';
import 'package:app_reports/src/utils/global_util.dart';
import 'package:flutter/foundation.dart';

class ReportProvider  extends ChangeNotifier{

  final List<Reports> _listReports = [];

  List<Reports> get listReports => _listReports;

  set addReport(Reports value){
    _listReports.add(value);
    notifyListeners();
  }

  set updateReport(Reports report){
    _listReports[_listReports.indexWhere((e) => e.id == report.id)] = report;
    notifyListeners();
  }

  set deleteReport(Reports report){
    _listReports.removeWhere((e) => e.id == report.id);
    notifyListeners();
  }

  set setListReports(List<Reports> value){
    _listReports.addAll(value);
    notifyListeners();
  }

  Future<void> addReportInStorage(Reports newReport) async {
    List<Reports> temp = [];
    final String str = await readStorage();
    if(str.isNotEmpty){
      final List<dynamic> response = jsonDecode(str);
      temp = response.map((e) => Reports.fromJson(e)).toList();
      temp.add(newReport);
    }
    await writeStorage(data: jsonEncode(temp));
  }

  Future<void> updateReportInStorage(Reports report) async {
    List<Reports> temp = [];
    final String str = await readStorage();
    if(str.isNotEmpty){
      final List<dynamic> response = jsonDecode(str);
      temp = response.map((e) => Reports.fromJson(e)).toList();
      temp[temp.indexWhere((e) => e.id == report.id)] = report;
    }
    await writeStorage(data: jsonEncode(temp));
  }

  Future<void> deleteReportInStorage(Reports report) async {
    List<Reports> temp = [];
    final String str = await readStorage();
    if(str.isNotEmpty){
      final List<dynamic> response = jsonDecode(str);
      temp = response.map((e) => Reports.fromJson(e)).toList();
      temp.removeWhere((element) => element.id == report.id);
    }
    await writeStorage(data: jsonEncode(temp));
  }
}