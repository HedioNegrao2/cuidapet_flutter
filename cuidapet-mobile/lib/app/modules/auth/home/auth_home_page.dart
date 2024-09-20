import 'package:flutter/material.dart';
import 'package:gradiente_text/core/ui/extension/size_screen_extension.dart';


class AuthHomePage extends StatelessWidget {
  
  const AuthHomePage({ super.key });

   @override
   Widget build(BuildContext context) {
    
       return Scaffold(         
           body: Center(child: Image.asset(
            'assets/images/logo.png',
            width: 162.w,
            height: 130.h,
            fit: BoxFit.contain)),
       );
  }
}