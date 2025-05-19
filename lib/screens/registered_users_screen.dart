import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisteredUsersScreen extends StatelessWidget {
  const RegisteredUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.black),
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
              return Card(
                color: Colors.grey[100],
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                child: ListTile(
                  title: Text(user['firstname'] ?? 'No name'),
                  subtitle: Text(user['email'] ?? 'No email'),
                  trailing: IconButton(
                    icon: const Icon(Icons.videocam_rounded,size: 25,color: Colors.teal),
                    onPressed: () {
                      // You can add video call functionality here
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
