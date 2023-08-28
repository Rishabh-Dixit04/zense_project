import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/new_expense.dart';
import 'package:zense_project/user.dart';

class MyExpenses extends StatefulWidget {
  const MyExpenses({super.key});

  @override
  State<MyExpenses> createState() => _MyExpensesState();
}

class _MyExpensesState extends State<MyExpenses> {
  late Stream<QuerySnapshot> ExpenseStream;
  @override
  Widget build(BuildContext context) {

    void addNewExpense(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewExpense()
        );
      });
    }

    final user = Provider.of<User>(context);
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _expensesreference = _documentReference.collection('Expenses');
    ExpenseStream = _expensesreference.snapshots();


    return StreamBuilder(
      stream: ExpenseStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

        List<Map> items = [];
        if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
              'id': e.id,
              'account': e['account'],
              'category': e['category'],
              'date':e['date'],
              'reason':e['reason'],
              'amount':e['amount']
            }).toList();
        }
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Text('Your Expenses',style: TextStyle(fontSize: 30),)
                    ,SizedBox(width: 15,),
                    Tooltip(message: 'Add New Expense',child: CircleAvatar(child: IconButton(onPressed: () => addNewExpense()
                            
                            , icon: Icon(Icons.add,size: 15,),color: Colors.black),radius: 15,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                    
                  ],
                ),
                SizedBox(height: 20,),
                ExpensesList(items)
              ],
            ),
          ),
        );
      }
    
    );
  }

  Widget ExpensesList(List<Map> items){

    items.sort((e1,e2) => e1['date'].compareTo(e2['date']));
    items =items.reversed.toList();
    print(items);
    
    
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var element in items)
           Container(
                color: Colors.amber.shade200,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(20),
                // decoration: BoxDecoration(
                //   border: Border.all(color: const Color.fromARGB(255, 204, 169, 64))),
                child: Text('You paid Rs.'+element['amount'].toString()+' through '+element['account']+' on '+element['date'].toString()+'\n\n'+'Category: '+element['category']+'\n'+'Reason: '+element['reason'],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
            ),
          
        ],
      ),
    );
  }
}