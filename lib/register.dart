import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/home_page.dart';
import 'package:zense_project/loading.dart';
import 'package:zense_project/login.dart';
import 'package:zense_project/register.dart';
import 'package:zense_project/name_input.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  String username = '';
  String password = '';
  String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(left: 115, top: 200),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
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
                          validator: (val) => val!.isEmpty ? "Enter email" : null,
                          onChanged: (val){
                            setState(() => username = val);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (val) => val!.length<5 ? "Enter a password 5+ characters long" : null,
                          onChanged: (val){
                            setState(() => password = val);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Register',
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
                                      setState(() => loading = true);
                                      dynamic result = await _auth.registerNewUser(username,password);
                                      if (result==null){
                                        setState(() {
                                          loading=false;
                                          error = 'Invalid email';
                                          }
                                        );
                                      }
                                      else{
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => NameInput()));
                                      }
                                    }
                  
                                    // var sharedPref = await SharedPreferences.getInstance();
                                    // sharedPref.setBool(KEYLOGIN, true);
                  
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  //fontWeight: FontWeight.,
                                  fontStyle: FontStyle.italic),
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.lightGreen,
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: () async{
              
                  
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin()));
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded,size: 15)),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        )
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