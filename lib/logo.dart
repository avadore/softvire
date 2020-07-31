


import 'dart:async';

import 'package:flutter/material.dart';


class AnimatedFlutterLogo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnimatedFlutterLogoState();
}

class _AnimatedFlutterLogoState extends State<AnimatedFlutterLogo> {






  Timer _timer;
  double _visible=0.0;
  

  _AnimatedFlutterLogoState() {
    _timer = new Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _visible = 1.0;
      });
     Timer(const Duration(milliseconds: 3000), () {
    Navigator.of(context).pushReplacementNamed('/widget');
    });
    });

  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          
          child: AnimatedOpacity(
            duration: Duration(seconds:2),
                      opacity: _visible,
                      child: Image(
              image: AssetImage('images/logo.png'),
              ),
          ),
        );

  }
}