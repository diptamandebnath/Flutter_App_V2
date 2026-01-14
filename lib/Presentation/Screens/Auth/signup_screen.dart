import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/AccountSetUp/im_looking_for_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/signup_checkbox_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/textfromfield_box_widget.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final User? user = userCredential.user;

        if (user != null) {
          await user.updateProfile(displayName: nameController.text.trim());
          
          // Send verification email
          await user.sendEmailVerification();

          // Inform the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('A verification email has been sent to your email address.'),
              backgroundColor: Colors.green,
            ),
          );
          
          await user.reload();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ImLookingForScreen(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "An unknown error occurred"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(AppImages.logofixitImg),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                AppStrings.enterEmailOr,
                style: TextStyle(fontSize: 24, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormFieldBoxUserWidget(
                controller: nameController,
                hintText: AppStrings.fullName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.pleaseEnterName;
                  }
                  return null;
                },
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              TextFormFieldBoxUserWidget(
                controller: emailController,
                hintText: AppStrings.enterEmail,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.pleaseEnterEmail;
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                prefixIcon: Icons.mail_rounded,
              ),
              const SizedBox(height: 16),
              TextFromFieldBoxPassword(
                controller: passwordController,
                hintText: AppStrings.enterPass,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.pleaseEnterPass;
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 8),
              const SignupCheckBoxWidget(),
              const SizedBox(height: 24),
              InkWell(
                onTap: _submitForm,
                child: const ButtonStyleWidget(
                  title: AppStrings.signUp,
                  colors: AppColors.blueColors,
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: AppStrings.alreadyAccount,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: AppStrings.signInNow,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
