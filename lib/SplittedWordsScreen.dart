import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class SplittedWordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<VisionText> _currentLabels =
        ModalRoute.of(context).settings.arguments;
    //final Todo todo = ModalRoute.of(context).settings.arguments;
    List<String> words = extractWords(_currentLabels);

    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
            //title: Text(todo.title),
            ),
        body: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(words[index]),
              );
            }));
  }

  List<String> extractWords(List<VisionText> texts) {
    List<String> words = <String>[];
    for (var text in texts) {
      for (TextBlock block in text.blocks) {
        for (TextLine line in block.lines) {
          //print('Line : '+line.text + '\n');
          words.add(line.text);
        }
      }
    }
    return words;
  }
}
