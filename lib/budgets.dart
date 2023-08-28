import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:zense_project/app_users.dart';
import 'package:zense_project/detail_tile.dart';
import 'package:zense_project/new_budget.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/database.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';
import 'package:zense_project/user_content.dart';

class Budgets extends StatefulWidget {
  const Budgets({super.key});

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {

    void deleteBudget(String docId,String? uid) async{
      await FirebaseFirestore.instance.collection('profiles').doc(uid).collection('Budgets').doc(docId).delete();
    }


    void addNewBudget(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewBudget()
        );
      });
    }

  late Stream<QuerySnapshot> BudgetStream;
  late Stream<QuerySnapshot> ExpenseStream;
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    if (user!=null){
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _budgetsReference = _documentReference.collection('Budgets');
    BudgetStream = _budgetsReference.snapshots();
    CollectionReference _expensesReference = _documentReference.collection('Expenses');
    ExpenseStream = _expensesReference.snapshots();

    

    return StreamBuilder(
      stream: BudgetStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        List<Map> items = [];
        if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
              'id': e.id,
              'category': e['category'],
              'start_date':e['start_date'],
              'end_date':e['end_date'],
              'target':e['target']
            }).toList();
        }

        return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/home_background.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text("PennySaver",style: TextStyle(color: Colors.blue),),
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    TextButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text('Logout'),
                      
                      onPressed: () async {
                              await _auth.signOut();
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SplashScreen())); 
                          }
                    )
                  ],
                ),
                body: Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                  child: 
                    SingleChildScrollView(
                      child: Column(
                        
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            children: [
                               SizedBox(width: 130,),
                              Text("Budgets",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.amber,fontSize: 40,fontWeight: FontWeight.bold),),
                              SizedBox(width: 40,),
                              Tooltip(message: 'Add New Budget',child: CircleAvatar(child: IconButton(onPressed: () => addNewBudget(), icon: Icon(Icons.add),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                            ],
                          ),
                          SizedBox(height: 20,),
                          BudgetList(items,user.uid),
                        ],
                      ),
                    )
                  
                )
              )
      );
      }
      
    );
      
              
    }
    return Container();
      
  }

  Widget BudgetList(List<Map> items,String? uid){
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var element in items)
           Container(
                color: Colors.cyan[50],
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Category: '+element['category']+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    Text('Start Date: '+element['start_date'],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    Text('End_Date: '+element['end_date']+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    Text('Target: Rs.'+element['target'].toString(),style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    showProgressBar(element['category'],element['start_date'],element['end_date'],element['target'] as int),
                    TextButton(onPressed: () => deleteBudget(element['id'],uid), child: Text('DELETE BUDGET',style: TextStyle(color: Colors.red,fontSize: 15),),)
                  ],
                )
            ),
          
        ],
      ),
    );
  }

  Widget showProgressBar(String category,String start_date,String end_date,int target){
    return StreamBuilder(
      stream: ExpenseStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
         List<Map> items = [];
        if (snapshot.hasData){
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
            'id': e.id,
            'account': e['account'],
            'amount': e['amount'],
            'category': e['category'],
            'date': e['date'],
            'reason': e['reason'],
          }).toList();
        }

        int progress = 0;
        for (var element in items){
          if (category == element['category']){
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

            List<String> dateParts3 = element['date'].split("-");
            int year3 = int.parse(dateParts3[0]);
            int month3 = int.parse(dateParts3[1]);
            int day3 = int.parse(dateParts3[2]);
            DateTime dateTime3 = DateTime(year3, month3, day3);
            if (dateTime1.isAfter(dateTime3) || dateTime2.isBefore(dateTime3)){
            }else{
              
              progress += (element['amount'] as int);
            }
          }
        }
        Color pointerColor = Colors.green;
        String textToBeShown='';
        if (progress > target) {
          pointerColor = Colors.red;
          textToBeShown = "Over the limit!";
        }
        return SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: target.toDouble(),
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.3,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                          color: pointerColor,
                          value: progress.toDouble(),
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                          positionFactor: 0.1,
                          angle: 90,
                          widget: Column(
                            children: [
                              SizedBox(height: 120,),
                              Text(
                              progress.toStringAsFixed(2) + ' / ${target.toDouble()}',
                              style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 10,),
                              Text(
                              textToBeShown,
                              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                          ]
                          ),
                     
                    ]);
      }
    
    );
  }
}

