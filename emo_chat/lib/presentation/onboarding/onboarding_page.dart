import 'package:emo_chat/presentation/chat/chat_page.dart';
import 'package:emo_chat/presentation/home/home_page.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:emo_chat/presentation/users/users_page.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:animated_card_switcher/animated_card_switcher.dart';

import 'about_card.dart';
import 'login_card.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _loginFirst = true;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 64,
      color: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.deepOrange,
          blurRadius: 10,
        )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        OnboardingBackground(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Transform.rotate(angle: -12, child: Text("Face", style: textStyle)),
                Text("2", style: textStyle.copyWith(shadows: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                  )
                ])),
                Transform.rotate(angle: 12, child: Text("Face", style: textStyle)),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: AnimatedCardSwitcher(
                  firstChild: LoginCard(() {
                    setState(() {
                      _loginFirst = !_loginFirst;
                    });
                  }),
                  secondChild: AboutCard(() {
                    setState(() {
                      _loginFirst = !_loginFirst;
                    });
                  }),
                  state: _loginFirst ? CardSwitcherState.showFirst : CardSwitcherState.showSecond,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
