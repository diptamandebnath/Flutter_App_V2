import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_home_service_provider_app_clone/AppUtils/app_images.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Auth/signup_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Home/home_page_screen.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Screens/Home/worker_home_page.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/button_style_widget.dart';
import 'package:flutter_home_service_provider_app_clone/Presentation/Widgets/textfromfield_box_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _workerFormKey = GlobalKey<FormState>();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late int _num1;
  late int _num2;
  late int _captchaAnswer;
  bool _otpSent = false;
  String? _generatedOtp;
  String? _pickedFileName;

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
    captchaController.clear();
  }

  Future<void> _submitLogin(bool isUser) async {
    final formKey = isUser ? _userFormKey : _workerFormKey;
    final emailController = userEmailController;
    final passwordController = userPasswordController;

    if (formKey.currentState!.validate()) {
      int? enteredCaptcha = int.tryParse(captchaController.text.trim());

      if (enteredCaptcha != _captchaAnswer) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("incorrectCaptcha".tr()),
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
            errorMessage = 'noUserEmail'.tr();
            break;
          case 'wrong-password':
            errorMessage = 'incorrectPass'.tr();
            break;
          case 'invalid-email':
            errorMessage = 'invalidEmail'.tr();
            break;
          default:
            errorMessage = e.message ?? "unknownError".tr();
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

  Future<void> _forgotPassword(bool isUser) async {
    final emailController = userEmailController;
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("enterEmailToReset".tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("passResetLink".tr()),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'noUserEmail'.tr();
          break;
        case 'invalid-email':
          errorMessage = 'invalidEmail'.tr();
          break;
        default:
          errorMessage = "errorOccurred".tr();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _sendOtp() {
    int? enteredCaptcha = int.tryParse(captchaController.text.trim());
    if (enteredCaptcha != _captchaAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("incorrectCaptcha".tr()),
          backgroundColor: Colors.orange,
        ),
      );
      _generateCaptcha();
      setState(() {});
      return;
    }

    if (_workerFormKey.currentState!.validate()) {
      // In a real app, you would integrate with an Aadhaar OTP service here.
      // For this demo, we'll just generate a random 6-digit OTP.
      _generatedOtp = (100000 + Random().nextInt(900000)).toString();
      setState(() {
        _otpSent = true;
      });

      // Show a message with the generated OTP for the user to enter
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your OTP is: $_generatedOtp'),
          duration: const Duration(seconds: 10), // Keep it on screen longer
        ),
      );
    }
  }

  void _verifyOtpAndLogin() {
    int? enteredCaptcha = int.tryParse(captchaController.text.trim());
    if (enteredCaptcha != _captchaAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("incorrectCaptcha".tr()),
          backgroundColor: Colors.orange,
        ),
      );
      _generateCaptcha();
      setState(() {});
      return;
    }

    if (_workerFormKey.currentState!.validate()) {
      if (_otpController.text == _generatedOtp) {
        // OTP is correct, simulate successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aadhaar authentication successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WorkerHomePage(aadharNo: _aadhaarController.text.trim()),
          ),
        );
      } else {
        // Incorrect OTP
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickAadhaarXML() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );

    if (result != null) {
      setState(() {
        _pickedFileName = result.files.single.name;
      });
    }
  }

  void _loginWithXML() {
    if (_pickedFileName != null) {
      // In a real app, you would parse the XML and verify the Aadhaar details.
      // For this demo, we'll just simulate a successful login.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aadhaar XML authentication successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WorkerHomePage(aadharNo: _aadhaarController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload the Aadhaar eKYC XML file first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Image.asset(AppImages.logofixitImg),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'userLogin'.tr()),
              Tab(text: 'workerLogin'.tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoginForm(isUser: true),
            _buildLoginForm(isUser: false),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool isUser}) {
    final formKey = isUser ? _userFormKey : _workerFormKey;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUser)
                ...[
                  Center(
                    child: Text(
                      'userLogin'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormFieldBoxUserWidget(
                    controller: userEmailController,
                    hintText: 'enterEmail'.tr(),
                    prefixIcon: Icons.mail_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enterYourEmail'.tr();
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'enterValidEmail'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFromFieldBoxPassword(
                    controller: userPasswordController,
                    hintText: 'enterPass'.tr(),
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enterYourPass'.tr();
                      }
                      if (value.length < 6) {
                        return 'passMin6'.tr();
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _forgotPassword(isUser),
                      child: Text(
                        'forgotPassword'.tr(),
                        style: const TextStyle(
                          color: AppColors.blueColors,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCaptchaFields(),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () => _submitLogin(isUser),
                    child: ButtonStyleWidget(
                      title: 'signIn'.tr(),
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
                      child: Text.rich(
                        TextSpan(
                          text: 'newTo'.tr(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: 'signUpNow'.tr(),
                              style: const TextStyle(
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
                ]
              else
                ...[
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          AppImages.aadhaarLogoImg,
                          height: 80,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'aadhaarLogin'.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_otpSent) ...[
                    TextFormField(
                      controller: _aadhaarController,
                      decoration: InputDecoration(
                        hintText: 'enterAadhaar'.tr(),
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_pickedFileName == null) {
                          if (value == null || value.isEmpty) {
                            return 'pleaseEnterAadhaar'.tr();
                          }
                          if (value.length != 12) {
                            return 'aadhaarMustBe12Digits'.tr();
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCaptchaFields(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _sendOtp,
                      child: ButtonStyleWidget(
                        title: 'sendOtp'.tr(),
                        colors: AppColors.blueColors,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'or'.tr(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickAadhaarXML,
                      child: Text('uploadAadhaar'.tr()),
                    ),
                    if (_pickedFileName != null) ...[
                      const SizedBox(height: 12),
                      Text('Picked file: $_pickedFileName'),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: _loginWithXML,
                        child: ButtonStyleWidget(
                          title: 'login'.tr(),
                          colors: AppColors.blueColors,
                        ),
                      ),
                    ]
                  ] else ...[
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        hintText: 'enterOtp'.tr(),
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pleaseEnterOtp'.tr();
                        }
                        if (value.length != 6) {
                          return 'otpMustBe6Digits'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCaptchaFields(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _verifyOtpAndLogin,
                      child: ButtonStyleWidget(
                        title: 'login'.tr(),
                        colors: AppColors.blueColors,
                      ),
                    ),
                  ]
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptchaFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$_num1 + $_num2 = ?",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: captchaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "enterYourAns".tr(),
            prefixIcon: const Icon(Icons.calculate),
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'ansCaptcha'.tr();
            }
            if (int.tryParse(value.trim()) == null) {
              return 'enterValidNum'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
