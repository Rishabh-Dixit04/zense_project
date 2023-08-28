import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/pie_chart_data.dart';
import 'package:zense_project/user.dart';

Future<List<PieChartSectionData>?> getSections(String start_date,String end_date,String? uid) async {
  List<Data> data = await fetchData(uid, start_date, end_date);
  if (data!=null || data!=[]){
  return data.asMap().map<int,PieChartSectionData>((index,data){
  final value = PieChartSectionData(
    color: data.color,
    value: data.percent,
    title: '${data.percent}%',
    titleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black
    )
  );
  
  return MapEntry(index, value);
}).values.toList();
}
return [];
}

