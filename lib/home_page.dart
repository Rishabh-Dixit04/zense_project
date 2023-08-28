import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zense_project/splash_screen.dart';
import 'package:zense_project/home.dart';
import 'package:zense_project/budgets.dart';
import 'package:zense_project/dues.dart';
import 'package:zense_project/subscriptions.dart';


void main() {
  runApp(const MyHome());
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
 
  int currentIndex=0;

  final screens=[
    Home(),
    Budgets(),
    Subscriptions(),
    MyDues()
  ];
  static const KEYLOGIN='Login';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login_background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
        body: screens[currentIndex],
        backgroundColor: Colors.transparent,
        
        
        // Center(child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //   ElevatedButton(onPressed: (){

        //   setState(() {
        //     buttonName1="DONE!";
        //   });

        // },
        // child:  Text(buttonName1)
        // ),

        // ElevatedButton(onPressed: () async {
          
        //   var sharedPref = await SharedPreferences.getInstance();
        //   sharedPref.setBool(KEYLOGIN, false);
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));


        // },
        // child:  Text('LOG OUT'))
        // ]
        // )
        // ) 
        bottomNavigationBar: BottomNavigationBar(items:
              const [
                BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home),backgroundColor: Color.fromARGB(255, 61, 184, 241)),
                BottomNavigationBarItem(label: "Budgets",icon: Icon(Icons.money),backgroundColor: Color.fromARGB(255, 61, 184, 241)),
                BottomNavigationBarItem(label: "Subscriptions",icon: Icon(Icons.handshake),backgroundColor: Color.fromARGB(255, 61, 184, 241)),
                BottomNavigationBarItem(label: "Dues",icon: Icon(Icons.monetization_on),backgroundColor: Color.fromARGB(255, 61, 184, 241)),
              ],
              currentIndex: currentIndex,
              onTap: (int index) {
                  if (index >= 0 && index < screens.length) {
                    setState(() {
                      currentIndex = index;
                    });
                  }
                },
              ),

      ),
    ));
  }
}
