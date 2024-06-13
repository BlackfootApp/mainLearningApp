import 'package:bfootlearn/Home/widgets/bootomnavItems.dart';
import 'package:bfootlearn/User/user_profile_screen.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../login/views/reset_password.dart';
import '../../notifications/notification_page.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    final leaderBoardRepo = ref.read(leaderboardProvider);
    final UserProvide = ref.read(userProvider);
    //leaderBoardRepo.addToLeaderBoard(UserProvide.name??"", UserProvide.score);
    //UserProvide.getScore(UserProvide.uid);
    //UserProvide.setScore(UserProvide.score);
    super.initState();
  }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void handlePopupMenuSelection(String value) {
    switch (value) {
      case 'signOut':
        FirebaseAuth.instance.signOut();
        break;
      case 'changePassword':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordChangePage()),
        );
        break;
      case 'localNotifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  AppBar buildAppBar(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final vProvider = ref.watch(vocaProvider);
    return AppBar(
      backgroundColor: theme.lightPurple,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfileScreen()));
            },
            child: CircleAvatar(
              backgroundColor: theme.lightPurple,
              radius: 23,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(FirebaseAuth
                        .instance.currentUser!.photoURL ??
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
              ),
            ),
          ),
          Visibility(
            visible: vProvider.currentPage == 1 ? true : false,
            child: const Text("LeaderBoard"),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: handlePopupMenuSelection,
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'signOut',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'localNotifications',
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'changePassword',
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Change Password'),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: BottomNavItem.bottomNavItems(ref.watch(vocaProvider).currentPage,
          ref.watch(themeProvider).themeData),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar:
          BottomNavItem.bottomBar(ref, ref.watch(themeProvider).themeData),
    );
  }
}
