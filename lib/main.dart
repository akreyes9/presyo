import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  // Always write this line when main() is async.
  WidgetsFlutterBinding.ensureInitialized();

  // Connect the app to the Supabase project.
  await Supabase.initialize(
    url: 'https://vhswppzzksdfwdfahkam.supabase.co/rest/v1/',
    anonKey: 'sb_publishable_j8b93w_-Il8fG8_pAznE-g_sEt6MiVX',
  );

  runApp(const MyApp());
}

// StatelessWidget = a widget that never changes after it is drawn.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // build() describes what this widget looks like.
  @override
  Widget build(BuildContext context) {
    // MaterialApp is the base of the whole app (themes, navigation, etc.).
    return MaterialApp(
      // remove debug marker on screen
      debugShowCheckedModeBanner: false,

      // "home" is the first page the user sees.
      home: LoginPage(),
    );
  }
}
