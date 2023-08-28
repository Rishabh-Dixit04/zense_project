import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zense_project/add_account.dart';
import 'package:zense_project/app_users.dart';
import 'package:zense_project/database.dart';
import 'package:zense_project/edit_account.dart';
import 'package:zense_project/edit_income.dart';
import 'package:zense_project/expenses.dart';
import 'package:zense_project/indicators.dart';
import 'package:zense_project/loading.dart';
import 'package:zense_project/pie_chart_sections.dart';
import 'package:zense_project/user.dart';
import 'package:zense_project/user_content.dart';
import 'package:provider/provider.dart';


class DetailTile extends StatefulWidget {
    DetailTile({Key? key}) : super(key: key){
    }

  @override
  State<DetailTile> createState() => _DetailTileState();
}

class _DetailTileState extends State<DetailTile> {
    late Stream<DocumentSnapshot> UserStream;

    late Stream<QuerySnapshot> AccountStream;
    late Stream<QuerySnapshot> IncomeStream;
    //late List<QueryDocumentSnapshot> documents;
  Future<void> updateAccountforIncome(Map<String,int> accountstoupdate,CollectionReference _accountReference) async {

    QuerySnapshot snapshot = await _accountReference.get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (var doc in documents){
      int newMoney = accountstoupdate[doc['name']]! + (doc['money'] as int);
      _accountReference.doc(doc.id).update({'money': newMoney});
    }
    // try {
    //   QuerySnapshot snapshot = await _accountReference.where('name', isEqualTo: accountName).get();
    //   List<QueryDocumentSnapshot> documents = snapshot.docs;

    //   for (var doc in documents) {
    //     int newMoney = amount + (doc['money'] as int);
    //     _accountReference.doc(doc.id).update({'money': newMoney});
    //     documents = (await _accountReference.where('name', isEqualTo: accountName).get()).docs;
    //   }
    // } catch (e) {
    //   print("Error updating account for income: $e");
    // }
  }












  
    void editAccount(String accountId,String account_name){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
            child: EditAccount(accountId,account_name)
          ),
        );
      });
    }
  TextEditingController _date1 = TextEditingController();
  TextEditingController _date2 = TextEditingController();
  bool _showChart = false;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    if (user!=null){
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    CollectionReference _incomeReference = _documentReference.collection('Incomes');

    UserStream = _documentReference.snapshots();
    AccountStream = _accountReference.snapshots();
    IncomeStream = _incomeReference.snapshots();


    

    void editIncome(){
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: EditIncome()
        );
      });
    }

    void addNewAccount(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewAccount()
        );
      });
    }

    void View_Expenses(){
      showModalBottomSheet(context: context, builder: (context){
        
        
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
            child: MyExpenses()
          ),
        );
      });

    }


    



    return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15,right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const SizedBox(height: 20),
                      DisplayUserName(),
                      //Text('Hi $Uname !',style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        
                        children: [
                          const Text('Your Accounts: ',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)),
                          SizedBox(width: 100),
                          Tooltip(message: 'Add New Account',child: CircleAvatar(child: IconButton(onPressed: () => addNewAccount()
                          
                          , icon: Icon(Icons.add),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                        ],
                      ),
                      const SizedBox(height: 30),
                      YourAccounts(),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       ElevatedButton.icon(onPressed: () {},
                      //        icon: Icon(Icons.house,size: 50,color: Colors.green,),
                      //        label: Text('$Uaccount',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                      //        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 50),

                    
                      Row(
                        children: [
                          const Text('Your Total Income: ',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)),
                          SizedBox(width: 60,),
                          Tooltip(message: 'Edit',child: CircleAvatar(child: IconButton(onPressed: () => editIncome()
                          
                          , icon: Icon(Icons.edit),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                        ],
                      ),
                      
                      TotalIncome(_incomeReference,_accountReference),
                     

                      const SizedBox(height: 50),
                      Row(
                        children: [
                          const Text('Expenses: ',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold)),
                          SizedBox(width: 100,),
                          ElevatedButton.icon(onPressed: ()=>View_Expenses(), icon: Icon(Icons.list), label: Text("View All"),
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 196, 104, 97))
                          
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Center(child: Text('Statistics:',style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 20,),
                      
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                                            controller: _date1,
                                            decoration: InputDecoration(
                                  
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Select start date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                            onTap: () async{
                                              await Future.delayed(Duration(milliseconds: 100));
                                              FocusScope.of(context).unfocus();
                                              DateTime? pickeddate = await showDatePicker(context:  context 
                                              , initialDate: DateTime.now()
                                              , firstDate: DateTime(2000)
                                              , lastDate: DateTime.now());
                                              if (pickeddate!=null){
                          
                                  setState(() {
                                    _date1.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                  });

                                              }
                                            },
                                          ),
                        ),
                  
                      ),
                    SizedBox(height: 10,),

                    Center(
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                                            controller: _date2,
                                            decoration: InputDecoration(
                                  
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Select end date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                            onTap: () async{
                                              await Future.delayed(Duration(milliseconds: 100));
                                              FocusScope.of(context).unfocus();
                                              DateTime? pickeddate = await showDatePicker(context:  context 
                                              , initialDate: DateTime.now()
                                              , firstDate: DateTime(2000)
                                              , lastDate: DateTime.now());
                                              if (pickeddate!=null){
                          
                         
                                setState(() {
                                  _date2.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                });

                                              }
                                            },
                                          ),
                        ),
                  
                      ),
                      
                      SizedBox(height: 10,),


                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Set',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.lightGreen,
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: () async{
                                    
                                    List<String> dateParts = _date1.text.split("-");
                                    int year = int.parse(dateParts[0]);
                                    int month = int.parse(dateParts[1]);
                                    int day = int.parse(dateParts[2]);
                                    DateTime dateTime1 = DateTime(year, month, day);

                                    
                                    List<String> dateParts2 = _date2.text.split("-");
                                    int year2 = int.parse(dateParts2[0]);
                                    int month2 = int.parse(dateParts2[1]);
                                    int day2 = int.parse(dateParts2[2]);
                                    DateTime dateTime2 = DateTime(year2, month2, day2);



                                    if (dateTime1.isAfter(dateTime2)){
                                      DisplayAlertMessage();
                                    }
                                    else{
                                      setState(() {
                                      _showChart = true;
                                    });
                                                                    

                                    }
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                            
                          ],
                        ),

                      ),
                      SizedBox(height: 40,),
                      Center(child: Text('Category-wise distribution of expenses:',style: TextStyle(color: Colors.white,fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10,),
                      
                      if (_showChart)
                        FutureBuilder<Widget>(
                          future: showPieChart(_date1.text, _date2.text, user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Center(
                                child: Container(
                                  height: 700,
                                  child: snapshot.data!,
                                ),
                              );
                            } else {
                              return SizedBox(); // Empty placeholder if no data
                            }
                          },
                        ),

                      

            ]),
                ),
              ),
            ]
          );



    }
    return Container();

    
  }

  




  Widget TotalIncome(CollectionReference _incomeReference,CollectionReference _accountReference){
    return StreamBuilder(
      stream: IncomeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        int total_income = 0;
        List<Map> items = [];
        Map<String,int> accountstoupdate = {};
         if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
              'id': e.id,
              'name': e['name'],
              'money': e['money'],
              'paid':e['paid']
            }).toList();
        }

        items.forEach((element)async {
                if (element['paid'] == false && DateTime.now().day == 1) {
                  String account_name = element['name'];
                  accountstoupdate[account_name] ??= 0;
                  accountstoupdate[account_name] = accountstoupdate[account_name]! + (element['money'] as int);
                  _incomeReference.doc(element['id']).update({'paid':true});

                  //updateAccountforIncome(account_name, acc, _accountReference)

                }
             
            // QuerySnapshot snapshot = await _accountReference.where('name', isEqualTo: element['name']).get();
            // List<QueryDocumentSnapshot> documents = snapshot.docs;

            // for (var doc in documents) {
            //   int newMoney = (element['money'] as int) + (doc['money'] as int);
            //   _accountReference.doc(doc.id).update({'money': newMoney});
            //   _incomeReference.doc(element['id']).update({'paid':true});
            // }
            //updateAccountforIncome(element['name'],element['money'] as int,_accountReference);
            
          
          else if (element['paid']==true && DateTime.now().day!=1){
            _incomeReference.doc(element['id']).update({'paid':false});
          }
          total_income += (element['money'] as int);
          updateAccountforIncome(accountstoupdate, _accountReference);
        });
        return Text("Rs. "+"$total_income",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold),);
        

      
      }
    
    );
  }


Future<Widget>? showPieChart(String start_date,String end_date,String? uid) async{
  List<PieChartSectionData>? dataList = await getSections(start_date,end_date,uid);
  //print(dataList);

  try{
    if (dataList!=null && dataList!=[]){

     return Container(
      height: 1000,
       child: Column(
         children: [
           Container(
            height: 400,
             child: PieChart(
                    PieChartData(
                      
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: dataList,
                    )
                  ),
           ),
           SizedBox(height: 20,),
           Container(
            child: Indicators(start_date,end_date,uid)
           )
         ]
       ),
     );}
  
     
  } 
  catch(e){
    print(e);
    
  }return Container();
  
  
}


  

 Widget DisplayUserName() {
  return StreamBuilder<DocumentSnapshot>(
    stream: UserStream,
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      String Uname = '';
      if (snapshot.hasData) {
        DocumentSnapshot data = snapshot.data!;
        Uname = data['name'] as String; // Make sure 'name' field is of type String
      }
      return Text('Hi $Uname!',style: TextStyle(color: Colors.amber,fontSize: 40,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),);
    },
  );
  }

  Widget YourAccounts(){
    return StreamBuilder(
      stream: AccountStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        List<Map> items = [];
        if (snapshot.hasData){
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
            'id': e.id,
            'name': e['name'],
            'money': e['money']
          }).toList();
        }

        return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items.map((account) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => editAccount(account['id'],account['name']),
                      child:
                      Column(children: [
                        Center(child: Text(account['name'].toString(),style: TextStyle(fontSize: 50,color:Colors.black),)),
                        Center(child: Text("Rs. "+account['money'].toString(),style: TextStyle(fontStyle:FontStyle.italic,fontSize: 30,color:Colors.green),)),
                      ])
                       //Text("\t \t"+account['name'].toString() + "\n Rs." + account['money'].toString(),style: TextStyle(fontSize: 30),),
                      ,style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
                    ),
                  );
                }).toList(),
              ),
            );
          }
              
            );
          }

  void DisplayAlertMessage(){
         showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('End date cannot be after start date.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
}
