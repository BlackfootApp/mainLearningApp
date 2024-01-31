import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

import '../../User/user_model.dart';
import '../../riverpod/river_pod.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({
    super.key,
  });

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {

  CarouselController buttonCarouselController = CarouselController();
  List<Data> savedWords = [];
  String uid = "";
  final player = AudioPlayer();
  @override
  initState() {
    final UserProvide = ref.read(userProvider);
    UserProvide.getSavedWords(UserProvide.uid);
    savedWords = UserProvide.savedWords;
    print("saved words ${savedWords.length}");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final UserProvide = ref.read(userProvider);
    UserProvide.getSavedWords(UserProvide.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvide = ref.watch(userProvider);
    return Stack(
      children: [
        Container(
          color:  Color(0xffbdbcfd),
          child: ListView.builder(
            itemBuilder: (context, index) {


                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Card(
                      child: ListTile(
                          title: Text(savedWords[index].blackfoot),
                          subtitle: Text(savedWords[index].english),
                          trailing: Container(
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 53.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      playAudio(savedWords[index].sound);
                                    },
                                    icon: const Icon(Icons.volume_down_outlined),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      final UserProvide = ref.read(userProvider);
                                      UserProvide.removeWord(savedWords[index].blackfoot);
                                      setState(() {
                                        savedWords.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                );


          },
            itemCount: savedWords.length,
          ),
        ),
      ],
    );
  }
  Future<void> playAudio(String Url) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String audioUrl = Url;

    try {
      // Get the download URL for the audio file
      Uri downloadUrl =Uri.parse(await storage.refFromURL(audioUrl).getDownloadURL()) ;

      // Play the audio using the audioplayers package
      await player.play(UrlSource( downloadUrl.toString()));
      print('Playing');
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }
}


