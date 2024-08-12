import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/auth_controller.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/screens/main_screen.dart';
import 'package:flutter_application_1/ui/views/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: context.read<AuthController>().getCurrentUsers(),
      builder: (context, snapshot) {      
        Widget body;

        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          body = const Center(
            child: Text('error'),
          );
        } else if (!snapshot.hasData) {
          print('No data in snapshot');
          body = const Center(
            child: Text('No user data available'),
          );
        } else if (!snapshot.data!.exists) {
          print('Document does not exist');
          body = const Center(
            child: Text('No user data available'),
          );
        } else {
          final currentUserData =
              UserModel.fromDocumentSnapshot(snapshot.data!);

          body = MainScreen(currentUserData: currentUserData);
        }

        return Scaffold(
          drawer: snapshot.hasData && snapshot.data!.exists
              ? DrawerWidget(
                  currentUserData:
                      UserModel.fromDocumentSnapshot(snapshot.data!),
                )
              : null,
          body: body,
        );
      },
    );
  }
}
