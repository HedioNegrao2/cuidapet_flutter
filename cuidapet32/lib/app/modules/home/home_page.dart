import 'package:cuidapet32/app/core/live_cycle/page_live_cycle_state.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/modules/home/home_controller.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLiveCycleState<HomeController, HomePage> {
  AddressEntity?  addressEnity;

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
           TextButton(
            onPressed: () async {
              controller.goToAddressPage();
             
            },
            child: Text('Ir para endereço'),
          ),

          
           TextButton(
            onPressed: () async {
             final address =  await Modular.get<AddressService>().getAddressSelected();
             setState(() {                 
                addressEnity = address;
             });
             
            },
            child: Text('Pegar para endereço'),
          ),
          Observer(
              builder: (_) {
                  return Text(controller.addressEntity?.address ?? 'Nenhum endereço selecionado');
              },
          ),
          Observer(
              builder: (_) {
                  return Text(controller.addressEntity?.additional ?? 'Nenhum adicional selecionado');
              },
          ),

          
        ],
      ),
    );
  }
}
