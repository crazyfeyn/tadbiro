import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/functions/getDate.dart';
import 'package:flutter_application_1/ui/views/widgets/drawer_widget.dart';
import 'package:flutter_application_1/ui/views/widgets/event_info_widget.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final UserModel currentUserData;

  const MainScreen({super.key, required this.currentUserData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? debounce;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    void onSearchChanged(String query) {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(seconds: 1), () {
        setState(() {
          searchQuery = query;
          isSearched = query.isNotEmpty;
        });
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Home screen'),
        centerTitle: true,
      ),
      drawer: DrawerWidget(currentUserData: widget.currentUserData),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: context.read<EventController>().getRecentSevenDaysEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('There is no event in the near 7 days'),
                );
              }

              final events = snapshot.data!.docs
                  .map((doc) => EventModel.fromDocumentSnapshot(doc))
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: AppConstants.orangeColor,
                            width: 3.0,
                          ),
                        ),
                        hintText: "Search events...",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: AppConstants.orangeColor,
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: AppConstants.orangeColor,
                            width: 3.0,
                          ),
                        ),
                      ),
                    ),
                    isSearched
                        ? const PopupMenuItem(child: Text('data'))
                        : const SizedBox(),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SizedBox(width: 7.w),
                        Text('Recent 7 days',
                            style: AppConstants.mainTextStyle),
                      ],
                    ),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 280,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                        items: events.map((event) {
                          final isLiked = event.likedUsers
                              .contains(FirebaseAuth.instance.currentUser!.uid);

                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventInfoWidget(event: event)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        event.imageUrl ??
                                            'https://t4.ftcdn.net/jpg/02/16/94/65/360_F_216946587_rmug8FCNgpDCPQlstiCJ0CAXJ2sqPRU7.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 70.w,
                                              height: 40.h,
                                              margin:
                                                  EdgeInsets.only(left: 10.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors.black,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    event.dateTime
                                                        .toDate()
                                                        .day
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    Getdate.getMonthName(event
                                                        .dateTime
                                                        .toDate()
                                                        .month),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<EventController>()
                                                      .toggleLike(
                                                          event, context);
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Text(
                                            'Description: ${event.description}',
                                            style: AppConstants.mainTextStyle
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12.h)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<EventController>().fetchEventStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No events available'),
                  );
                }

                final events = snapshot.data!.docs
                    .map((doc) => EventModel.fromDocumentSnapshot(doc))
                    .where((event) =>
                        event.title
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        event.description
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                    .toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          EventModel event = events[index];

                          String period =
                              event.dateTime.toDate().hour < 12 ? 'AM' : 'PM';

                          String formattedDate =
                              '${event.dateTime.toDate().hour}:${event.dateTime.toDate().minute.toString().padLeft(2, '0')} $period '
                              '${event.dateTime.toDate().day} ${Getdate.getMonthName(event.dateTime.toDate().month)}';

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: event.imageUrl != null
                                    ? NetworkImage(event.imageUrl!)
                                    : const NetworkImage(
                                        'https://t4.ftcdn.net/jpg/02/16/94/65/360_F_216946587_rmug8FCNgpDCPQlstiCJ0CAXJ2sqPRU7.jpg'),
                              ),
                              title: Text(event.title),
                              subtitle: Text(formattedDate),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventInfoWidget(
                                      event: event,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
