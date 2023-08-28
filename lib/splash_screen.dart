import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:zense_project/login.dart';
import 'package:zense_project/home_page.dart';
import 'package:zense_project/user.dart' as u;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late var user = Provider.of<u.User?>(context);
  late BuildContext _context;
  static const KEYLOGIN='Login';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _context = context; // Initialize the BuildContext variable
    user = Provider.of<u.User?>(_context); // Access the Provider
    whereToGo();
  }
  void initState() {
    super.initState();

    whereToGo();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.transparent,
        decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/screen_background.jpg'),
                    fit: BoxFit.cover)),
        child: const Center(child: Text('PennySaver',style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 60))),
      )
    );
  }



  void whereToGo() async{
    //var sharedPref = await SharedPreferences.getInstance();

    //var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    
    Timer(const Duration(seconds: 2), () { 

      if (user==null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
      }

      // if (u.User.uid!=null){
      //   if (isLoggedIn){
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
      //   }
      //   else{
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin()));
      //   }
      // }
      // else{
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin()));
      // }

    });
  }
}