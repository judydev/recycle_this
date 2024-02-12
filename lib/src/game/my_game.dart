import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recycle_this/src/main_menu.dart';
import 'package:recycle_this/src/game/tappable.dart';

int colCount = 10;

class MyGame extends StatefulWidget {
  const MyGame({super.key});
  static const routeName = '/startgame';

  @override
  State<MyGame> createState() => _MyGameState();
}

enum Categories { can, cup, paper, bottle, clothes, furniture, electronics }

List countMap = [
  {'category': Categories.can.name, 'count': 14},
  {'category': Categories.cup.name, 'count': 7},
  {'category': Categories.paper.name, 'count': 12},
  {'category': Categories.bottle.name, 'count': 12},
  {'category': Categories.clothes.name, 'count': 12},
  {'category': Categories.furniture.name, 'count': 12},
  {'category': Categories.electronics.name, 'count': 12},
];

class _MyGameState extends State<MyGame> {
  late final String? chosenCategory;
  late List<Widget> spriteList = [];

  Set<int> found = {};
  Set<int> wrong = {};
  Set<int> expected = {};

  Timer _timer = Timer(Duration.zero, () {});
  int secondsLeft = 30;

  @override
  void initState() {
    super.initState();

    chosenCategory = Categories.values[Random().nextInt(Categories.values.length)].name;

    spriteList = generateSpriteList();
    spriteList.shuffle();

    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 0) {
        setState(() {
          timer.cancel();
        });

        showDialog(
            context: context,
            builder: (context) {
              return Dialog.fullscreen(
                  child: Column(
                children: [
                  const Text('Sorry you did not make it'),
                  replayButton(context),
                  homeButton(context)
                ],
              ));
            });
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chosenCategory == null) {
      Navigator.popAndPushNamed(context, MainMenu.routeName);
      return Scaffold(
        appBar: AppBar(),
        body: const Text('Error, please go back to the menu'),
      );
    }

    return Scaffold(
        appBar: AppBar(
            leading: Text('${secondsLeft}s'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    _timer.cancel();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog.fullscreen(
                              child: Column(
                            children: [
                              const Text('Paused'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    startTimer();
                                  },
                                  child: const Text('Continue')),
                              homeButton(context),
                            ],
                          ));
                        });
                  },
                  icon: const Icon(Icons.pause))
            ],
            title: Text(chosenCategory!)),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected: ${found.length}/; Wrong: ${wrong.length}'),
              const Padding(padding: EdgeInsets.all(10)),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  // height: 2000,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.blue[100]!,
                        Colors.lightBlueAccent,
                        Colors.blueGrey[50]!,
                        Colors.blueGrey[400]!,
                        Colors.lightBlueAccent,
                        Colors.blueAccent,
                        Colors.blue[900]!,
                        Colors.blueGrey[800]!,
                      ])),
                  child: Expanded(
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: colCount,
                        children: spriteList),
                  )),
              // Expanded(
              //     child: GridView.count(
              //         shrinkWrap: true,
              //         crossAxisCount: colCount,
              //         children: spriteList)),
            ],
          ),
        )));
  }

  generateSpriteList() {
    List<Widget> list = [];
    int keyId = 0;
    for (final json in countMap) {
      list.addAll(List.generate(json['count'], (i) {
        keyId++;
        if (json['category'] == chosenCategory) {
          expected.add(keyId);
        }

        return Tappable(
            id: keyId,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  Random().nextDouble() * 2 * pi,
                ),
                child: Image.asset(
                    'assets/images/${json['category']}/${json['category']}-${i + 1}.png',
                    width: 40,
                    height: 50)),
            onTap: (id) {
              if (chosenCategory == json['category']) {
                setState(() {
                  found.add(id);
                  expected.remove(id);
                });
              } else {
                setState(() {
                  secondsLeft -= 2;
                  wrong.add(id);
                });
              }

              if (expected.isEmpty) {
                _timer.cancel();
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                          child: SizedBox(
                              child: Column(children: [
                        const Text('You made it!'),
                        replayButton(context),
                        homeButton(context)
                      ])));
                    });
              }
            });
      }));
      list.addAll(List.generate(2, (i) => const SizedBox.shrink()));
    }

    return list;
  }
}

getRandomInRange(int min, int max) {
  return min + Random().nextInt(max - min);
}

Widget replayButton(BuildContext context) => TextButton(
      child: const Text('Play Again'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, MyGame.routeName);
      },
    );

Widget homeButton(BuildContext context) => TextButton(
      child: const Text('Home'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, MainMenu.routeName);
      },
    );
