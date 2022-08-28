import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_reports/src/models/report_model.dart';
import 'package:app_reports/src/utils/constants.dart';
import 'package:app_reports/src/utils/global_util.dart';
import 'package:app_reports/src/providers/report_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({Key? key}) : super(key: key);

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  late final reportProvider = Provider.of<ReportProvider>(context, listen: true);
  List<Reports> _reports = [];

  Future<List<Reports>> getListReport () async {
    _reports = reportProvider.listReports;

    if(_reports.isEmpty){
      final str = await readStorage();
      if(str.isNotEmpty){
        final List<dynamic> response = jsonDecode(str);
        _reports = response.map((e) => Reports.fromJson(e)).toList();
        reportProvider.setListReports = _reports;
      }
    }

    return _reports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.blue, title: const Text('LIST REPORTS'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: getListReport(),
            builder: (BuildContext context, AsyncSnapshot<List<Reports>> snapshot) {
              if(!snapshot.hasData){
                return const CircularProgressIndicator(color: Colors.blue);
              }

              if(snapshot.hasData){
                if(_reports.isEmpty){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.info_outline_rounded, size: 30, color: Colors.blue),
                      Text('NO DATA'),
                    ],
                  );
                }

                return CardReport(reports: _reports);
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class CardReport extends StatelessWidget {
  const CardReport({
    Key? key,
    required List<Reports> reports,
  }) : _reports = reports, super(key: key);

  final List<Reports> _reports;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _reports.map<Container>((Reports item) {
        return Container(
          width: kWidth,
          padding: kPadding12,
          margin: kPadding9,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: kRadius9
          ),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'edit', arguments: item),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.reportTitle, style: const TextStyle(color: Colors.black, fontFamily: 'Roboto-Bold', fontSize: 18)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: kRadius9,
                  child: Image.file(
                    File(item.reportImg),
                    height: 200,
                    width: kWidth,
                    fit: BoxFit.cover
                  )
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}