import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  const HomePage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Home page'),),
           body: Container(
            child: TextButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            }, 
            child: Text('Logout'),),
           ),
       );
  }
}