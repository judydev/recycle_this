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

enum Categories {
  bottle,
  can,
  clothes,
  cup,
  electronics,
  furniture,
  paper,
  parcel,
  plastic,
}

Map<Categories, int> countMap = {
  Categories.bottle: 14,
  Categories.can: 14,
  Categories.clothes: 12,
  Categories.cup: 7,
  Categories.electronics: 12,
  Categories.furniture: 13,
  Categories.paper: 12,
  Categories.parcel: 1,
  Categories.plastic: 6,
};

const randomCount = 13;

class _MyGameState extends State<MyGame> {
  late final String? chosenCategory;
  late final int? expectedItemCount;
  late List<Widget> spriteList = [];

  Set<int> found = {};
  Set<int> wrong = {};
  Set<int> expected = {};

  Timer _timer = Timer(Duration.zero, () {});
  int secondsLeft = 30;

  @override
  void initState() {
    super.initState();

    final keys = countMap.keys.toList();
    final chosenKey = keys[Random().nextInt(keys.length)];
    expectedItemCount = countMap[chosenKey];
    chosenCategory = chosenKey.name;

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
              return fullscreenDialog(context, "Sorry you did not make it");
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
            backgroundColor: Colors.blue[100]!,
            leadingWidth: 80,
            leading: Row(children: [
              const SizedBox(width: 20),
              const Icon(Icons.timer_sharp),
              Text('${secondsLeft}s')
            ]),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    _timer.cancel();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return fullscreenDialog(context, 'Paused');
                        });
                  },
                  icon: const Icon(Icons.pause))
            ],
            title: Text('Category: $chosenCategory')),
        body: SafeArea(
            child: Column(
          children: [
            Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(color: Colors.blue[100]!),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Found: ${found.length} / $expectedItemCount',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 16)),
                        const SizedBox(width: 15),
                        Text(
                          'Wrong: ${wrong.length}',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        )
                      ],
                    ))),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.blue[100]!,
                        Colors.lightBlueAccent,
                        Colors.blueGrey[50]!,
                        Colors.blueGrey[200]!,
                        Colors.lightBlueAccent,
                        Colors.blueAccent,
                        Colors.blue[900]!,
                        Colors.blueGrey[800]!,
                      ])),
                  child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: colCount,
                        children: spriteList)))
          ],
        )));
  }

  generateSpriteList() {
    List<Widget> list = [];
    int keyId = 0;
    for (final categoryKey in countMap.keys) {
      String category = categoryKey.name;
      list.addAll(List.generate(countMap[categoryKey]!, (i) {
        keyId++;
        if (category == chosenCategory) {
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
                    'assets/images/$category/$category-${i + 1}.png',
                    width: 40,
                    height: 50)),
            onTap: (id) {
              if (category == chosenCategory) {
                setState(() {
                  found.add(id);
                  expected.remove(id);
                });

                if (expected.isEmpty) {
                  _timer.cancel();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return fullscreenDialog(context, 'You made it!');
                      });
                }
              } else {
                setState(() {
                  secondsLeft -= 2;
                  wrong.add(id);
                });
              }
            });
      }));
    }

    final int randomStart = keyId;
    list.addAll(List.generate(randomCount, (i) {
      keyId++;

      return Tappable(
          id: keyId,
          child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(
                Random().nextDouble() * 2 * pi,
              ),
              child: Image.asset(
                  'assets/images/random/${keyId - randomStart}.png',
                  width: 40, height: 50)),
          onTap: (id) {
            setState(() {
              secondsLeft -= 2;
              wrong.add(id);
            });
          });
    }));
      
    return list;
  }

  Widget fullscreenDialog(BuildContext context, String text) =>
      Dialog.fullscreen(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(255, 243, 184, 145),
                    Color.fromRGBO(235, 161, 122, 115),
                  ])),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      text,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 30),
                    text == 'Paused'
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              startTimer();
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(20)),
                            child: const Text('Continue',
                                style: TextStyle(fontSize: 36)))
                        : replayButton(context),
                    const SizedBox(height: 20),
                    homeButton(context),
                  ]))));
}

Widget replayButton(BuildContext context) => TextButton(
      child: const Text('Play Again', style: TextStyle(fontSize: 36)),
      onPressed: () {
        Navigator.pushReplacementNamed(context, MyGame.routeName);
      },
    );

Widget homeButton(BuildContext context) => TextButton(
      child: const Text('Home', style: TextStyle(fontSize: 36)),
      onPressed: () {
        Navigator.pushReplacementNamed(context, MainMenu.routeName);
      },
    );
