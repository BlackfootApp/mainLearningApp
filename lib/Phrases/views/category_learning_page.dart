import 'dart:async';

import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/widgets/card_slider.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/vocabulary/viwes/v_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../LearningTime/models/learning_time.dart';
import '../../User/user_provider.dart';
import '../../commitment_time/Achievement.dart';
import '../../riverpod/river_pod.dart';

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;
  final List<CardData> data;
  final bool isVocabPresent;

  const LearningPage({
    super.key,
    required this.seriesName,
    required this.data,
    required this.isVocabPresent,
  });

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  int? currentPlayingIndex;
  late DateTime start;
  late UserProvider userProvide;
  int totalSeconds = 1;
  int dailyGoalInSeconds = 0;
  @override
  void initState() {
    start = DateTime.now();
    userProvide = ref.read(userProvider);
    _fetchLearningTimeData();
    totalSeconds = userProvide.getUserTodayLearningTime();
    dailyGoalInSeconds = userProvide.getUserDailyGoalInSeconds();
    int timeRemain = dailyGoalInSeconds - totalSeconds;
    Duration d = new Duration(seconds: timeRemain > 0 ? timeRemain : 1);
    Timer(d, handleTimeout);
    super.initState();
  }

  @override
  dispose() {
    userProvide.saveUserLearningTime(start, 4);
    super.dispose();
  }

  void handleTimeout() {
    userProvide.popupArchivementPage(context);
  }

  Future<void> _fetchLearningTimeData() async {
    await userProvide.getSavedLearningTime(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final blogProviderObj = ref.watch(blogProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: customAppBar(context: context, title: widget.seriesName),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: widget.data.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: CardSlider(
                        cardDataList: widget.data,
                        currentPlayingIndex: currentPlayingIndex,
                        onSavedButtonPressed: (index) {
                          blogProviderObj.toggleSavedPhrase(widget.data[index]);
                        },
                        onPlayButtonPressed: (index) {
                          setState(() {
                            if (currentPlayingIndex == index) {
                              currentPlayingIndex = null;
                            } else {
                              currentPlayingIndex = index;
                            }
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: widget.isVocabPresent
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VocabularyGame(
                                        category: widget.seriesName,
                                        uid: userProvide.uid),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 32.0,
                                ),
                                backgroundColor: purpleLight,
                              ),
                              child:
                                  const Text('Explore related vocabularies?'),
                            )
                          : null,
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
