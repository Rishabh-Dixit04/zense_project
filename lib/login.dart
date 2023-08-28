import 'package:flutter/material.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/home_page.dart';
import 'package:zense_project/loading.dart';
import 'package:zense_project/register.dart';


class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {


  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading=false;
  String username = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :  Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login_background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 70, top: 200),
                child: const Text(
                  'PennySaver',
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      //backgroundColor: ,
                      fontSize: 50,
                      fontWeight: FontWeight.w900),
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
                              labelText: 'Email',
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
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Sign In',
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

                                      dynamic result = await _auth.signIn(username,password);
                                      if (result==null){
                                        setState(() {
                                          loading = false;
                                          error = 'Invalid Credentials';
                                        });
                                      }
                                      else{
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
                                      }
                                    
                                    }
                  
                                    // var sharedPref = await SharedPreferences.getInstance();
                                    // sharedPref.setBool(KEYLOGIN, true);
                  
                                    // dynamic result = await _auth.signInAnon(); 
                                    // if (result!=null)print(result.uid);
                  
                  
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyRegister()));
                            }, child: const Text('Sign Up',style: TextStyle(color: Color.fromARGB(136, 0, 0, 0),fontSize: 28,fontStyle: FontStyle.italic))),
                            
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

