import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial values (you can replace these with values from Firestore if you're storing them there)
    _usernameController.text = 'luis'; // Replace with actual value from Firestore
    _bioController.text = 'Empty bio'; // Replace with actual value
    _emailController.text = currentUser?.email ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
     final uid = currentUser?.uid;
    if (uid == null) return;

    try {
    await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).set({
      'username': _usernameController.text,
      'bio': _bioController.text,
      'email': _emailController.text, 
    });
    // Logic to save changes to Firestore and/or Firebase Auth
    //print("Saving username: ${_usernameController.text}");
    //print("Saving bio: ${_bioController.text}");
    //print("Saving email: ${_emailController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully')),
    ); 
    }catch (e) {
      print("Error saving changes: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
  void deletePost(String postId) {
    // Logic to delete post (from Firebase if using Firestore)
    print("Deleting post with ID: $postId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.person, size: 72),
            const SizedBox(height: 20),

            // Username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Bio
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Save button
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const Text(
              "Your Posts",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text("Sample Post Title"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deletePost("postId"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}