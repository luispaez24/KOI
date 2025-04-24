import 'package:flutter/material.dart';
import 'package:koi/pages/auth_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:koi/themes/dark.dart';
import 'package:koi/themes/light.dart';
import 'firebase_options.dart';
import 'package:koi/pages/edit_profile_page.dart';
import 'package:koi/pages/change_password_page.dart';
import 'package:koi/pages/about_us_page.dart';
import 'package:koi/themes/theme_mode_notifier.dart';
//theme_mode_notifier
//import '../profile.dart';
//final themeNotifier = ThemeModeNotifier();
void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase initialized successfully!');
  } catch (e) {
    print('❌ Firebase failed to initialize: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
 
  
  //get themeNotifier => null;

@override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentTheme,
          home: const Authpage(),
          routes: {
            '/login': (context) => const Authpage(),
            '/edit-profile': (context) => const EditProfilePage(),
            '/change-password': (context) => const ChangePasswordPage(),
            '/about-us': (context) => const AboutUsPage(),
          },
        );
      },
    );
  }
}


/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      //theme: lightTheme,
      //darkTheme: darkTheme,
      
      home: const Authpage(),

      routes: {
        '/login': (context) => const Authpage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/change-password': (context) => const ChangePasswordPage(),
        '/about-us': (context) => const AboutUsPage(),
      },
    );
  }
}



  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
//getting error dubble checking if its on login page 
      home: Authpage(),
      //home: Scaffold(
        //body: Center(child: Text('KOI Test')),
      //),
    );
  }
}*/