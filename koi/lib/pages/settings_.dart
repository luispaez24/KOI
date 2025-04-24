import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koi/themes/theme_mode_notifier.dart';
import 'package:koi/pages/edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void showComingSoon(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Container(
        decoration: isDark
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
          stream: usersCollection.doc(currentUser!.email).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 20),

                // Dark Mode Toggle
                SwitchListTile(
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                  value: themeNotifier.isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      themeNotifier.toggleTheme(value);
                    });
                  },
                ),

                // Private Account Toggle
                SwitchListTile(
                  title: Text(
                    "Private Account",
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                  value: userData['public'] ?? false,
                  onChanged: (bool value) {
                    usersCollection.doc(currentUser!.email).update({'public': value});
                  },
                  activeColor: Colors.green,
                ),

                // Settings List
                buildSettingsItem(Icons.edit, "Edit Profile", () {
                  Navigator.pushNamed(context, '/edit-profile');
                }, isDark),
                buildSettingsItem(Icons.lock_reset, "Change Password", () {
                  Navigator.pushNamed(context, '/change-password');
                }, isDark),
                buildSettingsItem(Icons.help_outline, "Help & Support", () {
                  showComingSoon(context, "Help & Support");
                }, isDark),
                buildSettingsItem(Icons.privacy_tip, "Privacy Policy", () {
                  showComingSoon(context, "Privacy Policy");
                }, isDark),
                buildSettingsItem(Icons.info_outline, "About Us", () {
                  Navigator.pushNamed(context, '/about-us');
                }, isDark),
                buildSettingsItem(Icons.app_settings_alt, "About", () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Koi App",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "© 2025 Luis Inc.",
                  );
                }, isDark),
                buildSettingsItem(Icons.logout, "Log Out", () => logout(context), isDark),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile buildSettingsItem(IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      onTap: onTap,
    );
  }
}