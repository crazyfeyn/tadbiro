import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/functions/get_weekday.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventInfoMainWidget extends StatelessWidget {
  String formattedDate;
  String formattedTime;
  EventModel event;
  UserModel? user;
  DateTime eventDateTime;
  EventInfoMainWidget(
      {super.key,
      required this.formattedDate,
      required this.event,
      required this.user,
      required this.formattedTime,
      required this.eventDateTime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                height: 60.h,
                width: 70.w,
                padding: EdgeInsets.all(10.sw),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$formattedDate  $formattedTime",
                      style: AppConstants.drawerTextStyle),
                  SizedBox(height: 6.h),
                  Text(GetWeekday.getWeekday(eventDateTime.weekday),
                      style: AppConstants.drawerTextStyle),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 60.h,
                width: 70.w,
                padding: EdgeInsets.all(10.sw),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.locationName != null
                        ? (event.locationName!.length > 30
                            ? '${event.locationName!.substring(0, 30)}...'
                            : event.locationName!)
                        : 'Unknown Location',
                    style: AppConstants.drawerTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 60.h,
                width: 70.w,
                padding: EdgeInsets.all(10.sw),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${event.participants.isEmpty ? 0 : event.participants.values} are participating",
                    style: AppConstants.drawerTextStyle.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "you can also join us",
                    style: AppConstants.drawerTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 60.h,
                width: 70.w,
                padding: EdgeInsets.all(10.sw),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'username',
                    style: AppConstants.drawerTextStyle.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Event organizer",
                    style: AppConstants.drawerTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
