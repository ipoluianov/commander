import 'dart:async';

import 'package:commander/appstate/state_filepanel.dart';
import 'package:flutter/material.dart';

import '../appstate/state_app.dart';
import 'file_panel_item.dart';

class FilePanel extends StatefulWidget {
  final int panelIndex;
  const FilePanel({super.key, required this.panelIndex});

  @override
  State<StatefulWidget> createState() {
    return FilePanelState();
  }
}

class FilePanelState extends State<FilePanel> {
  late StateFilePanel state;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    state = StateApp().filepanels[widget.panelIndex];
    Timer.run(() {
      state.load(0);
    });
    state.onCurrentIndexChanged = (int index) {
      print("ensure visible");
      scrollToItem(index);
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  double heightOfEachItem = 20;

  void scrollToItem(int itemIndex) {
    final double itemPosition = itemIndex * heightOfEachItem;
    final double scrollPosition = _scrollController.position.pixels;
    final double viewportHeight = _scrollController.position.viewportDimension;

    if (itemPosition < scrollPosition) {
      // Элемент находится выше видимой области, прокрутим вверх
      _scrollController.jumpTo(itemPosition);
    } else if ((itemPosition + heightOfEachItem) >
        (scrollPosition + viewportHeight)) {
      // Элемент находится ниже видимой области, прокрутим вниз
      // Прокрутим так, чтобы элемент оказался внизу видимой области
      _scrollController
          .jumpTo(itemPosition + heightOfEachItem - viewportHeight);
    }
  }

  Widget buildItem(BuildContext context, int index, dynamic item) {
    bool selected = false;
    //print("CFP: ${StateApp().currentFilePanel} ${widget.panelIndex}");
    if (StateApp().currentFilePanel == widget.panelIndex) {
      if (index == state.currentIndex) {
        selected = true;
      }
    }
    return SizedBox(
      height: heightOfEachItem,
      child: FilelistItem(
        index: index,
        item: item,
        selected: selected,
        onTap: (index) {
          setState(() {
            StateApp().processFilePanelItem(widget.panelIndex, index);
          });
        },
        onDoubleTap: (index) {
          setState(() {
            StateApp().processFilePanelItem(widget.panelIndex, index);
            state.mainAction();
          });
        },
      ),
    );
  }

  List<Widget> buildItems(BuildContext context) {
    List<Widget> res = [];
    int index = 0;
    for (var item in state.items) {
      res.add(buildItem(context, index, item));
      index++;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    heightOfEachItem = 36;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        state.itemsPerPage = (constraints.maxHeight / heightOfEachItem).round();
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white30, width: 1)),
          child: ListView(
            controller: _scrollController,
            children: buildItems(context),
          ),
        );
      },
    );
  }
}
