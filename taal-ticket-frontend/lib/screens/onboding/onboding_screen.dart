import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/screens/onboding/components/animated_btn.dart';
import 'package:rive_animation/screens/onboding/components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              bottom: 200,
              left: 100,
              child: Image.asset('assets/Backgrounds/Spline.png')),
            Positioned.fill(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            )),
            const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                child: const SizedBox(),
              )
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 240),
              top: isSignInDialogShown ? -50 : 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const SizedBox(
                          width: 260,
                          child: Column(children: [
                            Text(
                              "Taal Ticket",
                              style: TextStyle(
                                  fontSize: 60, fontFamily: "Poppins", height: 1.2),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                                "Step into the rhythm of excitement! Welcome to our musical journey where every beat ignites your passion. Book your tickets to the hottest shows in town and let the melodies carry you away. Get ready to experience the magic of live music – reserve your seats now!",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.justify)
                          ]),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        AnimatedBtn(
                          btnAnimationController: _btnAnimationController,
                          press: () {
                            _btnAnimationController.isActive = true;
                            Future.delayed(const Duration(milliseconds: 800), () {
                              setState(() {
                                isSignInDialogShown = true;
                              });
                              customSigninDialog(context, onClosed: (_) {
                                setState(() {
                                  isSignInDialogShown = false;
                                });
                              });
                            });
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            "Let the music move you – book your seats and dance to the beat!",
                            style: TextStyle(),
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
    ));
  }
}
