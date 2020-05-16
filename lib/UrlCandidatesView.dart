import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:ocrurl/UrlModel.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:html' as html;

class UrlCandidatesView extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<UrlCandidatesView> {
  @override
  Widget build(BuildContext context) {
    final List<VisionText> _ocrExtracted =
        ModalRoute.of(context).settings.arguments;
    List<UrlModel> urlsCollection = buildUrlsCollection(_ocrExtracted);

    return Scaffold(
        appBar: AppBar(
          title: Text('Extracted Urls'),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: urlsCollection.length,
              itemBuilder: (context, index) {
                UrlModel _model = urlsCollection[index];
                return Column(children: <Widget>[
                  Divider(
                    height: 12.0,
                  ),
                  buildCard(_model)
                ]);
              }),
        ));
  }

  ListTile buildCard(UrlModel model) {
    return ListTile(
        //title: Text(model.origionalText),
      title: Linkify(
        text: '${model.origionalText}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        onOpen: (url) => _launchModelUrl(model),
      ),
        //subtitle: Text(model.getSubTitle()),
        subtitle: Linkify(
          text: '${model.getSubTitle()}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        trailing:
            //(model.urls != null && model.urls.length == 1)?
            model.canLaunch()
                ? Column(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right),
                      Expanded(
                        child: FlatButton(
                          onPressed: () => _launchModelUrl(model),
                          //child: Text('Launch')
                        ),
                      )
                    ],
                  )
                : null);
  }

  ListTile buildCard1(UrlModel model) {
    return ListTile(
        title: Text(model.origionalText),
        subtitle: Text(model.status),
        trailing:
            //(model.urls != null && model.urls.length == 1)?
            IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: _launchURL(model.urls.first),
        )
        //: null
        );
  }

  List<UrlModel> buildUrlsCollection(List<VisionText> texts) {
    List<UrlModel> urlsCollection = <UrlModel>[];
    List<String> words = <String>[];
    for (var text in texts) {
      for (TextBlock block in text.blocks) {
        for (TextLine line in block.lines) {
          //print('Line : '+line.text + '\n');
          //words.add(line.text);
          urlsCollection.add(UrlModel(origionalText: line.text));
        }
      }
    }
    return urlsCollection;
  }

  _launchModelUrl(UrlModel model) async {
    if (!model.canLaunch()) return null;
    _launchURL(model.urls.first);
    //tml.window.open('https://youtube.com', 'youtube');
  }

  _launchURL(String url) async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
