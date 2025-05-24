import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_app/screens/video-call_screen.dart';

class RegisteredUsersScreen extends StatefulWidget {
  const RegisteredUsersScreen({super.key});

  @override
  State<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  String currentUserID = '';
  String currentUserName = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  Future<void> getCurrentUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final name = doc.data()?['firstname'] ?? 'No name';
      setState(() {
        currentUserID = uid;
        currentUserName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Registered Users",
            style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading users"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("No users registered"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(6),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;

              // Debug print to inspect user data
              print('User Data: $user');

              // Skip current user from the list
              if (user['uid'] == currentUserID) {
                return const SizedBox.shrink();
              }

              return Card(
                color: Colors.grey[100],
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                child: ListTile(
                  title: Text(user['firstname'] ?? 'No name'),
                  subtitle: Text(user['email'] ?? 'No email'),
                  trailing: IconButton(
                    icon: const Icon(Icons.videocam_rounded,
                        size: 25, color: Colors.teal),
                    onPressed: () {
                      const yourAppID = 1882819428;
                      const yourAppSign =
                          '723bf23f41ab30d779b7fa1ca8ac171282db4e6ebd2f3f4e740fd8cd0561484e';

                      // Safe check for otherUserID
                      final otherUserID = (user['uid'] != null &&
                          user['uid'].toString().isNotEmpty)
                          ? user['uid']
                          : 'unknown_id';

                      final otherUserName = user['firstname'] ?? 'No name';

                      print("Clicked user ID: $otherUserID");

                      if (otherUserID == 'unknown_id') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text('User ID missing, cannot start call')),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallScreen(
                            appID: yourAppID,
                            appSign: yourAppSign,
                            userID: currentUserID,
                            userName: currentUserName,
                            otherUserID: otherUserID,
                            otherUserName: otherUserName,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}