import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';
import 'package:intl/intl.dart';
class NewSubscriptionPayment extends StatefulWidget {
  Map element;
  NewSubscriptionPayment(this.element,{Key? key}) : super(key: key){}

  @override
  State<NewSubscriptionPayment> createState() => _NewSubscriptionPaymentState();
}

class _NewSubscriptionPaymentState extends State<NewSubscriptionPayment> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> AccountStream;
  
    String account_name = '';
    int amount=0;
    String? current_account;
    // String? category;
    // String? reason;
    // DateTime? pickeddate;
    // List<String> categories = ['Food/Drinks','Transportation','Medical','Recreation','Bills','Shopping','Housing','Vehicle','Misc.'];
    // TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _accountReference = _documentReference.collection('Accounts');
    CollectionReference _subscriptionsReference = _documentReference.collection('Subscriptions');
    AccountStream = _accountReference.snapshots();


    Future<void> changeAccountAmount(String? accountName, int amount) async {
    
    QuerySnapshot snapshot = await _accountReference.get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (var doc in documents) {
      if (doc['name'] == accountName) {
        int currentMoney = doc['money'];
        int newMoney = currentMoney - amount;
        

        if (amount<=currentMoney){
          _subscriptionsReference.doc(widget.element['id']).update({'paid':true,'start_date':DateFormat('yyyy-MM-dd').format(DateTime.now())});
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
            Text('Make Subscription Payment',style: TextStyle(fontSize: 20)),
            SizedBox(height: 20,),
            Dropdownforaccounts(),
            
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Pay',
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

                                      //Map<String,dynamic> toAdd = {'account':current_account,'amount':amount,'category':category,'reason':reason,'date':_date.text};
                                      //print(toAdd);
                                      
                                      changeAccountAmount(current_account,widget.element['amount']);
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