import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/add_income.dart';
import 'package:zense_project/changeIncomes.dart';
import 'package:zense_project/user.dart';

class EditIncome extends StatefulWidget {
  const EditIncome({super.key});

  @override
  State<EditIncome> createState() => _EditIncomeState();
  
}

class _EditIncomeState extends State<EditIncome> {
  late Stream<QuerySnapshot> IncomeStream;
  final _formkey = GlobalKey<FormState>();

  void edit_income(String incId,String incomeName){
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: Edit_Income(incId,incomeName)
        );
      });
    }
  @override
  Widget build(BuildContext context) {

    


    void addNewIncome(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewIncome()
        );
      });
    }

    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _incomeReference = _documentReference.collection('Incomes');

    IncomeStream = _incomeReference.snapshots();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              
              children: [
                SizedBox(width: 50,),
                Text('Edit income details:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                SizedBox(width: 10,),
                Tooltip(message: 'Add New Income',child: CircleAvatar(child: IconButton(onPressed: () => addNewIncome()
                          
                          , icon: Icon(Icons.add,size: 15,),color: Colors.black),radius: 15,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
              ],
            ),
            SizedBox(height: 20,),
            MyIncomes()
          ],
        )
      ],
    );
  }

  Widget MyIncomes(){
    return StreamBuilder(
      stream: IncomeStream,
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
              //scrollDirection: Axis.horizontal,
              child: Center(
                child: Column(  
                                
                  children: items.map((account) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => edit_income(account['id'],account['name']), //editAccount(account['id'],account['name']),
                        child: Column(children: [
                        Center(child: Text(account['name'].toString(),style: TextStyle(fontSize: 50,color:Colors.black),)),
                        Center(child: Text("Rs. "+account['money'].toString(),style: TextStyle(fontStyle:FontStyle.italic,fontSize: 30,color:Colors.green),)),
                      ])
                       //Text("\t \t"+account['name'].toString() + "\n Rs." + account['money'].toString(),style: TextStyle(fontSize: 30),),
                      ,style: ElevatedButton.styleFrom(primary: Colors.amber[300]),
                  
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
              
            );
  }
}