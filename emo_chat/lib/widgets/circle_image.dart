import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const CircleImage({Key key, this.imageUrl, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
        border: Border.all(color: Colors.deepOrange, width: 2)
      ),
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          image: imageUrl,
          fit: BoxFit.cover,
          placeholder: "",
        ),
      ));
}
