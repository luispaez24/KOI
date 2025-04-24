import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koi/componets/text_box.dart';
import 'package:koi/pages/settings_.dart';
import 'package:koi/pages/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection("Users");

    Future<void> editField(String field) async {
      String newValue = "";

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.orange[800],
          title: Text(
            "Edit $field",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.white70),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ],
        ),
      );

      if (newValue.trim().isNotEmpty) {
        await usersCollection.doc(currentUser!.email).update({field: newValue});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: Theme.of(context).brightness == Brightness.dark
    ? const BoxDecoration(
        color: Colors.black,
      )
    : const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFCC80)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.person, size: 72, color: Colors.white),
                  const SizedBox(height: 10),

                  if (currentUser != null)
                    Text(
                      currentUser.email ?? "No email available",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    )
                  else
                    const Text(
                      "No user logged in",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 50),

                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  MyTextBox(
                    text: userData['username'] ?? 'No username',
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),

                  MyTextBox(
                    text: userData['bio'] ?? 'No bio',
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),

                  const SizedBox(height: 50),

                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Posts',
                      style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
              );
            }

            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          },
        ),
      ),
    );
  }
}