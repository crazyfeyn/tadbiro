import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/screens/main_screen.dart';
import 'package:flutter_application_1/ui/views/screens/my_events_screen.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';

class DrawerWidget extends StatelessWidget {
  UserModel currentUserData;
  DrawerWidget({super.key, required this.currentUserData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUserData.fullName,
                style: AppConstants.drawerTextStyle),
            accountEmail: Text(
              currentUserData.email,
              style: AppConstants.drawerTextStyle,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(currentUserData.profileImage),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 243, 180, 33),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(
                                    currentUserData: currentUserData,
                                  )));
                    },
                    child: ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(
                        'Main',
                        style: AppConstants.drawerTextStyle,
                      ),
                      trailing: const Icon(CupertinoIcons.right_chevron),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyEventsScreen(
                                  currentUserData: currentUserData)));
                    },
                    child: ListTile(
                      leading: const Icon(Icons.stop_rounded),
                      title: Text(
                        'My events',
                        style: AppConstants.drawerTextStyle,
                      ),
                      trailing: const Icon(CupertinoIcons.right_chevron),
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
