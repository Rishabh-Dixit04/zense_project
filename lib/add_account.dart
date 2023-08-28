import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

        

class _NewAccountState extends State<NewAccount> {
  final _formkey = GlobalKey<FormState>();
  
    String account_name = '';
    int account_money=0;
  @override
  Widget build(BuildContext context) {


    
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text(
                  'Add new account: ',style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20,),
                TextFormField(
                          validator: (val) => val!.isEmpty ? "Enter account name" : null,
                          onChanged: (val){
                            setState(() => account_name = val);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Account name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
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

                                      Map<String,dynamic> toAdd = {'money':account_money,'name':account_name};
                                      //print(toAdd);
                                      _accountReference.add(toAdd);
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
}