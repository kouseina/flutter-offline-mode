import 'package:flutter/material.dart';
import 'package:flutter_realm/widgets/main_textfield_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    MainTextFieldWidget(
                      controller: emailController,
                      labelText: "Email",
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MainTextFieldWidget(
                      controller: passwordController,
                      labelText: "Password",
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
