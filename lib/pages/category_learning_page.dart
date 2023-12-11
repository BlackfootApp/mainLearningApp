import 'package:flutter/material.dart';

import 'quiz_page.dart';

class LearningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Party Talk'),
          backgroundColor: Colors.deepPurple,
        ),
        body: CardSlider(),
      ),
    );
  }
}

class CardSlider extends StatefulWidget {
  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  List<double> _sliderValues = [0.0, 0.0, 0.0];

  List<CardData> cardDataList = [
    CardData("English sentence 1", "Ikosi kiiyi miiksistookatsi 1"),
    CardData("English sentence 2",
        "Ikosi kiiyi miiksistookatsi 2 Ikosi kiiyi miiksistookatsi 2"),
    CardData("English sentence 3", "Ikosi kiiyi miiksistookatsi 3"),
  ];

  bool get isContinueButtonEnabled {
    return _sliderValues.every((value) => value >= 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return CardWidget(
                englishText: cardDataList[index].englishText,
                blackfootText: cardDataList[index].blackfootText,
                sliderValue: _sliderValues[index],
                onSliderChanged: (value) {
                  setState(() {
                    _sliderValues[index] = value;
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isContinueButtonEnabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizPage()),
                    );
                  }
                : null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey; // Disabled color
                  }
                  return Colors.deepPurple; // Enabled color
                },
              ),
            ),
            child: Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class CardData {
  final String englishText;
  final String blackfootText;

  CardData(this.englishText, this.blackfootText);
}

class CardWidget extends StatelessWidget {
  final String englishText;
  final String blackfootText;
  final double sliderValue;
  final ValueChanged<double> onSliderChanged;

  CardWidget({
    required this.englishText,
    required this.blackfootText,
    required this.sliderValue,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              englishText,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Stack(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.deepPurple,
                      inactiveTrackColor: Colors.deepPurple.withOpacity(0.3),
                      thumbColor: Colors.white,
                      overlayColor: Colors.deepPurple.withOpacity(0.2),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 20.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 20.0),
                    ),
                    child: Slider(
                      value: sliderValue,
                      onChanged: (value) {
                        onSliderChanged(1.0);
                      },
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                  if (sliderValue >= 1.0)
                    Positioned(
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(
                          blackfootText,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  if (sliderValue == 0.0)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.purple,
                        size: 20,
                      ),
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
