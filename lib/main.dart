import 'package:flutter/material.dart';

import 'LoginScreen.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    theme: ThemeData(
        primaryColor: Color(0xffB651E5),
        accentColor: Color(0xff25D366),
        unselectedWidgetColor: Colors.white),
    debugShowCheckedModeBanner: false,
  ));
}
