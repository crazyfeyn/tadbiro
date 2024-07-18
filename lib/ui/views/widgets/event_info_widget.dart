import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/auth_controller.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/controller/register_event_controller.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/functions/getDate.dart';
import 'package:flutter_application_1/ui/views/screens/main_screen.dart';
import 'package:flutter_application_1/ui/views/widgets/event_info_main_widget.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EventInfoWidget extends StatefulWidget {
  final EventModel event;

  EventInfoWidget({super.key, required this.event});

  @override
  State<EventInfoWidget> createState() => _EventInfoWidgetState();
}

class _EventInfoWidgetState extends State<EventInfoWidget> {
  late bool isLiked;
  late int numberOfSeats;

  @override
  void initState() {
    super.initState();
    isLiked = widget.event.likedUsers
        .contains(FirebaseAuth.instance.currentUser!.uid);
    numberOfSeats = context.read<RegisterEventController>().numberOfSeats;
  }

  @override
  Widget build(BuildContext context) {
    DateTime eventDateTime = widget.event.dateTime.toDate();
    String period = eventDateTime.hour < 12 ? 'AM' : 'PM';

    String formattedDate =
        '${Getdate.getMonthName(eventDateTime.month)} ${eventDateTime.day}';
    String formattedTime =
        '${eventDateTime.hour}:${eventDateTime.minute.toString().padLeft(2, '0')} $period';

    void toggleLike() {
      setState(() {
        isLiked = !isLiked;
        context.read<EventController>().toggleLike(widget.event, context);
      });
    }

    return Scaffold(
      body: StreamBuilder(
        stream: context.read<AuthController>().getCurrentUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final user = UserModel.fromDocumentSnapshot(snapshot.data);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageSection(context, toggleLike),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.title,
                          style: AppConstants.drawerTextStyle),
                      EventInfoMainWidget(
                        formattedDate: formattedDate,
                        event: widget.event,
                        user: user,
                        formattedTime: formattedTime,
                        eventDateTime: eventDateTime,
                      ),
                      _buildEventDetails(),
                      buildLocationDetails(),
                      SizedBox(height: 10.h),
                      buildRegisterButton(context, user),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

//split these methods to other files
  Widget buildImageSection(BuildContext context, void Function() toggleLike) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(widget.event.imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                child: Icon(CupertinoIcons.left_chevron),
              ),
            ),
            GestureDetector(
              onTap: toggleLike,
              child: CircleAvatar(
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About the event',
            style: AppConstants.drawerTextStyle.copyWith(fontSize: 16)),
        SizedBox(height: 1.h),
        Text(widget.event.description,
            style: AppConstants.drawerTextStyle.copyWith(fontSize: 16)),
      ],
    );
  }

  Widget buildLocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location',
            style: AppConstants.drawerTextStyle.copyWith(fontSize: 16)),
        SizedBox(height: 1.h),
        Text(widget.event.locationName!,
            style: AppConstants.drawerTextStyle.copyWith(fontSize: 16)),
      ],
    );
  }

  Widget buildRegisterButton(BuildContext context, UserModel user) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Consumer<RegisterEventController>(
              builder: (context, registerEventController, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: AppConstants.mainTextStyle,
                          ),
                          buildSeatSelection(
                              context, registerEventController, user),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
      child: Container(
        height: 47.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8E2D4),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppConstants.orangeColor, width: 3),
        ),
        child: Text('Register', style: AppConstants.mainTextStyle),
      ),
    );
  }

  Widget buildSeatSelection(BuildContext context,
      RegisterEventController registerEventController, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text('Choose number of seats', style: AppConstants.drawerTextStyle),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => registerEventController.removeSeat(),
              child: CircleAvatar(
                child: Icon(Icons.remove),
              ),
            ),
            SizedBox(width: 10.w),
            Text(registerEventController.numberOfSeats.toString(),
                style: AppConstants.mainTextStyle),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () => registerEventController.addSeat(),
              child: CircleAvatar(
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text('Payment method', style: AppConstants.drawerTextStyle),
        SizedBox(height: 5.h),
        buildPaymentMethodOption(context, 'assets/images/paypal.png', 'paypal',
            registerEventController),
        SizedBox(height: 100.h),
        GestureDetector(
          onTap: () {
            if (registerEventController.numberOfSeats > 0 &&
                registerEventController.selectedPaymentMethod.isNotEmpty) {
              String userId = FirebaseAuth.instance.currentUser!.uid;

              context.read<EventController>().addParticipant(
                  {userId: registerEventController.numberOfSeats},
                  widget.event.eventId);
              registerEventController.setToClear();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/accepted.png'),
                          Text(
                            'Congratulations!',
                            style: AppConstants.mainTextStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'You are successfully registered to ${widget.event.title}.',
                            textAlign: TextAlign.center,
                            style: AppConstants.drawerTextStyle,
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 47.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF8E2D4),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: AppConstants.orangeColor, width: 3),
                              ),
                              child: Text('Set notification',
                                  style: AppConstants.mainTextStyle),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainScreen(currentUserData: user)));
                            },
                            child: Container(
                              height: 47.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: AppConstants.orangeColor, width: 3),
                              ),
                              child: Text('Home screen',
                                  style: AppConstants.mainTextStyle),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }
          },
          child: Container(
            height: 47.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: registerEventController.numberOfSeats > 0 &&
                      registerEventController.selectedPaymentMethod.isNotEmpty
                  ? Color(0xFFF8E2D4)
                  : Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppConstants.orangeColor, width: 3),
            ),
            child: Text('Register', style: AppConstants.mainTextStyle),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentMethodOption(BuildContext context, String assetPath,
      String method, RegisterEventController registerEventController) {
    return GestureDetector(
      onTap: () {
        registerEventController.selectPaymentMethod(method);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.5.w),
        height: 50.h,
        width: 300.w,
        decoration: BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: registerEventController.selectedPaymentMethod == method
                ? Colors.orange
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  assetPath,
                  width: 60.w,
                ),
                Text(
                  method,
                  style: AppConstants.drawerTextStyle,
                ),
              ],
            ),
            Icon(
              registerEventController.selectedPaymentMethod == method
                  ? Icons.check_circle
                  : Icons.circle_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
