import 'package:flutter/material.dart';
import 'package:zense_project/account_input.dart';
import 'package:zense_project/database.dart';
import 'package:zense_project/loading.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class NameInput extends StatefulWidget {
  const NameInput({super.key});

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  bool loading = false;
  String username = '';
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
              Container(
                padding: const EdgeInsets.only(left: 90, top: 250),
                child: const Text(
                  'Enter Username',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5-50,
                      left: 35,
                      right: 35),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) => val!.isEmpty ? "Enter username" : null,
                          onChanged: (val){
                            setState(() => username = val);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Username',
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

                                      await DatabaseService(uid: user.uid).setUserName(username);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInput()));

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

