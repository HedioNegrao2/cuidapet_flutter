part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CuidapetTextformField(label: 'Login'),
          const SizedBox(
            height: 20,
          ),
          CuidapetTextformField(label: 'Senha', obscureText: true),
          const SizedBox(
            height: 20,
          ),
          CuidapetDefaultButton(onPressed: () {
            Messages.info('Mensagem de teste');
            
          }, label: 'Entrar'),
          const SizedBox(
            height: 20,
          ),
          _OrSeparator()
        ],
      ),
    );
  }
}

class _OrSeparator extends StatelessWidget {
  const _OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Divider(
          thickness: 1,
          color: context.primaryColor,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'OU',
            style: TextStyle(
                color: context.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }
}
