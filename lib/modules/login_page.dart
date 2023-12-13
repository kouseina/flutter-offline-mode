import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realm/graphql/queries.dart';
import 'package:flutter_realm/modules/home_page.dart';
import 'package:flutter_realm/storage/shared_pref.dart';
import 'package:flutter_realm/utils/dialog_utils.dart';
import 'package:flutter_realm/widgets/main_textfield_widget.dart';
import 'package:graphql/client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _loadKey = GlobalKey<State>();

  late TextEditingController userNameController;
  late TextEditingController passwordController;

  final GraphQLClient client = GraphQLClient(
    link: HttpLink(
        'http://diyo-api-load-balancer-576848411.ap-southeast-1.elb.amazonaws.com:8080/query'),
    cache: GraphQLCache(),
  );

  @override
  void initState() {
    super.initState();

    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    userNameController.dispose();
    passwordController.dispose();
  }

  void onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    DialogUtils.showLoadingDialog(context, _loadKey);

    final options = MutationOptions(
      document: gql(Queries.login),
      variables: <String, dynamic>{
        'username': userNameController.text,
        'password': passwordController.text,
      },
    );

    final QueryResult result = await client.mutate(options);

    Navigator.of(_loadKey.currentContext!, rootNavigator: true).pop();

    if (result.hasException) {
      if (kDebugMode) {
        print("login page | result exception : ${result.exception}");
      }
      return;
    }

    if (result.data != null) {
      SharedPref().token = result.data?["login"];

      if (!context.mounted) return;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainTextFieldWidget(
                  controller: userNameController,
                  labelText: "Username",
                ),
                const SizedBox(
                  height: 16,
                ),
                MainTextFieldWidget(
                  controller: passwordController,
                  labelText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onLogin,
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
