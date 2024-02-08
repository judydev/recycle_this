import 'dart:async';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:recycle_this/src/main_menu.dart';
import 'package:recycle_this/src/tappable.dart';

int colCount = 10;

class MyGame extends StatefulWidget {
  const MyGame({super.key});
  static const routeName = '/startgame';

  @override
  State<MyGame> createState() => _MyGameState();
}

enum Categories { can, cup, paper, bottle }

List countMap = [
  {'folder': 'cans', 'category': Categories.can.name, 'count': 14},
  {'folder': 'cups', 'category': Categories.cup.name, 'count': 7},
  {'folder': 'papers', 'category': Categories.paper.name, 'count': 12},
  {'folder': 'plastic', 'category': Categories.bottle.name, 'count': 12},
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

    chosenCategory = Categories.values.random().name;
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
      if (secondsLeft == 0) {
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
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selected: $found'),
            Text('Wrong: $wrong'),
            const Padding(padding: EdgeInsets.all(20)),
            Expanded(
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: colCount,
                    children: spriteList)),
          ],
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
            child: Image.asset(
                'assets/images/${json['folder']}/${json['category']}-${i + 1}.png',
                width: 40,
                height: 50),
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
