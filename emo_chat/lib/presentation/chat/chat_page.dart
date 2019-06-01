import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_chat/infrastructure/firebase_message_mapper.dart';
import 'package:emo_chat/main.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:emo_chat/models/message.dart';
import 'package:emo_chat/models/user.dart';
import 'package:emo_chat/providers/message_notifier.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:emo_chat/utils/hash_utils.dart';
import 'package:emo_chat/main.dart';
import 'package:emo_chat/models/message.dart';
import 'package:emo_chat/models/user.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:emo_chat/providers/message_notifier.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:emo_chat/utils/hash_utils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ChatPage extends StatefulWidget {
  final User peerUser;

  @override
  _ChatPageState createState() => _ChatPageState(this.peerUser);

  ChatPage(this.peerUser);
}

class _ChatPageState extends State<ChatPage> {
  final messageMapper = FirebaseMessageMapper();
  final messageInputController = new TextEditingController();
  final listScrollController = new ScrollController();
  User peerUser;
  CameraController cameraController = CameraController(cameras[1], ResolutionPreset.medium);
  bool isAnalyzing = false;
  String text = "text";
  DateTime lastEyeDate = DateTime.now();

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
    var chatId =  getChatId(Provider.of<UserState>(context).user, peerUser);
    return Scaffold(
        appBar: _appBar(context),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('messages')
              .document(chatId)
              .collection(chatId)
              .orderBy('timestamp', descending: true)
              .limit(20)
              .snapshots(),
          builder: _build,
        ));
  }


  Widget _build(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    Widget body = Container();

    if(snapshot.data != null){
      body = ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => _getItem(context, index, snapshot.data.documents[index]),
        itemCount: snapshot.data.documents.length,
        reverse: true,
        controller: listScrollController,
      );
    }

    return Stack(
      children: <Widget>[
        OnboardingBackground(),
        Column(
          children: <Widget>[
            Expanded(
              child: body,
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
              child: _getInput(),
            )
          ],

        )
      ],
    );
  }


  Row _getInput() {
    return Row(
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
    );
  }

  int getItemsCount() => 200;

  Container _getItem(BuildContext context, int index, dynamic data) {
    if(data == null) return Container();
    if(data.data == null) return Container();

    Message message = messageMapper.mapMessage(data.data);
    User currentUser = Provider.of<UserState>(context).user;
    if (currentUser.id == message.from)
      return _getParentMessage(context, currentUser.name, message.content);

    return _getMessage(context, peerUser.name, message.content, message.hapiness);
  }

  Container _getParentMessage(BuildContext context, String _name, String text) => Container(
      decoration: _getMessageBoxDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_getNameText(_name, context), _getMessageText(text)],
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

  Container _getMessage(BuildContext context, String _name, String text, double happiness) => Container(
      decoration: _getMessageBoxDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _getNameText(_name, context),
                    _getMessageText(text),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: _getEmoti(happiness),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0x99FFBBDEFB),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          )));

  Image _getEmoti(double happiness) {
    var emoti = "images/ic_crying.png";

    if (happiness > 0.2) emoti = "images/ic_pensive.png";

    if (happiness > 0.6) emoti = "images/ic_slightly_smiling.png";

    if (happiness > 0.72) emoti = "images/ic_gringing.png";

    return Image.asset(
      emoti,
      width: 20,
      height: 20,
    );
  }

  Container _getMessageText(String text) {
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Text(text, style: TextStyle(color: Colors.black54)),
    );
  }

  void _sendMessage() async {
    var currentUser = Provider.of<UserState>(context).user;

    var message = messageInputController.text;
    var chatId = getChatId(currentUser, peerUser);
    var messageContent = Message(
        currentUser.id, peerUser.id, message, this._smilePercent, false);

    await Provider.of<MessageState>(context).sendMessage(messageContent, chatId);
    messageInputController.clear();
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
    final FaceDetectorOptions options = FaceDetectorOptions(enableClassification: true, enableLandmarks: true);
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

    var durationSinceLastEye = DateTime.now().difference(lastEyeDate);
    if ((_isOnlyRightEyeOpen() || _isOnlyLeftEyeOpen()) && durationSinceLastEye.inSeconds > 2) {

      lastEyeDate = DateTime.now();
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
