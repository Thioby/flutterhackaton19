import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  VoidCallback onPressed;

  AboutCard(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 300, minHeight: 200, maxWidth: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.deepOrange, spreadRadius: 2, blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: OutlineButton(
                textColor: Colors.deepOrange,
                borderSide: BorderSide(color: Colors.deepOrange),
                onPressed: onPressed,
                child: Text("Sign in!"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "This is Flutter Hack 19 Face2Face application. It's allow users to know true emotions of the conversation partner",
                style: TextStyle(color: Colors.deepOrange, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
