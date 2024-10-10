import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/event_controller.dart';
import 'package:flutter_application_1/controller/register_event_controller.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/controller/auth_controller.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/ui/views/screens/main_screen.dart';
import 'package:flutter_application_1/ui/views/screens/sign_in_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AuthController();
        }),
        ChangeNotifierProvider(create: (context) {
          return EventController();
        }),
        ChangeNotifierProvider(create: (context) {
          return RegisterEventController();
        }),
      ],
      builder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return FutureBuilder<UserModel?>(
                      future: context.read<AuthController>().checkToken(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (userSnapshot.hasData && userSnapshot.data != null) {
                          // Token is valid and user data is fetched
                          return MainScreen(currentUserData: userSnapshot.data!);
                        } else {
                          // Token is null or not valid
                          return const SignInScreen();
                        }
                      },
                    );
                  } else {
                    // User is not logged in
                    return const SignInScreen();
                  }
                }
                return const Center(
                    child: CircularProgressIndicator()); // Loading state
              },
            ),
          ),
        );
      },
    );
  }
}
