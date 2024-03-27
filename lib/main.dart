import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: RemainTimeNotificationWidget(),
      ),
    );
  }
}

class RemainTimeNotificationWidget extends HookConsumerWidget {
  const RemainTimeNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ステータスバーの高さ + ウィジェットの高さ
    final movedPosition = -MediaQuery.of(context).padding.top;
    final initialPosition = -(MediaQuery.of(context).padding.top + 100);
    final animationController =
        useAnimationController(duration: const Duration(seconds: 2));
    final tween = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: initialPosition,
          end: movedPosition,
        ),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ConstantTween(movedPosition),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: movedPosition,
          end: initialPosition,
        ),
        weight: 0.5,
      ),
    ]).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      }
    });

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              top: tween.value,
              child: buildNotificationWidget(context),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  animationController.forward();
                },
                child: const Text('Drop Box'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildNotificationWidget(context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
          padding: const EdgeInsets.only(top: 50),
          child: const Center(
            child: Text('お知らせ'),
          ),
        ),
      ),
    );
  }
}
