import 'package:cuidapet32/app/core/helpers/environments.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:cuidapet32/app/core/ui/extension/size_screen_extension.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';
import 'package:cuidapet32/app/core/ui/icons/cuidapet_icons.dart';
import 'package:cuidapet32/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidapet32/app/core/ui/widgets/cuidapet_textform_field.dart';
import 'package:cuidapet32/app/core/ui/widgets/rounded_button_with_icon.dart';

part 'widgets/login_form.dart';
part 'widgets/login_register_buttons.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           
           body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(Environments.param('base_url') ?? 'Cuidapet',),
                   SizedBox(height: 50.h),
                  Center(child: Image.asset('assets/images/logo.png',
                  width: 162.w,
                  fit: BoxFit.fill,
                  ),),
                  
                  const SizedBox(height: 20),
                  _LoginForm(),
                  const SizedBox(height: 8),
                  _LoginRegisterButtons(),
                ],
              ),
            ),
           ),
       );
  }
}