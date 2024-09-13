import 'package:bookipedia/app/app_routes.dart';
import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/main.dart';
import 'package:bookipedia/presentation_layer/screens/auth_screens/login/login_view.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName;
  String? fisrtLetter;
  String? userEmail;
  getUserInfo() async {
    userEmail = preferences.getString(AppStrings.emailKey);
    userName = preferences.getString(AppStrings.userNameKey);
    fisrtLetter = userName![0].toUpperCase();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                onPressed: () {
                  preferences.setString("token", "");
                  Navigator.of(context).pushNamed(Routes.loginRoute);
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
              width: double.infinity,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black,
              child: Text(
                fisrtLetter!,
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userName!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              userEmail!,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text(
                    "About us    ",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
