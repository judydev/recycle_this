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

ValueNotifier<Set<int>> foundSetNotifier = ValueNotifier<Set<int>>({});
ValueNotifier<Set<int>> wrongSetNotifier = ValueNotifier<Set<int>>({});

class _MyGameState extends State<MyGame> {
  late final String? chosenCategory;
  late final int? expectedItemCount;
  late List<Widget> spriteList = [];
  Set<int> expectedSet = {};

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
        setState(() => timer.cancel());

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => fullscreenDialog(context, "Time's up"));
      } else {
        setState(() => secondsLeft--);
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
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
            surfaceTintColor: Colors.blue[100],
            backgroundColor: Colors.blue[100],
            leadingWidth: 80,
            leading: Row(children: [
              const SizedBox(width: 20),
              const Icon(Icons.timer_sharp),
              Text(
                '${secondsLeft}s',
                style: const TextStyle(fontFamily: 'Silkscreen'),
              )
            ]),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    _timer.cancel();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            fullscreenDialog(context, 'Paused'));
                  },
                  icon: const Icon(Icons.pause))
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '[$chosenCategory]',
                  style: const TextStyle(fontFamily: 'SilkScreen'),
                ),
                const SizedBox(width: 30),
                Text(
                    'Found: ${foundSetNotifier.value.length} / $expectedItemCount',
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontFamily: 'Silkscreen')),
                const SizedBox(width: 15),
                Text(
                  'Wrong: ${wrongSetNotifier.value.length}',
                  style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 18,
                      fontFamily: 'Silkscreen'),
                )
              ],
            )),
        body: SafeArea(
            left: false,
            bottom: false,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: colCount,
                  children: spriteList),
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
          expectedSet.add(keyId);
        }

        return Tappable(
            id: keyId,
            child: Image.asset(
                    'assets/images/$category/$category-${i + 1}.png',
                    width: 40,
                    height: 50),
            onTap: (id) {
              if (category == chosenCategory) {
                setState(() => expectedSet.remove(id));
                foundSetNotifier.value.add(id);

                if (expectedSet.isEmpty) {
                  _timer.cancel();
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          fullscreenDialog(context, 'You made it!'));
                }
              } else {
                setState(() => secondsLeft -= 2);
                wrongSetNotifier.value.add(id);
              }
            });
      }));
    }

    final int randomStart = keyId;
    list.addAll(List.generate(randomCount, (i) {
      keyId++;

      return Tappable(
          id: keyId,
          child: Image.asset(
                  'assets/images/random/${keyId - randomStart}.png',
                  width: 40,
                  height: 50),
          onTap: (id) {
            setState(() => secondsLeft -= 2);
            wrongSetNotifier.value.add(id);
          });
    }));

    return list;
  }

  Widget fullscreenDialog(BuildContext context, String text) =>
      AlertDialog(
      backgroundColor: const Color.fromARGB(255, 243, 184, 145),
      content: SizedBox(
          width: MediaQuery.sizeOf(context).width - 100,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 48, fontFamily: 'Silkscreen'),
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
                                style: TextStyle(
                                    fontSize: 36, fontFamily: 'Silkscreen')))
                        : replayButton(context),
                    const SizedBox(height: 20),
                    homeButton(context),
                  ]))));
}

Widget replayButton(BuildContext context) => TextButton(
      child: const Text('Play Again',
          style: TextStyle(fontSize: 36, fontFamily: 'Silkscreen')),
      onPressed: () {
        // reset
        foundSetNotifier.value = {};
        wrongSetNotifier.value = {};

        Navigator.pushReplacementNamed(context, MyGame.routeName);
      },
    );

Widget homeButton(BuildContext context) => TextButton(
      child: const Text('Home',
          style: TextStyle(fontSize: 36, fontFamily: 'Silkscreen')),
      onPressed: () {
        Navigator.pushReplacementNamed(context, MainMenu.routeName);
      },
    );
