import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/auth_controller.dart';
import 'package:flutter_application_1/ui/views/screens/forgot_password_screen.dart';
import 'package:flutter_application_1/ui/views/screens/home_screen.dart';
import 'package:flutter_application_1/ui/views/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isDownloaded1 = false;
  bool incorrect = false;

  void checkSignIn() async {
    setState(() {
      isDownloaded1 = true;
      incorrect = false;
    });

    var x = await context
        .read<AuthController>()
        .signIn(_emailController.text, _passwordController.text);

    setState(() {
      isDownloaded1 = false;
      incorrect = !x;
    });

    if (x) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incorrect password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Added some space at the top
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 20), // Added space below the logo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your email',
                      style: TextStyle(
                          color: Color(0xFF24786D),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Added spacing
                    const Text(
                      'Your password',
                      style: TextStyle(
                          color: Color(0xFF24786D),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Added spacing
                Column(
                  mainAxisSize: MainAxisSize.min, // Adjust size
                  children: [
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          checkSignIn();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xFF24786D),
                            borderRadius: BorderRadius.circular(20)),
                        child: isDownloaded1
                            ? const CircularProgressIndicator()
                            : const Text('Log In',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16), // Added spacing
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text('Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xFF24786D))),
                      ),
                    ),
                    const SizedBox(height: 16), // Added spacing
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFF24786D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
