import 'package:emo_chat/presentation/users/users_page.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatelessWidget {

  VoidCallback onPressed;

  LoginCard(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 300, minHeight: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.deepOrange, spreadRadius: 2, blurRadius: 8),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("You must login to meet someone!", style: TextStyle(color: Colors.deepOrange, fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 72.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: Text("Login with Google!", style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    loginGoogle(context);
                  },

                ),
              ),
            ),
            OutlineButton(
              textColor: Colors.deepOrange,
              borderSide: BorderSide(color: Colors.deepOrange),
              onPressed: onPressed,
              child: Text("Show About!"),
            ),
          ],
        ),
      ),
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsersPage()));
  }
}
