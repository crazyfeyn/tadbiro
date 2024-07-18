import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/ui/views/functions/getDate.dart';
import 'package:flutter_application_1/ui/views/widgets/event_info_widget.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:provider/provider.dart';

class ParticipatedEventsWidget extends StatefulWidget {
  const ParticipatedEventsWidget({super.key});

  @override
  State<ParticipatedEventsWidget> createState() =>
      _ParticipatedEventsWidgetState();
}

class _ParticipatedEventsWidgetState
    extends State<ParticipatedEventsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context
          .read<EventController>()
          .participatedEvents(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('You have not participated in any events yet'),
          );
        }

        final List<EventModel> events = snapshot.data!.docs
            .map((doc) => EventModel.fromDocumentSnapshot(doc))
            .toList();

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            EventModel event = events[index];
            String period = event.dateTime.toDate().hour < 12 ? 'AM' : 'PM';

            String formattedDate =
                '${event.dateTime.toDate().hour}:${event.dateTime.toDate().minute.toString().padLeft(2, '0')} $period '
                '${Getdate.getMonthName(event.dateTime.toDate().month)} '
                '${event.dateTime.toDate().day} ';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventInfoWidget(event: event)));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(7)),
                      width: 100,
                      height: 100,
                      child: Image.network(
                        event.imageUrl ??
                            'https://t4.ftcdn.net/jpg/02/16/94/65/360_F_216946587_rmug8FCNgpDCPQlstiCJ0CAXJ2sqPRU7.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: AppConstants.mainTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'date: $formattedDate',
                            style: AppConstants.eventInfotext,
                          ),
                          Text(
                            'location: ${event.locationName!}',
                            style: AppConstants.eventInfotext,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
