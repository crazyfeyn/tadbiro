import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/services/location_services.dart';
import 'package:flutter_application_1/ui/views/functions/locationFinder.dart';
import 'package:flutter_application_1/utils/app_constanst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class EditEventWidget extends StatefulWidget {
  String eventId;
   EditEventWidget({Key? key,required this.eventId}) : super(key: key);

  @override
  State<EditEventWidget> createState() => _EditEventWidgetState();
}

class _EditEventWidgetState extends State<EditEventWidget> {
  final _formKey = GlobalKey<FormState>();
  final _eventTitleController = TextEditingController();
  final _eventDescController = TextEditingController();
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  File? _imageFile;
  bool _isLoading = false;
  late GoogleMapController mapController;
  LocationData? myLocation;

  LatLng najotTalim = const LatLng(41.2856806, 69.2034646);
  LatLng? currentLocation;

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onCameraMove(CameraPosition position) async {
    currentLocation = position.target;
    String locationName = await Locationfinder.getLocationName(
        currentLocation!.latitude, currentLocation!.longitude);
    setState(() {});
  }

  void openGallery() async {
    try {
      final imagePicker = ImagePicker();
      final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        requestFullMetadata: false,
      );

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } catch (e) {
      _showErrorDialog("Error picking image from gallery");
    }
  }

  void openCamera() async {
    try {
      final imagePicker = ImagePicker();
      final XFile? pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera,
          requestFullMetadata: false,
          imageQuality: 50);
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } catch (e) {
      _showErrorDialog("Error picking image from camera");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null && picked != _eventTime) {
      setState(() {
        _eventTime = picked;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() {
        _isLoading = true;
      });
      String locationName = await Locationfinder.getLocationName(
          currentLocation!.latitude, currentLocation!.longitude);
      String eventTitle = _eventTitleController.text;
      Timestamp eventDateTime = Timestamp.fromDate(
        DateTime(
          _eventDate!.year,
          _eventDate!.month,
          _eventDate!.day,
          _eventTime!.hour,
          _eventTime!.minute,
        ),
      );
      String eventDescription = _eventDescController.text;

      context.read<EventController>().editEvent(
          widget.eventId,
          eventTitle,
          eventDateTime,
          eventDescription,
          currentLocation,
          _imageFile,
          locationName);
      try {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event saved successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog("Error saving event. Please try again.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("An Error Occurred!"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    myLocation = await LocationService.getCurrentLocation();
    if (myLocation != null) {
      currentLocation = LatLng(myLocation!.latitude!, myLocation!.longitude!);
    } else {
      currentLocation = najotTalim;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Add Event',
          style: AppConstants.mainTextStyle,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _eventTitleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                              color: AppConstants.orangeColor,
                              width: 3.0,
                            ),
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: AppConstants.orangeColor,
                              width: 3.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _eventDate != null
                                    ? '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'
                                    : 'Select date',
                                style: AppConstants.fromfielTextStyle,
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child:
                                    const Icon(Icons.calendar_today_outlined),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: AppConstants.orangeColor,
                              width: 3.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _eventTime != null
                                    ? '${_eventTime!.hour}:${_eventTime!.minute}'
                                    : 'Select time',
                                style: AppConstants.fromfielTextStyle,
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(context),
                                child: const Icon(CupertinoIcons.clock),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        minLines: 3,
                        maxLines: null,
                        controller: _eventDescController,
                        decoration: InputDecoration(
                          labelText: 'Description of event',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                              color: AppConstants.orangeColor,
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                              color: AppConstants.orangeColor,
                              width: 3.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                ' Upload image of event',
                                style: AppConstants.mainTextStyle.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize: 14.h),
                              )
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => openCamera(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.h, horizontal: 50.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'camera',
                                          style: AppConstants.mainTextStyle
                                              .copyWith(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => openGallery(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.h, horizontal: 50.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.photo_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'gallery',
                                          style: AppConstants.mainTextStyle
                                              .copyWith(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                ' Set location',
                                style: AppConstants.mainTextStyle.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize: 14.h),
                              )
                            ],
                          ),
                          SizedBox(height: 4.h),
                          currentLocation != null
                              ? SizedBox(
                                  height: 400,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 400,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: GoogleMap(
                                          gestureRecognizers: Set()
                                            ..add(Factory<
                                                    EagerGestureRecognizer>(
                                                () =>
                                                    EagerGestureRecognizer())),
                                          buildingsEnabled: true,
                                          onCameraMove: onCameraMove,
                                          onMapCreated: onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                            target: currentLocation!,
                                            zoom: 15,
                                          ),
                                          mapType: MapType.normal,
                                          myLocationButtonEnabled: true,
                                          myLocationEnabled: true,
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                          weight: BitmapDescriptor.hueCyan,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: _saveEvent,
                        child: const Text('Save Event'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
