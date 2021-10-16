import 'package:flutter/material.dart';

class ShowProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
  }
}
