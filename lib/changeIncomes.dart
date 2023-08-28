import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class Edit_Income extends StatefulWidget {
  String incId;
  String incomeName;
  Edit_Income(this.incId,this.incomeName,{Key? key}) : super(key: key){}

  @override
  State<Edit_Income> createState() => _Edit_IncomeState();
}

class _Edit_IncomeState extends State<Edit_Income> {

  late Stream<QuerySnapshot> IncomeStream;

  final _formkey = GlobalKey<FormState>();
  String account_name = '';
    int account_money=0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _incomeReference = _documentReference.collection('Incomes');
    DocumentReference _specificincome = _incomeReference.doc(widget.incId);
    IncomeStream = _incomeReference.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: IncomeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update income: ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
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
                                  hintText: 'Income(Rs.)',
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
    
    
    
                                          Map<String,dynamic> toEdit = {'money':account_money};
                                          //print(toEdit);
                                          _specificincome.update(toEdit);
    
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
                                _specificincome.delete();
                                Navigator.of(context).pop();
                              }, 
                              child: Text('DELETE INCOME',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))
    
    
                  ],
                )
              );
      }
    );
  }
}