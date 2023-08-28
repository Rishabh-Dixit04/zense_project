import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';
import 'package:intl/intl.dart';


class NewSubscription extends StatefulWidget {
  const NewSubscription({super.key});

  @override
  State<NewSubscription> createState() => _NewSubscriptionState();
}

class _NewSubscriptionState extends State<NewSubscription> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> SubscriptionStream;
   String name = '';
    int amount=0;
    String frequency = '';
    DateTime? pickeddate;
    TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _subscriptionsReference = _documentReference.collection('Subscriptions');
    SubscriptionStream = _subscriptionsReference.snapshots();
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add New Subscription',style: TextStyle(fontSize: 20)),
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
                  TextField(
                    controller: _date,
                    decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'Select start date',
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
                            validator: (val) => val!.isEmpty ? "Enter name" : null,
                            onChanged: (val){
                              setState(() => name = val);
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Subscription Name',
                                labelText: 'Subscription Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                  SizedBox(height: 10,),
                  TextFormField(
                            validator: (val) => (val!="Daily" && val!="Monthly" && val!="Yearly" ) ? "Daily/Monthly/Yearly" : null,
                            onChanged: (val){
                              setState(() => frequency = val);
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Frequency',
                                labelText: 'Frequency',
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

                                      Map<String,dynamic> toAdd = {'amount':amount,'name':name,'frequency':frequency,'start_date':_date.text,'paid':false};
                                      //print(toAdd);
                                      _subscriptionsReference.add(toAdd);
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