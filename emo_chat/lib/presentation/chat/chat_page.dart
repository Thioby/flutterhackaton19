import 'package:emo_chat/main.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:emo_chat/main.dart';
import 'package:emo_chat/models/message.dart';
import 'package:emo_chat/models/user.dart';
import 'package:emo_chat/providers/message_notifier.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:emo_chat/utils/hash_utils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final User peerUser;

  @override
  _ChatPageState createState() => _ChatPageState(this.peerUser);

  ChatPage(this.peerUser);
}

class _ChatPageState extends State<ChatPage> {
  CameraController cameraController = CameraController(cameras[1], ResolutionPreset.medium);
  bool isAnalyzing = false;
  User peerUser;
  final messageInputController = new TextEditingController();
  String text = "text";

  double _smilePercent;

  double _leftEyeOpenPercent;

  double _rightEyeOpenPercent;

  _ChatPageState(this.peerUser);

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
        body: Stack(
          children: <Widget>[
            OnboardingBackground(),
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => _getItem(context, index),
                    itemCount: getItemsCount(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -7),
                        blurRadius: 10,
                        spreadRadius: -15,
                        color: Colors.black26,
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageInputController,
                          decoration: InputDecoration(
                            hintText: "Type message",
                          ),
                        ),
                      ),
                      FlatButton(
                        child: Text("Send"),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  int getItemsCount() => 200;

  Container _getItem(BuildContext context, int index) {
    if (index % 2 == 0) return _getParentMessage(context, "Rudy Nowak", "elo makrelo");

    return _getMessage(context, "Niebieski Nowak", "elo makrelo");
  }

  Container _getParentMessage(BuildContext context, String _name, String text) => Container(
      decoration: _getMessageBoxDecoration(),
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
                  child: new Text(text, style: TextStyle(color: Colors.black54)),
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

  Container _getMessage(BuildContext context, String _name, String text) => Container(
      decoration: _getMessageBoxDecoration(),
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

  void _sendMessage() async {
    var currentUser = Provider.of<UserState>(context).user;

    var message = messageInputController.text;
    var chatId = getChatId(currentUser, peerUser);
    var messageContent = Message(currentUser, peerUser, message, chatId, this._smilePercent, false);

    await Provider.of<MessageState>(context).sendMessage(messageContent);
  }

  BoxDecoration _getMessageBoxDecoration() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 10,
        spreadRadius: -15,
        color: Colors.black26,
      )
    ]);
  }

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
    messageInputController.text = visionText.text;
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

    if (faces.isEmpty) {
      isAnalyzing = false;
      return;
    }

    var firstFace = faces[0];
    var smilePercent = firstFace.smilingProbability;
    var leftEyeOpenPercent = firstFace.leftEyeOpenProbability;
    var rightEyeOpenPercent = firstFace.rightEyeOpenProbability;

    debugPrint("smile prob: $smilePercent, leftEyeProb: $leftEyeOpenPercent, rightEyeProb: $rightEyeOpenPercent");
    isAnalyzing = false;

    this._smilePercent = smilePercent;
    this._leftEyeOpenPercent = leftEyeOpenPercent;
    this._rightEyeOpenPercent = rightEyeOpenPercent;

    if (_isOnlyRightEyeOpen() || _isOnlyLeftEyeOpen()) {
      debugPrint("oczko");
    }

    setState(() {
      //            text = visionText.text;
    });
  }

  bool _isOnlyRightEyeOpen() => _leftEyeOpenPercent > 0.5 && _rightEyeOpenPercent < 0.5;

  bool _isOnlyLeftEyeOpen() => _leftEyeOpenPercent < 0.5 && _rightEyeOpenPercent > 0.5;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
