import 'package:emo_chat/presentation/onboarding/onboarding_page.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OnboardingPage(),
      ),
      providers: <SingleChildCloneableWidget>[
        Provider<UserState>.value(value: UserState()),
      ],
    );
  }
}
