import 'package:cuidapet32/app/core/live_cycle/page_live_cycle_state.dart';
import 'package:cuidapet32/app/modules/home/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLiveCycleState<HomeController, HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text('Logout'),
          ),
          TextButton(
            onPressed: () async {
             
             
            },
            child: Text('Teste Refresh Token'),
          ),
        ],
      ),
    );
  }
}
