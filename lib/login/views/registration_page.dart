import 'package:bfootlearn/User/user_model.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../helper/helper_functions.dart';
import '../widget/fadein_animation.dart';
import '../widget/login_theme_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();
  bool showPassword = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    confirmPwdController.dispose();
    super.dispose();
  }

  void registerUser() async {
    final userProvide = ref.read(userProvider);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    if (passwordController.text != confirmPwdController.text) {
      Navigator.pop(context);
      displaySnackBarMessageToUser("Passwords don't match", context);
    } else {
      try {
        Navigator.pop(context);
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.toLowerCase(),
                password: passwordController.text);
        if (userCredential.user != null) {
          await userProvide.createUserInDb(
              UserModel(
                name:
                    userCredential.user!.displayName ?? userNameController.text,
                uid: userCredential.user!.uid,
                imageUrl: userCredential.user!.photoURL ?? '',
                role: 'user',
                score: 0,
                rank: 0,
                dailyGoal: 30,
                heart: 0,
                userName: userNameController.text.split('@').first,
                email: emailController.text.toLowerCase(),
                savedWords: [],
                savedPhrases: [],
                savedLearningTime: [],
                badge: CardBadge(
                    kinship: false,
                    direction: false,
                    classroom: false,
                    time: false,
                    weather: false),
                joinedDate: DateTime.now().toString(),
              ),
              userCredential.user!.uid);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        String errorMessage = e.code.replaceAll('-', ' ');
        errorMessage =
            errorMessage[0].toUpperCase() + errorMessage.substring(1);
        displaySnackBarMessageToUser(errorMessage, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            LoginPageTop(),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const FadeIn(
                    child: Text(
                      "Hello There!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: purpleLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                        controller: userNameController,
                        textColor: purpleLight,
                        labelText: 'User Name',
                        obscureText: false),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                        controller: emailController,
                        textColor: purpleLight,
                        labelText: 'Email',
                        obscureText: false),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                      controller: passwordController,
                      textColor: purpleLight,
                      labelText: 'Password',
                      obscureText: true,
                      suffix: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    child: MyTextField(
                      controller: confirmPwdController,
                      textColor: purpleLight,
                      labelText: 'Confirm Password',
                      obscureText: true,
                      suffix: true,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeIn(
                    child: MyButton(
                      text: "Register",
                      onTap: registerUser,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login Here",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
