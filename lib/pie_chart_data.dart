import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Data{
  final String? name;
  final double? percent;
  final Color? color;
  Data({this.name,this.percent,this.color});
}

Stream<QuerySnapshot> streamData(String? uid) {
  try {
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(uid);
    CollectionReference _expensesreference = _documentReference.collection('Expenses');

    // Return the stream of snapshots from the collection
    return _expensesreference.snapshots();
  } catch (error) {
    print('Error fetching data: $error');
    throw error; // Rethrow the error to be handled by the caller
  }
}


Future<List<Data>> fetchData(String? uid,String start_date,String end_date) async{
  List<String> categories = ['Food/Drinks','Transportation','Medical','Recreation','Bills','Shopping','Housing','Vehicle','Misc.'];
  var ExpensesList = [];
  Stream <QuerySnapshot> ExpenseStream = streamData(uid);
  
  // await ExpenseStream.forEach((QuerySnapshot snapshot) {
  // for (QueryDocumentSnapshot docsnapshot in snapshot.docs) {
  //   Object? items = docsnapshot.data();
  //   ExpensesList.add(items);
  // }
  // });
  //print(ExpensesList);
  try{
  await for (var snapshot in ExpenseStream) {
    bool allValuesStored = true;
    for (QueryDocumentSnapshot docsnapshot in snapshot.docs) {
    Object? items = docsnapshot.data();
    //print(items);
    ExpensesList.add(items);
    if (ExpensesList.length >= snapshot.docs.length) {
      allValuesStored = true; 
      break; 
    }
    }
    if (allValuesStored) {
    break; 
  }
  }
  }catch(e){
  print(e);
  }
  
  var total_amounts = [];
  var percents = [];
  for (String category in categories){ 
    int sum =0;
    for ( var item in ExpensesList){
      if (category == item['category']){
        List<String> dateParts = start_date.split("-");
        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);
        DateTime dateTime1 = DateTime(year, month, day);

        List<String> dateParts2 = end_date.split("-");
        int year2 = int.parse(dateParts2[0]);
        int month2 = int.parse(dateParts2[1]);
        int day2 = int.parse(dateParts2[2]);
        DateTime dateTime2 = DateTime(year2, month2, day2);

        List<String> dateParts3 = item['date'].split("-");
        int year3 = int.parse(dateParts3[0]);
        int month3 = int.parse(dateParts3[1]);
        int day3 = int.parse(dateParts3[2]);
        DateTime dateTime3 = DateTime(year3, month3, day3);

        if (dateTime1.isAfter(dateTime3) || dateTime2.isBefore(dateTime3)){
        }else{
          
          sum+=(item['amount'] as int);
        }
    
      }
      
    }
    
    total_amounts.add(sum);
    
  }
  double total_sum = 0;
  for (var item in total_amounts){
    total_sum+=item;
  }
  for (var item in total_amounts){
    percents.add(double.parse(((item/total_sum)*100).toStringAsFixed(2)));
  }
  List<Data> data = [
    Data(name: 'Food/Drinks',percent: percents[0],color: Colors.green),
    Data(name: 'Transportation',percent: percents[1],color: Colors.yellow),
    Data(name: 'Medical',percent: percents[2],color: Colors.red),
    Data(name: 'Recreation',percent: percents[3],color: Colors.brown),
    Data(name: 'Bills',percent: percents[4],color: Colors.purple),
    Data(name: 'Shopping',percent: percents[5],color: Colors.orange),
    Data(name: 'Housing',percent: percents[6],color: Colors.grey),
    Data(name: 'Vehicle',percent: percents[7],color: Colors.pink),
    Data(name: 'Misc.',percent: percents[8],color: Colors.cyan)
    
  ];
  

  return data;

}