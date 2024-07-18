import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bfootlearn/components/custom_appbar.dart';

class CongratulationPage extends StatelessWidget {
  final String message;

  const CongratulationPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Learning Goal'),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Achivement_page.png',
                  // 设置图片的高度和宽度，或者使用alignment属性进行控制。
                  height: 250,
                  width: 250,
                ),
                SizedBox(height: 20),
                Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                Text(
                  'You got an achievement!',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // 可以添加分享功能
                  },
                  child: Text('Share'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Lottie.asset(
              'assets/confetti.json', // 替换成实际的文件路径
              fit: BoxFit.cover,
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
    ),
  ));
}
