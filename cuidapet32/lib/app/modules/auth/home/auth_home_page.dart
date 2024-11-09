import 'package:cuidapet32/app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/core/auth/auth_store.dart';
import 'package:cuidapet32/app/core/ui/extension/size_screen_extension.dart';
import 'package:mobx/mobx.dart';

class AuthHomePage extends StatefulWidget {
  final AuthStore _authStore;

  const AuthHomePage({super.key, required AuthStore authStore})
      : _authStore = authStore;

  @override
  State<AuthHomePage> createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  @override
  void initState() {
    super.initState();
    reaction<UserModel?>((_) => widget._authStore.userLogged, (userLogger){
      if(userLogger != null && userLogger.email.isNotEmpty){
        Modular.to.navigate('/home');
      }else{
        Modular.to.navigate('/auth/login');
      }

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget._authStore.loadUserLogged();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/images/logo.png',
        width: 162.w,
        height: 130.h,
        fit: BoxFit.contain,
      )),
    );
  }
}
