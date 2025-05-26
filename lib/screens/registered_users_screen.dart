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
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/design2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          Column(
            children: [
              const SizedBox(height: 200),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),


              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading users"));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final users = snapshot.data!.docs;

                    final filteredUsers = users.where((doc) {
                      final user = doc.data() as Map<String, dynamic>;
                      final name = user['firstname']?.toString().toLowerCase() ?? '';
                      return user['uid'] != currentUserID && name.contains(searchQuery);
                    }).toList();

                    if (filteredUsers.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    return ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: filteredUsers.map((doc) {
                          final user = doc.data() as Map<String, dynamic>;

                          return ListTile(
                            tileColor: Colors.white.withOpacity(0.85),
                            title: Text(
                              user['firstname'] ?? 'No name',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              user['email'] ?? 'No email',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.videocam_rounded,
                                size: 25,
                                color: Color(0xFF1E3D8F),
                              ),
                              onPressed: () {
                                const yourAppID = 1882819428;
                                const yourAppSign = '723bf23f41ab30d779b7fa1ca8ac171282db4e6ebd2f3f4e740fd8cd0561484e';

                                final otherUserID = user['uid'] ?? 'unknown_id';
                                final otherUserName = user['firstname'] ?? 'No name';

                                if (otherUserID == 'unknown_id') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('User ID missing, cannot start call'),
                                    ),
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
                          );
                        }),
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
