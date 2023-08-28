import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';
import 'package:zense_project/database.dart';


class EditAccount extends StatefulWidget {
  
    String accountId;
    String accountName;
   EditAccount(this.accountId,this.accountName,{Key? key}) : super(key: key){}
   

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {

  late Stream<QuerySnapshot> IncomeStream;

  final _formkey = GlobalKey<FormState>();
    
    String account_name = '';
    int account_money=0;


    void deleteLinkedIncomes(String? uid,QuerySnapshot? snapshot) {

      List<Map> IncomeIds = [];
      List<String> IdsToDelete = [];
          // if (snapshot.hasData){
          //   QuerySnapshot data = snapshot.data!;
          //   List<QueryDocumentSnapshot> documents = data.docs;
          //   IncomeIds = documents.map((e) => {
          //   'id': e.id,
          //   'name': e['name'],
          //   'money': e['money']
          // }).toList();
          // }

      if (snapshot != null && snapshot.docs.isNotEmpty) {
            IncomeIds = snapshot.docs.map((e) => {
              'id': e.id,
              'name': e['name'],
              'money': e['money']
            }).toList();

      }
          
          //print(IncomeIds);
          
          IncomeIds.forEach((element) {
            //print(element);
           //print(widget.accountName);
            if (element['name'] == widget.accountName){
              IdsToDelete.add(element['id']);
            }
          });
          IdsToDelete.forEach((element) async {
            //print(element);
            await FirebaseFirestore.instance.collection('profiles').doc(uid).collection('Incomes').doc(element).delete();            
          });
               
  
    }

  @override
  Widget build(BuildContext context) {
    

    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    CollectionReference _incomeReference = _documentReference.collection('Incomes');
    DocumentReference _specificaccount = _accountReference.doc(widget.accountId);

    IncomeStream = _incomeReference.snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: IncomeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update account: ',style: TextStyle(fontSize: 20),
                    ),
                    
                            SizedBox(height: 10,),
                            TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Enter current amount";
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
                                  hintText: 'Current amount(Rs.) in this account',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Update',
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
    
                                        if (_formkey.currentState!.validate()) {
    
    
    
                                          Map<String,dynamic> toEdit = {'money':account_money,'name':widget.accountName};
                                          //print(toEdit);
                                          _specificaccount.set(toEdit);
    
                                          //_accountReference.add(toAdd);
                                          Navigator.of(context).pop();
    
                                          // await DatabaseService(uid: user.uid).setAccountDetails(context,account_name,account_money);
                                          }
                                        
                                      },
                                      icon: const Icon(Icons.arrow_forward_rounded)),
                                )
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextButton(
                              onPressed: (){
                                _specificaccount.delete();
                                deleteLinkedIncomes(user.uid,snapshot.data!);
                                Navigator.of(context).pop();
                              }, 
                              child: Text('DELETE ACCOUNT',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))
    
    
                  ],
                )
              );
      }
    );
  }
}