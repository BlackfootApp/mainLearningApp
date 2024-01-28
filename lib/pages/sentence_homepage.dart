import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../riverpod/river_pod.dart';
import 'category_learning_page.dart';
import 'location_based_page.dart';
import 'quiz_page.dart';

class FeatureItem extends StatelessWidget {
  final String title;

  const FeatureItem(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Quiz') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizPage()),
          );
        } else if (title == 'Location Based') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationLearningPage()),
          );
        }
      },
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Color(0xFFcccbff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LearningPage(seriesName: title)),
        );
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: displaySeriesName(seriesId: title, returnText: true),
        ),
      ),
    );
  }
}

class SentenceHomePage extends ConsumerStatefulWidget {
  const SentenceHomePage({Key? key}) : super(key: key);

  @override
  _SentenceHomePageState createState() => _SentenceHomePageState();
}

class _SentenceHomePageState extends ConsumerState<SentenceHomePage> {
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    List<String> displayedSeriesNames = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation Learning"),
        backgroundColor: theme.lightPurple,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Text(
                'Features',
                style: theme.themeData.textTheme.headline6,
              ),
            ),
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  FeatureItem('Saved'),
                  FeatureItem('Quiz'),
                  FeatureItem('Location Based'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Text(
                'Categories',
                style: theme.themeData.textTheme.headline6,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                // Use FutureBuilder to fetch series names from Firestore
                future: _getSeriesNames(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: seriesNames.length,
                    itemBuilder: (context, index) {
                      return CategoryItem(seriesNames[index], Icons.category);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> seriesNames = [];
  Future _getSeriesNames() async {
    await FirebaseFirestore.instance.collection('ConversationTypes').get().then(
          (snapshot) => snapshot.docs.forEach(
            (doc) {
              seriesNames.add(doc.reference.id);
            },
          ),
        );
  }
}

class displaySeriesName extends StatelessWidget {
  final String seriesId;
  final bool returnText;

  displaySeriesName(
      {super.key, required this.seriesId, required this.returnText});

  @override
  Widget build(BuildContext context) {
    CollectionReference conversations =
        FirebaseFirestore.instance.collection('ConversationTypes');

    return FutureBuilder<DocumentSnapshot>(
      future: conversations.doc(seriesId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return returnText
              ? Text('${data['seriesName']}')
              : data['seriesName'];
        }
        return Text('loading');
      }),
    );
  }
}
