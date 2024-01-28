import 'package:flutter/material.dart';

import '../appstate/state_app.dart';

class CommandLine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommandLineState();
  }
}

class CommandLineState extends State<CommandLine> {
  String _text = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = "123121729846238764287648764826486284623986482936487";
    StateApp().onCommandLineActivate = () {
      focusNode.requestFocus();
    };

    focusNode.addListener(() {
      StateApp().commandLineActivated = focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(() {});
    focusNode.dispose();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onSubmitted: (value) {
          StateApp().executeCommandLine(controller.text);
          setState(() {
            controller.text = "";
          });
        },
      ),
    );
  }
}
