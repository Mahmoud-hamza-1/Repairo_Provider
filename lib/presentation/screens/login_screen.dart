import 'package:flutter/material.dart';
import 'package:repairo_provider/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginForm());
  }
}
