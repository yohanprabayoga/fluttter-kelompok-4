import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumpmonitoring/core/auth/auth_firebase.dart';
import 'package:pumpmonitoring/ui/screen/home.dart';
import 'package:pumpmonitoring/ui/screen/register.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserModel?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserModel? user = snapshot.data;
          if (user == null) {
            return const SignInPage();
          }
          return Provider<UserModel>.value(
              value: user, child: const HomePage());
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
