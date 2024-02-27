import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle_this/main.dart';
import 'package:recycle_this/src/home_page.dart';
import 'package:recycle_this/src/game/tappable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_this/src/settings/settings_controller.dart';

class MyGame extends StatefulWidget {
  const MyGame({super.key, required this.settingsController, this.randomKey});
  static const routeName = '/startgame';
  final SettingsController settingsController;
  final Categories? randomKey;

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  late final settingsController = widget.settingsController;
  late final Categories? randomKey = widget.randomKey;
  late final String? targetCategory;
  late final int? expectedItemCount;
  late List<Widget> spriteList = [];
  Set<int> expectedSet = {};

  Timer _timer = Timer(Duration.zero, () {});
  int secondsLeft = 30;

  @override
  void initState() {
    super.initState();

    expectedItemCount = categoryCountMap[randomKey];
    if (randomKey != null) {
      targetCategory = randomKey!.name;
    }

    // get object images and shuffle for display
    spriteList = generateSpriteList();
    spriteList.shuffle();

    // start timer and play a random bgm
    startTimer();
    String bgmFileName = bgms[Random().nextInt(bgms.length)];
    if (settingsController.backgroundMusicOn) {
      FlameAudio.bgm.audioPlayer.setSource(AssetSource(bgmFileName));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    FlameAudio.bgm.dispose();
    reset();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 0) {
        setState(() => timer.cancel());
        FlameAudio.bgm.stop();

        if (settingsController.backgroundMusicOn) {
          FlameAudio.play('game_over.m4a');
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => popupDialog(context, "Time's up"));
      } else {
        setState(() => secondsLeft--);
      }
    });

    if (settingsController.backgroundMusicOn) {
      FlameAudio.bgm.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (randomKey == null) {
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
                    if (settingsController.soundEffectOn) {
                      SystemSound.play(SystemSoundType.click);
                    }

                    FlameAudio.bgm.pause();

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => popupDialog(context, 'Paused'));
                  },
                  icon: const Icon(Icons.pause))
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '[${getTargetCategoryName(targetCategory)}]',
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
    for (final categoryKey in categoryCountMap.keys) {
      String category = categoryKey.name;
      list.addAll(List.generate(categoryCountMap[categoryKey]!, (i) {
        keyId++;
        if (category == targetCategory) {
          expectedSet.add(keyId);
        }

        return Tappable(
            id: keyId,
            child: Image.asset('assets/images/$category/$category-${i + 1}.png',
                width: 40, height: 50),
            onTap: (id) {
              if (category == targetCategory) {
                if (settingsController.soundEffectOn) {
                  FlameAudio.play('correct.m4a');
                }

                setState(() => expectedSet.remove(id));
                foundSetNotifier.value.add(id);

                if (expectedSet.isEmpty) {
                  _timer.cancel();
                  FlameAudio.bgm.stop();

                  if (settingsController.backgroundMusicOn) {
                    FlameAudio.play('game_pass.m4a');
                  }
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          popupDialog(context, 'You made it!'));
                }
              } else {
                selectWrong(id);
              }
            });
      }));
    }

    final int randomStart = keyId;
    list.addAll(List.generate(randomCount, (i) {
      keyId++;

      return Tappable(
          id: keyId,
          child: Image.asset('assets/images/random/${keyId - randomStart}.png',
              width: 40, height: 50),
          onTap: (id) {
            selectWrong(id);
          });
    }));

    return list;
  }

  selectWrong(id) {
    if (settingsController.soundEffectOn) {
      FlameAudio.play('wrong.m4a');
    }
    setState(() => secondsLeft -= 2);
    wrongSetNotifier.value.add(id);
  }

  Widget popupDialog(BuildContext context, String text) => AlertDialog(
      backgroundColor: backgroundColor,
      content: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  text,
                  style:
                      const TextStyle(fontSize: 48, fontFamily: 'Silkscreen'),
                ),
                const SizedBox(height: 30),
                text == 'Paused'
                    ? TextButton(
                        onPressed: () {
                          if (settingsController.soundEffectOn) {
                            SystemSound.play(SystemSoundType.click);
                          }

                          Navigator.of(context).pop();
                          startTimer();
                          if (settingsController.backgroundMusicOn) {
                            FlameAudio.bgm.resume();
                          }
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(20)),
                        child: const Text('Continue',
                            style: TextStyle(
                                fontSize: 36, fontFamily: 'Silkscreen')))
                    : replayButton(context, settingsController.soundEffectOn),
                const SizedBox(height: 20),
                homeButton(context, settingsController.soundEffectOn),
              ]))));
  reset() {
    foundSetNotifier.value = {};
    wrongSetNotifier.value = {};
  }

  Widget replayButton(BuildContext context, bool soundEffectOn) => TextButton(
        child: const Text('Play Again',
            style: TextStyle(fontSize: 36, fontFamily: 'Silkscreen')),
        onPressed: () async {
          if (soundEffectOn) {
            SystemSound.play(SystemSoundType.click);
          }

          reset();

          await showCategoryPopup(context);
        },
      );

  Widget homeButton(BuildContext context, bool soundEffectOn) => TextButton(
        child: const Text('Home',
            style: TextStyle(fontSize: 36, fontFamily: 'Silkscreen')),
        onPressed: () {
          if (soundEffectOn) {
            SystemSound.play(SystemSoundType.click);
          }

          FlameAudio.bgm.stop();
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        },
      );
}

showCategoryPopup(context) {
  final keys = categoryCountMap.keys.toList();
  final randomKey = keys[Random().nextInt(keys.length)];

  return showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog.fullscreen(
            child: Container(
          alignment: Alignment.center,
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: const Text(
                    'Find objects in the following category within 30 seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontFamily: 'Silkscreen')),
              ),
              Text(getTargetCategoryName(randomKey.name),
                  style:
                      const TextStyle(fontSize: 48, fontFamily: 'Silkscreen')),
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, MyGame.routeName,
                        arguments: randomKey);
                  },
                  style: ButtonStyle(
                    padding:const MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.brown[200]),
                      shape:  MaterialStatePropertyAll(
                          CircleBorder(side: BorderSide(width: 2, color: Colors.brown[300]!)))
                          ),
                  child: const Text('Go',
                      style: TextStyle(fontSize: 32, fontFamily: 'Silkscreen')))
            ],
          ),
        ));
      });
}

int colCount = 10;

enum Categories {
  bottle,
  can,
  cardboard,
  clothes,
  cup,
  electronics,
  furniture,
  paper,
  plasticbag,
}

getTargetCategoryName(category) {
  if (category == 'plasticbag') {
    return 'Plastic Bag';
  }
  return category;
}

Map<Categories, int> categoryCountMap = {
  Categories.bottle: 14,
  Categories.can: 14,
  Categories.cardboard: 10,
  Categories.clothes: 12,
  Categories.cup: 7,
  Categories.electronics: 12,
  Categories.furniture: 13,
  Categories.paper: 12,
  Categories.plasticbag: 6,
};

const randomCount = 13;

ValueNotifier<Set<int>> foundSetNotifier = ValueNotifier<Set<int>>({});
ValueNotifier<Set<int>> wrongSetNotifier = ValueNotifier<Set<int>>({});
