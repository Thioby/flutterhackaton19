import 'package:emo_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CameraController cameraController = CameraController(cameras[1], ResolutionPreset.medium);
  bool isAnalyzing = false;

  String text = "text";

  @override
  void initState() {
    super.initState();

    cameraController.initialize().then((_) {
      setState(() {});
      cameraController.startImageStream((image) {
        if (!isAnalyzing) {
          scanForFace(image);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        child: ListView.builder(
//        key: categoriesKey,
          reverse: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => _getItem(context, index),
          itemCount: getItemsCount(),
        ),
      ),
    );
  }

  int getItemsCount() => 200;

  Container _getItem(BuildContext context, int index) {
    if (index % 2 == 0)
      return _getParentMessage(context, "Rudy Nowak", "elo makrelo");

    return _getMessage(context, "Niebieski Nowak", "elo makrelo");
  }

  Container _getParentMessage(
          BuildContext context, String _name, String text) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getNameText(_name, context),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text,
                          style: TextStyle(color: Colors.black54)),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0x99FFFBE9E7),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )));

  Text _getNameText(String _name, BuildContext context) => Text(_name,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ));

  Container _getMessage(BuildContext context, String _name, String text) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getNameText(_name, context),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0x99FFBBDEFB),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )));

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("Chat"),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      );

  Future scanForText(CameraImage image) async {
    isAnalyzing = true;
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    debugPrint(visionText.text);
    isAnalyzing = false;
    setState(() {
      text = visionText.text;
    });
  }

  Future scanForFace(CameraImage image) async {
    isAnalyzing = true;
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation270);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final FaceDetectorOptions options = FaceDetectorOptions(enableClassification: true);
    final FaceDetector faceRecognizer = FirebaseVision.instance.faceDetector(options);
    final List<Face> faces = await faceRecognizer.processImage(visionImage);

    if(faces.isEmpty) {
      isAnalyzing = false;
      return;
    }

    var firstFace = faces[0];
    var smilePercent = firstFace.smilingProbability;
    var leftEyeOpenPercent = firstFace.leftEyeOpenProbability;
    var rightEyeOpenPercent = firstFace.rightEyeOpenProbability;

    debugPrint("smile prob: $smilePercent, leftEyeProb: $leftEyeOpenPercent, rightEyeProb: $rightEyeOpenPercent");
    isAnalyzing = false;
    setState(() {
//      text = visionText.text;
    });
  }
}
