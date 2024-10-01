import 'package:flutter/material.dart';
import 'package:gradiente_text/app/core/ui/icons/cuidapet_icons.dart';
import 'package:gradiente_text/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:gradiente_text/app/core/ui/widgets/cuidapet_textform_field.dart';
import 'package:gradiente_text/app/core/ui/widgets/rounded_button_with_icon.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Login Page'),),
           body: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
               children: [
                 CuidapetTextformField(label:'E-mail', obscureText: true,),
                 Icon(CuidapetIcons.google, color: Colors.red,),
                 Icon(CuidapetIcons.facebook),
                 RoundedButtonWithIcon(onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clicou no botão do facebook'),
                    ),
                  );
                 },
                  width: 200,
                  color: Colors.blue,
                  icon: CuidapetIcons.facebook,
                  label: 'Facebook',
                  ),
                RoundedButtonWithIcon(onTap: (){},
                  width: 200,
                  color: Colors.orange,
                  icon: CuidapetIcons.google,
                  label: 'Google',
                  ),
                CuidapetDefaultButton(onPressed: (){ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clicou'),
                    ),
                  );},color: Colors.red, label: 'Logar',)
               ],
             ),
           ),
       );
  }
}