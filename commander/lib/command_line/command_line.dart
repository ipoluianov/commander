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
    controller.text = "";
    StateApp().onCommandLineActivate = () {
      focusNode.requestFocus();
    };

    StateApp().onCommandLineAppend = (String txt) {
      setState(() {
        controller.text += txt;
      });
    };

    StateApp().onRequestClearCommandLine = () {
      setState(() {
        controller.text = "";
      });
    };

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        StateApp().setActivatedWidget(StateApp.widgetCommandLine);
      } else {
        StateApp().setActivatedWidget(StateApp.widgetFilePanel);
      }
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
      padding: const EdgeInsets.all(10),
      height: 50,
      child: Row(
        children: [
          Text("CMD: "),
          Expanded(
            child: TextField(
              style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'RobotoMono' // Установка размера шрифта
                  ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white30, // Цвет границы
                    width: 1.0, // Толщина границы
                  ),
                ),
              ),
              focusNode: focusNode,
              controller: controller,
              onSubmitted: (value) {
                StateApp().executeCommandLine(controller.text);
                setState(() {
                  controller.text = "";
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
