import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/ui/views/functions/getDate.dart';
import 'package:flutter_application_1/ui/views/widgets/edit_event_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/event_info_widget.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:provider/provider.dart';

class OrganizedWidget extends StatefulWidget {
  const OrganizedWidget({super.key});

  @override
  State<OrganizedWidget> createState() => _OrganizedWidgetState();
}

class _OrganizedWidgetState extends State<OrganizedWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<EventController>()
          .fetchMyEventStream(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('There is no events yet'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error occured'),
          );
        }
        final events = snapshot.data.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            EventModel event = EventModel.fromDocumentSnapshot(events[index]);

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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditEventWidget(
                                                    eventId: event.eventId)));
                                  },
                                  title: const Text('Edit event'),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await context
                                        .read<EventController>()
                                        .deleteEvent(event.eventId);
                                    Navigator.pop(context);
                                  },
                                  title: const Text('Delete event'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.menu),
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
