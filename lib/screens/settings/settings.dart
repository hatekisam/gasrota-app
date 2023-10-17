import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/settings/account.dart';
import 'package:grasrota/screens/settings/discoverErr.dart';
import 'package:grasrota/screens/settings/subscription.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final UserModal user;
  final Map? cred;
  SettingsPage({required this.user, required this.cred});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 30),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(10)),
                    child: Transform.translate(
                      offset: const Offset(5, 0),
                      child: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
              const Text(
                "Innstillinger",
                textScaleFactor: 1.0,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "MIN KONTO",
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                  ),
                ),
              ),
              InkWell(
                child: settingCard("Konto", Icons.account_circle_rounded,
                    Colors.green.withOpacity(.8), "konto"),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Account(user: user, cred: cred)));
                },
              ),
              !user.isAdmin
                  ? InkWell(
                      child: settingCard(
                          "Tidligere kjøp fra Grasrota",
                          Icons.subscriptions_rounded,
                          Colors.deepPurple[400]!.withOpacity(.8),
                          "abon"),
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Subscription(user: user)));
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "TILBAKEMELDING",
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                  ),
                ),
              ),
              InkWell(
                child: settingCard("Oppdaget en feil", Icons.error_outline,
                    Colors.yellow[600]!, "error"),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DiscoverErr()));
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "MER INFO",
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                  ),
                ),
              ),
              InkWell(
                  child: settingCard("Personvern", Icons.privacy_tip_outlined,
                      Colors.orange, ""),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    launch("https://grasrota.com/policy",
                        forceSafariVC: true, forceWebView: true);
                  }),
              InkWell(
                  child: settingCard("Vilkår for bruk",
                      Icons.privacy_tip_rounded, Colors.orange, ""),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    launch("https://grasrota.com/terms",
                        forceSafariVC: true, forceWebView: true);
                  }),
              InkWell(
                child: settingCard(
                    "Lisenser", Icons.lock_outline_rounded, Colors.blue, "e"),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  launch("https://www.google.com",
                      forceSafariVC: true, forceWebView: true);
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    alignment: Alignment.center,
                    height: 45,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.red[700]),
                    child: Text(
                      "Loggut",
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ));
  }
}
