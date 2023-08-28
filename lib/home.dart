import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zense_project/app_users.dart';
import 'package:zense_project/detail_tile.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/auth.dart';
import 'package:zense_project/database.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user_content.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserDetails>>.value(
      initialData: [],
      value: DatabaseService(uid: '').details,
      child: Container(
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
              body: DetailTile(),
              // body: Stack(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.only(left: 300, top: 30),
              //       child: TextButton(
              //           onPressed: () async {
              //             var sharedPref = await SharedPreferences.getInstance();
              //             sharedPref.setBool(KEYLOGIN, false);
              //             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SplashScreen()));
              //           },
              //           child: const Text(
              //             'LOG OUT',
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 decoration: TextDecoration.underline),
              //           )),
              //     ),
              //   ],
              // ),
            ),
          ),
    );
  }
}
