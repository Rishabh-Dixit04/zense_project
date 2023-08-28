import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class NewIncome extends StatefulWidget {
  const NewIncome({super.key});

  @override
  State<NewIncome> createState() => _NewIncomeState();
}

class _NewIncomeState extends State<NewIncome> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> AccountStream;
  
    String account_name = '';
    int account_money=0;
    String? current_account;
  @override
  Widget build(BuildContext context) {


    
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    CollectionReference _incomeReference = _documentReference.collection('Incomes');
    AccountStream = _accountReference.snapshots();
    return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text(
                  'Add new income: ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20,),

                Dropdownforaccounts(),
                // TextFormField(
                //           validator: (val) => val!.isEmpty ? "Enter account name" : null,
                //           onChanged: (val){
                //             setState(() => account_name = val);
                //           },
                //           decoration: InputDecoration(
                //               fillColor: Colors.white,
                //               filled: true,
                //               hintText: 'Account name',
                //               border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.circular(10))),
                //         ),
                        SizedBox(height: 10,),
                        TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter income";
                                }
                                int? parsedValue = int.tryParse(val);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return "Enter a valid amount (> Rs.0)";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  account_money = int.tryParse(val) ?? 0;
                                });
                              },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Income(Rs.)',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 30),
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

                                      Map<String,dynamic> toAdd = {'money':account_money,'name':current_account,'paid':false};
                                      //print(toAdd);
                                      _incomeReference.add(toAdd);
                                      Navigator.of(context).pop();

                                      // await DatabaseService(uid: user.uid).setAccountDetails(context,account_name,account_money);
                                      }
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),


              ],
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
}