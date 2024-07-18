import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/widgets/add_event_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/drawer_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/organized_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/participated_events_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/recent_participated_events_widget.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';

class MyEventsScreen extends StatefulWidget {
  final UserModel currentUserData;
  MyEventsScreen({Key? key, required this.currentUserData}) : super(key: key);

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My events', style: AppConstants.mainTextStyle),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.notifications_none_outlined),
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppConstants.orangeColor,
            labelColor: AppConstants.orangeColor,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Orginized event'),
              Tab(text: 'Recent'),
              Tab(text: 'Participated by me'),
            ],
          ),
        ),
        drawer: DrawerWidget(currentUserData: widget.currentUserData),
        body: const TabBarView(
          children: [
            OrganizedWidget(),
            RecentParticipatedEventsWidget(),
            ParticipatedEventsWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEventWidget()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;

  const PlaceholderWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label),
    );
  }
}
