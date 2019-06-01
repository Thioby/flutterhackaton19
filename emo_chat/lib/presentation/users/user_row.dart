import 'package:emo_chat/widgets/circle_image.dart';
import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  String name;
  String imageUrl;
  Function() onClick;

  UserRow(this.name, this.imageUrl, this.onClick);

  @override
  Widget build(BuildContext context) {
    return _buildRow(context);
  }

  Widget _buildRow(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: this.onClick,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _parishRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _parishRow(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBackground(),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleImage(imageUrl: imageUrl, width: 80, height: 80),
              SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BorderRadius _borderRadius() => BorderRadius.all(Radius.circular(9));

  Widget _buildBackground() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 39),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: _borderRadius()),
          ),
        ),
      ],
    );
  }
}
