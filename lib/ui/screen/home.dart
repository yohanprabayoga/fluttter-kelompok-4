import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumpmonitoring/core/auth/auth_firebase.dart';
import 'package:pumpmonitoring/ui/widget/custom_alert_dialog.dart';
import 'package:pumpmonitoring/ui/widget/dashboard_graph_widget.dart';
import 'package:pumpmonitoring/ui/widget/pump_controller_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await const CustomAlertDialog(
      title: "Logout",
      content: "Apakah yakin ingin keluar ?",
      defaultActionText: "Logout",
      cancelActionText: "Cancel",
    ).show(context);

    if (didRequestSignOut == true) {
      // ignore: use_build_context_synchronously
      _signOut(context);
    }
  }

  Widget _buildHomePageContent(UserModel user, BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.cyan[400],
              child: Text(
                user.email.split("")[0].toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.white),
                ),
                // Text(
                //   user.uid,
                //   style: const TextStyle(color: Colors.white),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _coreMenuBar(BuildContext context) {
    return Expanded(
        flex: 2,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                backgroundColor: const Color.fromARGB(255, 86, 121, 87),
                unselectedBackgroundColor:
                    const Color.fromARGB(255, 11, 80, 13),
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                physics: const BouncingScrollPhysics(),
                labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 5, 4, 4),
                    fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                      icon: Icon(Icons.dashboard_outlined),

                      // text: "car"
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Tab(
                      icon: Icon(Icons.dashboard_outlined),

                      // text: "car"
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          "Pump Controller",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    DashboardGraphWidget(),
                    PumpControllerWidget(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pump Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 86, 121, 87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => _confirmSignOut(context),
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHomePageContent(user, context),
              _coreMenuBar(context),
            ],
          ),
        ));
  }
}
