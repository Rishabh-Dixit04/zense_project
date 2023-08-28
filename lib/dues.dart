import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/new_collectDue.dart';
import 'package:zense_project/new_collect_due_receive.dart';
import 'package:zense_project/new_payDue.dart';
import 'package:zense_project/new_payDue_payment.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/user.dart';

class MyDues extends StatefulWidget {
  const MyDues({super.key});

  @override
  State<MyDues> createState() => _MyDuesState();
}

class _MyDuesState extends State<MyDues> {
  late Stream<QuerySnapshot> PayDuesStream;
  late Stream<QuerySnapshot> CollectDuesStream;
  final AuthService _auth=AuthService();


    void PayPayDue(Map element){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewPayDuePayment(element)
        );
      });
    }

     void CollectCollectDue(Map element){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewCollectDueReceive(element)
        );
      });
    }

   void addNewPayDue(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewPayDue()
        );
      });
    }

    void deleteCollectDue(String docId,String? uid) async{
      await FirebaseFirestore.instance.collection('profiles').doc(uid).collection('CollectDues').doc(docId).delete();
    }

   void addNewCollectDue(){
      
      showModalBottomSheet(context: context, builder: (context){
        
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: NewCollectDue()
        );
      });
    }
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    if (user!=null){
    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _payDuesReference = _documentReference.collection('PayDues');    
    CollectionReference _collectDuesReference = _documentReference.collection('CollectDues');
    PayDuesStream = _payDuesReference.snapshots();
    CollectDuesStream = _collectDuesReference.snapshots();
      
          

            return Container(
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
                      child: SingleChildScrollView(
                        child: Column(
                          
                          children: [
                      
                            StreamBuilder(
                            stream: PayDuesStream,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              List<Map> items = [];
                              if (snapshot.hasData) {
                                QuerySnapshot data = snapshot.data!;
                                List<QueryDocumentSnapshot> documents = data.docs;
                                items = documents.map((e) => {
                                    'id': e.id,
                                    'amount':e['amount'],
                                    'remark':e['remark'],
                                  }).toList();
                              }
                              return  Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      SizedBox(width: 100,),
                                      Text("Dues To Pay",style: TextStyle(color: Colors.amber,fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 70,),
                                      Tooltip(message: 'Add New Amount',child: CircleAvatar(child: IconButton(onPressed: () => addNewPayDue(), icon: Icon(Icons.add),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  PayDueList(items,user.uid),
                                ],
                              );
                            }
                            ),
                    
                            const Divider(
                              //height: 300,
                              thickness: 5,
                              //indent: 20,
                              endIndent: 0,
                              color: Colors.black,
                            ),
                      
                      
                                StreamBuilder(
                            stream: CollectDuesStream,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              List<Map> items = [];
                              if (snapshot.hasData) {
                                QuerySnapshot data = snapshot.data!;
                                List<QueryDocumentSnapshot> documents = data.docs;
                                items = documents.map((e) => {
                                    'id': e.id,
                                    'amount':e['amount'],
                                    'remark':e['remark'],
                                  }).toList();
                              }
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 100,),
                                      Text("Dues to Collect",style: TextStyle(color: Colors.amber,fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 30,),
                                      Tooltip(message: 'Add New Amount',child: CircleAvatar(child: IconButton(onPressed: () => addNewCollectDue(), icon: Icon(Icons.add),color: Colors.black),radius: 20,backgroundColor: Color.fromARGB(255, 196, 104, 97)))
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  CollectDueList(items,user.uid),
                                ],
                              );
                            
                            }
                            )
                      
                      
                      
                      
                      
                            
                          ],
                        ),
                      ),
                    )
                  )
          );
        
    }
    return Container();
      
  }

  Widget PayDueList(List<Map> items,String? uid){
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
                    Text('Amount: Rs.'+element['amount'].toString()+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    Text('Remark: '+element['remark'],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),                    
                    TextButton(onPressed: () => PayPayDue(element), child: Text('Pay Now',style: TextStyle(color: Colors.red,fontSize: 15),),)
                  ],
                )
            ),
          
        ],
      ),
    );
  }

  Widget CollectDueList(List<Map> items,String? uid){
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
                    Text('Amount: Rs.'+element['amount'].toString()+'\n',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                    Text('Remark: '+element['remark'],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),                    
                    TextButton(onPressed: () => CollectCollectDue(element), child: Text('COLLECT NOW',style: TextStyle(color: Colors.green,fontSize: 15),),)
                  ],
                )
            ),
          
        ],
      ),
    );
  }

}
