import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class NewPayDue extends StatefulWidget {
  const NewPayDue({super.key});

  @override
  State<NewPayDue> createState() => _NewPayDueState();
}

class _NewPayDueState extends State<NewPayDue> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> PayDuesStream;
   
    int amount=0;
    String remark = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _payDuesReference = _documentReference.collection('PayDues');
    PayDuesStream = _payDuesReference.snapshots();
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add New Amount',style: TextStyle(fontSize: 20)),
            SizedBox(height: 20,),
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
                  
                  TextFormField(
                            validator: (val) => val!.isEmpty ? "Enter remark" : null,
                            onChanged: (val){
                              setState(() => remark = val);
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Remark',
                                labelText: 'Remark',
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

                                      Map<String,dynamic> toAdd = {'amount':amount,'remark':remark};
                                      //print(toAdd);
                                      _payDuesReference.add(toAdd);
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

}