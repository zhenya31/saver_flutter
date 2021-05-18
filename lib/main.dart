import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:saver/screens/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.notification.title}");
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Saver',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: Center(child: Text('Ошибика')),
            debugShowCheckedModeBanner: false,
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Saver',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        }

        return MaterialApp(
          title: 'Saver',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: Center(child: CircularProgressIndicator()),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
