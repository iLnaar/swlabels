
/*
Заготовка SWLabels example


import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart' as sw
    show SpriteWidget, NodeWithSize;
import 'package:swlabels/swlabels.dart';

enum Status { menu, game }

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //AutoOrientation.landscapeLeftMode();
    return MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}


class _GameState extends State<Game> {
  var initComplete = false;
  Size screenSize;
  sw.NodeWithSize rootNode;
  SWLabels swLabels;
  var status = Status.game;


  @override
  void initState() {
    super.initState();

    final map = Map<String, String>();
    print(map);
  }


  Future<bool> waitingInit() async {
    if (initComplete)
      return true;

    screenSize = MediaQuery.of(context).size / MediaQuery.of(context).devicePixelRatio;
    rootNode = sw.NodeWithSize(screenSize);
    swLabels = SWLabels(rootNode, 20, 3);
    initComplete = true;
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitingInit(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return sw.SpriteWidget(rootNode);
          }
          else if (snapshot.hasError) {
            return Container(child: Text('ERROR ${snapshot.error}'));
          }
          else {
            return Container(child: Text('No DATA'));
          }
        }
    );
  }
}


 */