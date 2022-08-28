import 'dart:io';

import 'package:app_reports/src/models/report_model.dart';
import 'package:app_reports/src/providers/report_service.dart';
import 'package:app_reports/src/utils/constants.dart';
import 'package:app_reports/src/utils/global_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({Key? key}) : super(key: key);

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  late final reportProvider = Provider.of<ReportProvider>(context, listen: false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dataAddReport = Reports(reportTitle: '', reportImg: '', id: '');
  final ImagePicker _picker = ImagePicker();
  XFile? _imgReport;
  bool isEdit = false;
  bool isLoaded = true;

  Future<void> saveReportInStorage() async {
    FocusManager.instance.primaryFocus?.unfocus();
//     await deleteStorage();
// return;
    if(!_formKey.currentState!.validate()) return;
    if(_dataAddReport.reportImg.isEmpty) return showSnackBar(context: context, message: 'Should select an image');
    if(!isEdit){
      _dataAddReport.id = DateTime.now().millisecondsSinceEpoch.toString();
      await reportProvider.addReportInStorage(_dataAddReport);
      reportProvider.addReport = _dataAddReport;
      return showSnackBar(context: context, message: '¡Repord added!');
    }
    // UPDATE REPORT
    reportProvider.updateReport = _dataAddReport;
    await reportProvider.updateReportInStorage(_dataAddReport);
    return showSnackBar(context: context, message: '¡Repord update!');
  }

  takePhotoCamera(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white10,
          height: 170,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    _imgReport = await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);
                    if(_imgReport != null){
                      setState(() => _dataAddReport.reportImg = _imgReport!.path);
                    }
                  },
                  title: const Text('Open camera', style: TextStyle(fontWeight: FontWeight.w500 , color: kColorBackdrop)),
                  trailing: const Icon(Icons.camera_alt_rounded, color: kColorBackdrop,size: 27,),
                ),
                const Divider(indent: 18, endIndent: 18, height: 8, color: kColorBackdrop),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    _imgReport = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
                    if(_imgReport != null){
                      setState(() => _dataAddReport.reportImg = _imgReport!.path);
                    }
                  },
                  title: const Text('Open gallery', style: TextStyle(fontWeight: FontWeight.w500 , color: kColorBackdrop),),
                  trailing: const Icon(Icons.photo_library_rounded, color: kColorBackdrop,size: 27,),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    if(ModalRoute.of(context)!.settings.arguments != null && isLoaded) {
      final Reports paramReport = ModalRoute.of(context)!.settings.arguments as Reports;
      isEdit = true;
      _dataAddReport.id = paramReport.id;
      _dataAddReport.reportImg = paramReport.reportImg;
      _dataAddReport.reportTitle = paramReport.reportTitle;
      isLoaded = false;
    }

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.blue, title: const Text('REPORTS APP'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? 'EDIT REPORT' : 'ADD REPORT',
                    style: const TextStyle(fontFamily: 'Roboto-Bold', fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black54),
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                          autocorrect: false,
                          onChanged: (value) => setState(() => _dataAddReport.reportTitle = value.trim()),
                          maxLength: 25,
                          initialValue: _dataAddReport.reportTitle,
                          decoration: decorationInput(),
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Enter a report title';
                            if(value.length <= 4) return 'Enter a valid title';
                            setState(() => _dataAddReport.reportTitle = value.trim());
                            return null;
                          },
                        ),
                        const SizedBox(height: 14,),
                        SizedBox(
                          width:kWidth,
                          height: 62,
                          child: OutlinedButton.icon(
                            onPressed: () => takePhotoCamera(),
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.black45,
                                width: 1
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                              enableFeedback: false
                            ),
                            icon: const Icon(Icons.add_a_photo_rounded, color: Colors.black45,),
                            label: Text(
                              _dataAddReport.reportImg.isEmpty ? 'Select an image' : 'Change image',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if(_dataAddReport.reportImg.isNotEmpty) AnimatedContainer(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: kRadius9
                          ),
                          width: kWidth,
                          height: 250,
                          duration:kDuration ,
                          child: Image.file(File( _dataAddReport.reportImg ), fit: BoxFit.cover,),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width:kWidth,
                          height: 62,
                          child: ElevatedButton(
                            onPressed: () {
                              saveReportInStorage().then((value) => isEdit ?  Navigator.pop(context): null);
                            },
                            style: ElevatedButton.styleFrom(
                              primary:  Colors.blueAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius:kRadius9),
                              enableFeedback: false
                            ),
                            child: Text(
                               isEdit ? 'Update' : 'Save',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        if(isEdit) const SizedBox(height:8),
                        if(isEdit) SizedBox(
                          width:kWidth,
                          height: 62,
                          child: OutlinedButton(
                            onPressed: () {
                              reportProvider.deleteReport = _dataAddReport;
                              reportProvider.deleteReportInStorage(_dataAddReport).then((value) => Navigator.pop(context));
                            },
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius:kRadius9),
                              enableFeedback: false
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration decorationInput() {
    return InputDecoration(
      labelText: 'Write a report title',
      counterText: "",
      focusColor: Colors.blue,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black45,
          width: 1
        ),
        borderRadius: kRadius9
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade400),
        borderRadius: kRadius9,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue.shade400,
          width: 2
        ),
        borderRadius: kRadius9
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1
        ),
        borderRadius: kRadius9
      ),
    );
  }
}