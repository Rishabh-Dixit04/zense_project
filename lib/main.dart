import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/home_page.dart';
import 'package:zense_project/login.dart';
import 'package:zense_project/register.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:zense_project/name_input.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/user.dart' as u;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<u.User?>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'login':(context) => MyLogin(),
        'register':(context) => MyRegister(),
        'splash':(context) => SplashScreen(),
        'home':(context) => MyHome(),
        'name_input':(context) => NameInput()
      },
    ),
  ));
}

