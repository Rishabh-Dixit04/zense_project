import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zense_project/app_users.dart';
import 'package:zense_project/user.dart';
import 'package:provider/provider.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference profiles =FirebaseFirestore.instance.collection('profiles');

  Future? updateUserData(String name, List accounts,List incomes) async{
    await profiles.doc(uid).set({
      'name': name
      
      // 'account':accounts,
      // 'income':incomes,
      // 'expenses':expenses,
      // 'subscriptions':subscriptions,
      // 'budgets':budgets,
      // 'payDues':payDues,
      // 'collectDues':collectDues

    });

    final CollectionReference Accounts =profiles.doc(uid).collection('Accounts');
    await profiles.doc(uid).collection('Accounts').doc().set({
      'name' : accounts[0],
      'money' : accounts[1]
    });
    final CollectionReference Incomes =profiles.doc(uid).collection('Incomes');
    await profiles.doc(uid).collection('Incomes').doc().set({
      'paid'  : false,
      'amount' : incomes[0],
      'account' : incomes[1]
    });
    // final CollectionReference Expenses =profiles.doc(uid).collection('Expenses');
    // await profiles.doc(uid).collection('Expenses').doc().set({
    //   'amount' : expenses[0],
    //   'category' : expenses[1],
    //   'reason' : expenses[2],
    //   'date' : expenses[3],
    //   'account' : expenses[4],

    // });
    // final CollectionReference Subscriptions =profiles.doc(uid).collection('Subscriptions');
    // await profiles.doc(uid).collection('Subscriptions').doc().set({
    //   'amount' : subscriptions[0],
    //   'start_date' : subscriptions[1],
    //   'frequency' : subscriptions[2]
    // });
    // final CollectionReference Budgets =profiles.doc(uid).collection('Budgets');
    // await profiles.doc(uid).collection('Budgets').doc().set({
    //   'category' : budgets[0],
    //   'target' : budgets[1],
    //   'month' : budgets[2]
    // });
    // final CollectionReference PayDues =profiles.doc(uid).collection('PayDues');
    // await profiles.doc(uid).collection('PayDues').doc().set({
    //   'amount' : payDues[0],
    //   'remark' : payDues[1]
    // });
    // final CollectionReference CollectDues =profiles.doc(uid).collection('CollectDues');
    // await profiles.doc(uid).collection('CollectDues').doc().set({
    //   'amount' : collectDues[0],
    //   'remark' : collectDues[1]
    // });


    
  }

  List <UserDetails> _detailsFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserDetails(
        name: doc.get('name') ?? '',
        accounts: doc.get('accounts') ?? [],
        incomes: doc.get('incomes') ?? [],
        expenses: doc.get('expenses') ?? [],
        subscriptions: doc.get('subscriptions') ?? [],
        budgets: doc.get('budgets') ?? [],
        payDues: doc.get('payDues') ?? [],
        collectDues: doc.get('collectDues') ?? []
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot['name'],
      accounts: snapshot['accounts'],
      incomes: snapshot['incomes'],
      expenses: snapshot['expenses'],
      subscriptions: snapshot['subscriptions'],
      budgets: snapshot['budgets'],
      payDues: snapshot['payDues'],
      collectDues: snapshot['collectDues'],
    );
  }

  Stream<List<UserDetails>> get details{
    return profiles.snapshots().map(_detailsFromSnapshot);
  }

  Stream <UserData> get userData {
    return profiles.doc(uid).snapshots().map(_userDataFromSnapshot);


  }

  

  Future? setUserName(String name) async {
    await profiles.doc(uid).set({
      'name': name
    });
  }




  Future<List<String>> getAccountIds(String? uid) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .collection('Accounts')
        .get();

    List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return documentIds;
  } catch (e) {
    print("Error getting subcollection document IDs: $e");
    return [];
  }
}


  Future? setAccountDetails(BuildContext context,String account_name,int account_money) async{
    List<String> accountIDs = await getAccountIds(uid);
    
    //print(accountIDs);
    String? accUid = accountIDs[0];
    await profiles.doc(uid).collection('Accounts').doc(accUid).set({
       'name' : account_name,
       'money' : account_money
     });
  }



  Future<List<String>> getIncomeIds(String? uid) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .collection('Incomes')
        .get();

    List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return documentIds;
  } catch (e) {
    print("Error getting subcollection document IDs: $e");
    return [];
  }
}


  Future? setIncomeDetails(BuildContext context,String account_name,int income) async{

    
    List<String> incomeIDs = await getIncomeIds(uid);
    String? incUid = incomeIDs[0];

    await profiles.doc(uid).collection('Incomes').doc(incUid).set({
       'name' : account_name,
       'money' : income,
       'paid' : false
     });
  }


  // Stream <AccountData> get userAccount {
  //   return profiles.doc(uid).snapshots().map(_userAccountDataFromSnapshot);
  // }

  // AccountData _userAccountDataFromSnapshot(DocumentSnapshot snapshot){
  //   return AccountData(
  //     accUid: 
  //   );
  // }

  // Future? setAccountDetails(BuildContext context, String account_name,int account_money) async{

  //   StreamBuilder<UserAccount>(
  //     stream: DatabaseService(uid: uid).userAccount,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData){
  //         UserAccount? userAccount = snapshot.data;
  //         String? Uname = userData!.name;
  //   final details = Provider.of<List<UserAccount>>(context);
  //   final accUid = details[0].accUid;
  //   await profiles.doc(uid).collection('Accounts').doc(accUid).set({
  //     'name' : account_name,
  //     'money' : account_money
  //   });
  //       }
  //     }
  //   );
  // }

//   Future<void> setAccountDetails(BuildContext context, String account_name, int account_money) async {
//   try {
//     final details = Provider.of<List<UserAccount>>(context);
    
//     if (details.isNotEmpty) {
//       final accUid = details[0].accUid;
      
//       // Fetch the account document from Firestore
//       final accountSnapshot = await profiles.doc(uid).collection('Accounts').doc(accUid).get();
      
//       // Check if the document exists
//       if (accountSnapshot.exists) {
//         // Update the account details
//         await profiles.doc(uid).collection('Accounts').doc(accUid).set({
//           'name': account_name,
//           'money': account_money,
//         });
//       } 
//     } 
//   } catch (e) {
//     print("Error setting account details: $e");
//   }
// }

  
}