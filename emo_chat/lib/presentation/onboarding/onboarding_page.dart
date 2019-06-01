import 'package:emo_chat/presentation/home/home_page.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        OnboardingBackground(),
        Center(
          child: RaisedButton(
            onPressed: () {
              loginGoogle(context);
            },
            child: Text("Login with google"),
          ),
        )
      ]),
    );
  }

  void loginGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);
    await Provider.of<UserState>(context).setUser(firebaseUser);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
