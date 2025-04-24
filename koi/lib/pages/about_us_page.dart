import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'A health and productivity app created to help users achieve their goals by setting tasks.\n\n'
            'Created by Luis, Munira, and Lala.,.\nThank you for using our app!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}