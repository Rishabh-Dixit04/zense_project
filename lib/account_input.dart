import 'package:flutter/material.dart';
import 'package:zense_project/database.dart';
import 'package:zense_project/home_page.dart';
import 'package:zense_project/loading.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class AccountInput extends StatefulWidget {
  const AccountInput({super.key});

  @override
  State<AccountInput> createState() => _AccountInputState();
}

class _AccountInputState extends State<AccountInput> {
  bool loading = false;
  String account_name = '';
  int account_money=0;
  int income = 0;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading ? Loading(): Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login_background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5-300,
                      left: 35,
                      right: 35),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                padding: const EdgeInsets.only(left: 70, top: 100),
                child: const Text(
                  'Enter account & income details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),const SizedBox(height: 30),
                        TextFormField(
                          validator: (val) => val!.isEmpty ? "Enter account name" : null,
                          onChanged: (val){
                            setState(() => account_name = val);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Primary account name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        
                        const SizedBox(height: 30),
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

                        TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter current income";
                                }
                                int? parsedValue = int.tryParse(val);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return "Enter a valid income (> Rs.0)";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  income = int.tryParse(val) ?? 0;
                                });
                              },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Current monthly income(Rs.)',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        
                        
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Next',
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

                                      await DatabaseService(uid: user.uid).setAccountDetails(context,account_name,account_money);
                                      await DatabaseService(uid: user.uid).setIncomeDetails(context,account_name,income);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));

                                      // setState(() => loading = true);
                                      // dynamic result = await _auth.registerNewUser(username,password);
                                      // if (result==null){
                                      //   setState(() {
                                      //     loading=false;
                                      //     error = 'Invalid email';
                                      //     }
                                      //   );
                                      // }
                                      // else{
                                      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NameInput()));
                                      // }
                                    }
                  
                                    // var sharedPref = await SharedPreferences.getInstance();
                                    // sharedPref.setBool(KEYLOGIN, true);
                  
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

