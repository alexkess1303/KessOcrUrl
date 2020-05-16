import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:ocrurl/UrlCandidatesView.dart';
//import 'package:mlkit/mlkit.dart';

import 'ChatView.dart';
import 'ResultsPainter.dart';
import 'SplittedWordsScreen.dart';
import 'TextDetectPainter.dart';

class OcrUrlApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OcrUrlHomePage(),
    );
  }
}

class OcrUrlHomePage extends StatefulWidget {
  @override
  _FlutterVisionHomePageState createState() => _FlutterVisionHomePageState();
}

class _FlutterVisionHomePageState extends State<OcrUrlHomePage> {
  bool isLoading = false;
  File _imageFile;

  //FirebaseVisionImage _firebaseVisionImage;
  //List<Face> _faces = <Face>[];
  ui.Image _image;

  //File _file;
  List<VisionText> _currentLabels = <VisionText>[];
  List<String> _extractedWords = <String>[];

  //FirebaseVisionTextDetector detector = FirebaseVisionTextDetector.instance;
  final TextRecognizer textRecognizer = FirebaseVision.instance
      .textRecognizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            displayImageOrMessage(),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SplittedWordsScreen(),
                        settings: RouteSettings(
                            arguments: _currentLabels
                        )
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.all_inclusive, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                        settings: RouteSettings(
                            arguments: _currentLabels
                        )
                    )
                );
              },
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => UrlCandidatesView(),
                            settings: RouteSettings(
                                arguments: _currentLabels
                            )
                        )
                    );
                  },
                  tooltip: 'Analyze',
                  icon: Icon(Icons.send, color: Colors.white),
                  label: Text("Analyze"),
                  heroTag: null,
                  //child: Icon(Icons.send, color: Colors.white),
                ),
              ),),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: _buttonPressedSelectImage,
                tooltip: 'Select Image',
                icon: Icon(Icons.image),
                label: Text("Select"),
                  heroTag: null
                //child: Icon(Icons.add_a_photo),
              ),
            ),
          ],
        )
    );
  }

  void _buttonPressedAnalyzeImage(BuildContext context)
  {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => SplittedWordsScreen(),
            settings: RouteSettings(
                arguments: _currentLabels
            )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget displayImageOrMessage() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : (_imageFile == null)
        ? Center(child: Text('No image selected'))
        : Center(
      child: FittedBox(
        child: SizedBox(
          width: _image.width.toDouble(),
          height: _image.height.toDouble(),
          child: Container(
            foregroundDecoration: TextDetectDecoration(
                _currentLabels,
                Size(_image.width.toDouble(),
                    _image.height.toDouble())),
            child: Image.file(
              _imageFile,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

/*
  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = new Completer<Size>();
    image.image.resolve(new ImageConfiguration()).addListener(
            (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
*/
  Future _buttonPressedSelectImage() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _currentLabels.clear();
      isLoading = true;
    });

    //Detect
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    //var currentLabels = await detector.detectFromPath(imageFile.path);
    final VisionText visionText =
    await textRecognizer.processImage(visionImage);
    //End of Detect
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _currentLabels.add(visionText);

        //_currentLabels = currentLabels;
        _loadImage(imageFile);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
          (value) =>
          setState(() {
            _image = value;
            isLoading = false;
          }),
    );
  }
}
