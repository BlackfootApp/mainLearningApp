import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:share_plus/share_plus.dart';
import "package:collection/collection.dart";
import '../LearningTime/models/learning_time.dart';
import '../User/user_provider.dart';
import '../riverpod/river_pod.dart';

class CongratulationPage extends StatelessWidget {
  final String message;
  int dailyGloal = 30;
  int totalDays = 1;
  CongratulationPage(
      {Key? key,
      required this.message,
      required this.dailyGloal,
      required this.totalDays})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Achievement'),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Achivement_page.png',
                  height: 250,
                  width: 250,
                ),
                ScaleAnimatedTextKit(
                  text: ["Congratulations!", "You did it!"],
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Chewy',
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Color(0xffbdbcfd),
                          Color.fromARGB(255, 175, 145, 230),
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                  ),
                  textAlign: TextAlign.center,
                  totalRepeatCount: 100,
                ),
                SizedBox(height: 30),
                Text(
                  'You got an achievement!',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Chewy',
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Color(0xffbdbcfd),
                          Color.fromARGB(255, 175, 145, 230),
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 100),
                ElevatedButton.icon(
                  onPressed: () {
                    final text =
                        'I completed my daily goal of $dailyGloal minutes on I\'poyít, and I have studied for a total of $totalDays days.'
                        ' Come join me and let\'s see! https://play.google.com/store/apps/details?id=com.bfootlearn.bfootlearn';
                    final result = Share.share(text);
                    // if (result.status == ShareResultStatus.success) {
                    //    print('score shared');
                    //  }
                  },
                  icon: Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    elevation: 10,
                    shadowColor: Color.fromARGB(255, 58, 13, 79),
                    backgroundColor: Color.fromARGB(255, 175, 145, 230),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/confetti.json', // Replace with actual file path
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CongratulationPage(
      message: 'You have completed your daily learning goal!',
      dailyGloal: 1,
      totalDays: 30,
    ),
  ));
}
