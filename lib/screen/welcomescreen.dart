import 'package:flashchat/components/roundedbutton.dart';
import 'package:flashchat/screen/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'loginscreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id  ='WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller=AnimationController(
        duration: Duration(seconds: 3),
        vsync:this,
    );
    animation=CurvedAnimation(
      parent: controller,
      curve: Curves.easeInCubic);
    controller.forward();
    animation=ColorTween(begin: Colors.grey,end: Colors.white).animate(controller);

    controller.addListener(() {
      setState(() {
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.jpg'),
                      height: 60 ,
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.pink,
                    ), child:  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Top Chat',),
                    ],
                  ),
                  ),
               ],
              ),
               SizedBox(
                height: 48.0,
              ),
               RoundButton(title: 'Log In',colour: Colors.pinkAccent,onPressed: (){
                 Navigator.pushNamed(context,LoginScreen.id);
               },),
              RoundButton(title: 'Register',colour: Colors.pinkAccent,onPressed: (){
                Navigator.pushNamed(context,RegistrationScreen.id);
              },),

      ],
    ),
        ),
      ),
    );
  }
}

