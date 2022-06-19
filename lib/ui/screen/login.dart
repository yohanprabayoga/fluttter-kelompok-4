import 'package:flutter/material.dart';
import 'package:pumpmonitoring/ui/widget/login_email_form_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "My App",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   elevation: 2.0,
      //   backgroundColor: Colors.cyan[400],
      // ),
      body: EmailSignInForm.create(context),
    );
  }
}
