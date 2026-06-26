import 'package:flutter/material.dart';

class ScreenShell extends StatelessWidget {
  const ScreenShell({
    required this.title,
    required this.child,
    this.actions,
    super.key,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: child,
    );
  }
}
