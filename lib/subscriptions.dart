import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/new_subscription.dart';
import 'package:zense_project/new_subscription_payment.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/user.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {

  void deleteSubscription(String docId,String? uid) async{
      await FirebaseFirestore.instance.collection('profiles').doc(uid).collection('Subscriptions').doc(docId).delete();
    }

  void addNewSubscription(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewSubscription()
        );
      });
    }

    void makeSubscriptionPayment(Map element){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewSubscriptionPayment(element)
        );
      });
    }


  late Stream<QuerySnapshot> SubscriptionStream;
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    if (user!=null){
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _subscriptionsReference = _documentReference.collection('Subscriptions');
    SubscriptionStream = _subscriptionsReference.snapshots();
    return StreamBuilder(
      stream: SubscriptionStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        List<Map> items = [];
        if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data!;
          List<QueryDocumentSnapshot> documents = data.docs;
          items = documents.map((e) => {
              'id': e.id,
              'name': e['name'],
              'start_date':e['start_date'],
              'frequency':e['frequency'],
              'amount':e['amount'],
              'paid':e['paid']
            }).toList();
        }

        return Container(
          // padding: EdgeInsets.only(left: 10,right: 10),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/home_background.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text("PennySaver",style: TextStyle(color: Colors.blue),),
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    TextButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text('Logout'),
                      
                      onPressed: () async {
                              await _auth.signOut();
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SplashScreen()));                          
      
                            // var sharedPref = await SharedPreferences.getInstance();
                            // sharedPref.setBool(KEYLOGIN, false);
                            // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SplashScreen()));
                          }
                    )
                  ],
                ),
                body: Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: 
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              SizedBox(width: 75,),
                              Text("Subscriptions",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.amber,fontSize: 40,fontWeight: FontWeight.bold),),
                              SizedBox(width: 10,),
                              Tooltip(message: 'Add New Subscription',child: CircleAvatar(child: IconButton(onPressed: () => addNewSubscription(), icon: Icon(Icons.add),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                            ],
                          ),
                          SizedBox(height: 20,),
                          SubscriptionList(items,user.uid),
                        ],
                      ),
                    )
                  
                )
              )
      );
      }
      
    );
      
              
            
      
  }
  return Container();


}
  Widget SubscriptionList(List<Map> items,String? uid){

    // return StreamBuilder(
      
    //   stream: SubscriptionStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){



         return SingleChildScrollView(
            child: Column(
              children: [
                for (var element in items)               


                Container(
                      color: Colors.cyan[50],
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('Name: '+element['name']+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                          Text('Start Date: '+element['start_date'],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),                    
                          Text('Frequency: '+element['frequency']+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                          Text('Amount: Rs.'+element['amount'].toString(),style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                          TextButton(onPressed: () => deleteSubscription(element['id'],uid), child: Text('DELETE SUBSCRIPTION',style: TextStyle(color: Colors.red,fontSize: 15),),),
                          checkForPay(element)
                        ],
                      )
                  ),
                
              ],
            ),
          );

    //   }
    
    // );

     }

     Widget checkForPay(Map element){
      final user = Provider.of<User>(context);
      DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
      CollectionReference _subscriptionsReference = _documentReference.collection('Subscriptions');
      List<String> dateParts = element['start_date'].split("-");
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);
      DateTime dateTime = DateTime(year, month, day);
      int difference = DateTime.now().difference(dateTime).inDays;
      int gap=0;
      if (element['frequency']=='Daily'){
        gap = 1;
      }
      else if (element['frequency']=='Monthly'){
        gap = 30;
      }
      else if (element['frequency']=='Yearly'){
        gap = 365;
      }
      bool paid=element['paid'];
      if (difference >= gap && paid == false){
        return showPayButton(element);
      }
      else if (difference !=gap && paid == true){
        _subscriptionsReference.doc(element['id']).update({'paid':false});
      }
      return Container();

     }

     Widget showPayButton(Map element){

      return ElevatedButton(onPressed: (){
        makeSubscriptionPayment(element);

      },
      
      child: Text('Pay Now'));

      
     }
  

}
