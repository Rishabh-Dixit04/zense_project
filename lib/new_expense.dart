import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> AccountStream;
  
    String account_name = '';
    int amount=0;
    String? current_account;
    String? category;
    String? reason;
    DateTime? pickeddate;
    List<String> categories = ['Food/Drinks','Transportation','Medical','Recreation','Bills','Shopping','Housing','Vehicle','Misc.'];
    TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    CollectionReference _expensesReference = _documentReference.collection('Expenses');
    AccountStream = _accountReference.snapshots();


    Future<void> changeAccountAmount(String? accountName, int amount,Map<String,dynamic> toAdd) async {
    
    QuerySnapshot snapshot = await _accountReference.get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (var doc in documents) {
      if (doc['name'] == accountName) {
        int currentMoney = doc['money'];
        int newMoney = currentMoney - amount;
        

        if (amount<=currentMoney){
          _expensesReference.add(toAdd);
          _accountReference.doc(doc.id).update({'money': newMoney});
        }
        else{
          DisplayAlertMessage();
        }
        
        break; // Assuming account names are unique, we can exit the loop
      }
    }
  }

    

    
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add New Expense',style: TextStyle(fontSize: 20)),
            SizedBox(height: 20,),
            Dropdownforaccounts(),
            SizedBox(height: 10,),
            TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter amount";
                                  }
                                  int? parsedValue = int.tryParse(val);
                                  if (parsedValue == null || parsedValue <= 0) {
                                    return "Enter a valid amount (> Rs.0)";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    amount = int.tryParse(val) ?? 0;
                                  });
                                },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Amount(Rs.)',
                                labelText: 'Amount(Rs.)',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 10,),
                  Dropdownforcategory(),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _date,
                    decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'Select date',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                    onTap: () async{
                      FocusScope.of(context).unfocus();
                      DateTime? pickeddate = await showDatePicker(context:  context 
                      , initialDate: DateTime.now()
                      , firstDate: DateTime(2000)
                      , lastDate: DateTime.now());
                      if (pickeddate!=null){
                        setState((){
                          _date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                            validator: (val) => val!.isEmpty ? "Enter reason" : null,
                            onChanged: (val){
                              setState(() => reason = val);
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Reason',
                                labelText: 'Reason',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 30,),

                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.lightGreen,
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: () async{

                                    if (_formkey.currentState!.validate()){

                                      Map<String,dynamic> toAdd = {'account':current_account,'amount':amount,'category':category,'reason':reason,'date':_date.text};
                                      //print(toAdd);
                                      
                                      changeAccountAmount(current_account,amount,toAdd);
                                      Navigator.of(context).pop();

                                      // await DatabaseService(uid: user.uid).setAccountDetails(context,account_name,account_money);
                                      }
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),
      
          ],
        
        ),
      )
    
    );


  }


  Widget Dropdownforaccounts(){
    
    return StreamBuilder(
      stream: AccountStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        List<Map> items = [];
        List<String> accountNames = [];
        if (snapshot.hasData){
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
              'id': e.id,
              'name': e['name'],
              'money': e['money']
            }).toList();
        }

      accountNames =  items.map((element) => element['name'] as String).toList();
        
        return DropdownButtonFormField<String>(
          hint: Text('Select account'),
          items: accountNames.map((e){
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (val) => setState(() => current_account = val),
          value: current_account,
        );
      }
    
    );
  }
  Widget Dropdownforcategory(){
        
        return DropdownButtonFormField<String>(
          hint: Text('Select category'),
          items: categories.map((e){
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (val) => setState(() => category = val),
          value: category,
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
                Text('Insufficient balance in this account.'),
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