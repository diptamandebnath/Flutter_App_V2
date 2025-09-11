import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Auth/signup_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Home/home_page_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/textfromfield_box_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late int _num1;
  late int _num2;
  late int _captchaAnswer;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final rand = Random();
    _num1 = rand.nextInt(10); // 0 to 9
    _num2 = rand.nextInt(10);
    _captchaAnswer = _num1 + _num2;
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      int? enteredCaptcha = int.tryParse(captchaController.text.trim());

      if (enteredCaptcha != _captchaAnswer) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Incorrect CAPTCHA answer"),
            backgroundColor: Colors.orange,
          ),
        );
        _generateCaptcha();
        setState(() {});
        return;
      }

      try {
        final UserCredential user = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePageScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = e.message ?? "An unknown error occurred";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  AppStrings.enterEmailOr,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormFieldBoxUserWidget(
                controller: emailController,
                hintText: AppStrings.enterEmail,
                prefixIcon: Icons.mail_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFromFieldBoxPassword(
                controller: passwordController,
                hintText: AppStrings.enterPass,
                prefixIcon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 👇 CAPTCHA Field
              Text(
                "$_num1 + $_num2 = ?",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: captchaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter your answer",
                  prefixIcon: Icon(Icons.calculate),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please answer the CAPTCHA';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),
              InkWell(
                onTap: _submitLogin,
                child: const ButtonStyleWidget(
                  title: AppStrings.signIn,
                  colors: AppColors.blueColors,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: AppStrings.newTo,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: AppStrings.signUpNow,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
