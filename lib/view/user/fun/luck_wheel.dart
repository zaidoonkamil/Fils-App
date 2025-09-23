import 'dart:async';

import 'package:fils/core/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../controllar/cubit.dart';
import '../../../controllar/states.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/appBar.dart';


class LuckWheelPage extends StatelessWidget {
  LuckWheelPage({super.key, required this.myValue});

  final int myValue;
  final List<Map<String, dynamic>> items = [
    {'key': '15', 'image': 'assets/images/mine_item_gift 3.png'},
    {'key': 'try_again', 'image': 'assets/images/Sad-Face-Emoji-removebg-preview 1.png'},
    {'key': '15', 'image': 'assets/images/lv101_frame_icon.png'},
    {'key': 'try_again', 'image': 'assets/images/Sad-Face-Emoji-removebg-preview 1.png'},
    {'key': '15', 'image': 'assets/images/mine_item_gift 3.png'},
    {'key': '15', 'image': 'assets/images/Layer 2223.png'},
    {'key': 'try_again', 'image': 'assets/images/Sad-Face-Emoji-removebg-preview 1.png'},
    {'key': 'try_again', 'image': 'assets/images/Sad-Face-Emoji-removebg-preview 1.png'},
  ];
  static int spinCount = 0;

  final StreamController<int> selected = StreamController<int>();
  late bool animate=false;
  int? lastSelectedIndex;

  void spinWheel() {
    final random = Random();
    int selectedIndex;

    if (spinCount < 2) {
      final tryAgainIndexes = items
          .asMap()
          .entries
          .where((entry) => entry.value['key'] == 'try_again')
          .map((entry) => entry.key)
          .toList();

      selectedIndex = tryAgainIndexes[random.nextInt(tryAgainIndexes.length)];
      spinCount++;
    } else {
      final rewardIndexes = items
          .asMap()
          .entries
          .where((entry) => entry.value['key'] == '15')
          .map((entry) => entry.key)
          .toList();

      selectedIndex = rewardIndexes[random.nextInt(rewardIndexes.length)];
      spinCount = 0;
    }

    lastSelectedIndex = selectedIndex;
    selected.add(selectedIndex);
    print('Selected: ${items[selectedIndex]['key']}');
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()
          ..getProfile(context: context)..fu(value: myValue),
        child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
    builder: (context,state){
    var cubit=AppCubit.get(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/WhatsApp Image 2025-06-22 at 1.30.30 AM 1.png',fit: BoxFit.fill ,width: double.maxFinite,height: double.maxFinite,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 320,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.orange,
                      border: Border.all(
                          color: Colors.grey
                      ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('يمكنك الدوران بأستخدام 10 جوهرة ',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 300,
                  child: FortuneWheel(
                    selected: selected.stream,
                    animateFirst: false,
                    onAnimationStart: (){
                      animate = true;
                      cubit.refreshState();
                    },
                    onAnimationEnd: () {
                      if(items[lastSelectedIndex!]['key'] != 'try_again') {
                        cubit.myValue -=10;
                        cubit.sendSawa(amount: items[lastSelectedIndex!]['key'], context: context);
                        cubit.playAnimation();
                        animate = false;
                        cubit.refreshState();
                      } else {
                        cubit.myValue -=10;
                        cubit.updateGems(gems: cubit.myValue, context: context);
                        showToastInfo(text: 'حاول مرة اخرى', context: context);
                        cubit.playAnimation();
                        animate = false;
                        cubit.refreshState();
                      }
                    },
                    items: [
                      for (var item in items)
                        FortuneItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Image.asset(item['image'], width: 40, height: 40),
                          ),
                          style: FortuneItemStyle(
                            textStyle: TextStyle(fontSize: 16),
                            borderWidth: 4,
                            borderColor: primaryColor,
                            color: secoundColor,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                cubit.myValue>=10 && animate == false ? GestureDetector(
                  onTap: (){
                    spinWheel();
                  },
                  child: Image.asset('assets/images/Group 4.png'),
                ):GestureDetector(
                  onTap: (){
                    showToastInfo(text: 'جواهرك لا تكفي', context: context);
                  },
                  child: Image.asset('assets/images/Group 4.png'),
                ),
              ],
            ),
            AppbarBack(),
            Center(
              child: BlocBuilder<AppCubit, AppStates>(
                builder: (context, state) {
                  double scale = 0;

                  if (state is AnimationScaleState) {
                    scale = state.scale;
                  }

                  return Transform.scale(
                    scale: scale,
                    child: Image.asset(
                      'assets/images/screenshotttt.png',
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
    },),
    );
  }
}