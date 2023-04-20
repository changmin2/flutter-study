import 'package:delivery_changmin/common/component/custom_text_form_field.dart';
import 'package:delivery_changmin/user/view/login_screen.dart';
import 'package:delivery_changmin/user/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    _App()
  );
}

class _App extends StatelessWidget{
  const _App({Key?key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

