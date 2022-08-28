import 'dart:convert';

class Reports {
    Reports({
        required this.reportTitle,
        required this.reportImg,
        required this.id
    });

    String id;
    String reportTitle;
    String reportImg;

    factory Reports.fromJson(String str) => Reports.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Reports.fromMap(Map<String, dynamic> json) => Reports(
        reportTitle: json["report_title"],
        reportImg: json["report_img"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "report_title": reportTitle,
        "report_img": reportImg,
        "id": id,
    };
}
