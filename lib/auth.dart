import 'package:firebase_auth/firebase_auth.dart';
import 'package:zense_project/database.dart';
import 'package:zense_project/user.dart' as u;

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  u.User? _userFromFirebaseUser(User? user){
    return user!=null ? u.User(uid: user.uid) : null;
  }

  Stream <u.User?> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);

  }

  Future signInAnon() async {
    try {
      UserCredential result =  await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }


  Future registerNewUser(String username,String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: username, password: password);
      User? user = result.user;


      await DatabaseService(uid: user!.uid).updateUserData('', ['',0], [0,'']);
      return _userFromFirebaseUser(user);

    }
    catch(e){
      print(e.toString());
      return null;

    }
  }


    Future signIn(String username,String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: username, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);

    }
    catch(e){
      print(e.toString());
      return null;

    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}