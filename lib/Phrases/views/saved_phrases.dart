import 'package:bfootlearn/Phrases/widgets/card_slider.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import '../../LearningTime/models/learning_time.dart';
import '../../User/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commitment_time/Achievement.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  int? currentPlayingIndex;
  final DateTime start = DateTime.now();
  int totalSeconds = 0;
  int dailyGoalInSeconds = 0;
  bool isPopupCongratsPage = false;

  late UserProvider userProvide;

  @override
  void initState() {
    userProvide = ref.read(userProvider);
    _fetchLearningTimeData();
    super.initState();
  }

  void saveLearningTime() async {
    LearningTime time =
        new LearningTime(startTime: start, endTime: DateTime.now(), model: 5);

    await userProvide.saveLearningTime(time);
  }

  Future<void> _fetchLearningTimeData() async {
    await userProvide.getSavedLearningTime(DateTime.now());
    totalSeconds = userProvide.getUserTodayLearningTime();
    dailyGoalInSeconds = userProvide.getUserDailyGoalInSeconds();
    isPopupCongratsPage = userProvide.getUserIsPopUpCongratsPage();
    if (totalSeconds >= dailyGoalInSeconds && !isPopupCongratsPage) {
      userProvide.updateIsPopupCongratsPage(true);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CongratulationPage(message: 'Awesome!'),
        ),
      );
    }
  }

  @override
  dispose() {
    saveLearningTime();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogProviderObj = ref.watch(blogProvider);
    final savedBlogs = blogProviderObj.getUserPhraseProgress().savedPhrases;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Saved Phrases'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: savedBlogs.isEmpty
            ? const Center(
                child: Text(
                  'No Saved Phrases',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : CardSlider(
                cardDataList: savedBlogs,
                currentPlayingIndex: currentPlayingIndex,
                onSavedButtonPressed: (index) {
                  blogProviderObj.toggleSavedPhrase(savedBlogs[index]);
                },
                onPlayButtonPressed: (index) {
                  setState(() {
                    if (currentPlayingIndex == index) {
                      // Stop if the same button is pressed again
                      currentPlayingIndex = null;
                    } else {
                      // Play the clicked audio
                      currentPlayingIndex = index;
                    }
                  });
                },
              ),
      ),
    );
  }
}
