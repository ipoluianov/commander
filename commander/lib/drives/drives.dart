import 'package:flutter/material.dart';

class Drives extends StatefulWidget {
  final double width;
  final double height;
  const Drives({super.key, required this.width, required this.height});

  @override
  State<StatefulWidget> createState() {
    return DrivesState();
  }
}

class DrivesState extends State<Drives> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width / 2,
      height: widget.height / 2,
      child: Text("DRIVES"),
    );
  }
}
