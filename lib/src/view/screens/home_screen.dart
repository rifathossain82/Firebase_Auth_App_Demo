import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app_demo/src/view/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: (){
              logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome!'),
      ),
    );
  }

  logout(context){
    if(FirebaseAuth.instance.currentUser?.uid != null){
      FirebaseAuth.instance.signOut().then((value) =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen())));
    }
  }


  /// here is today
/// I will try to update more functionality if possible inshallah
/// thank you..............
}
