import 'package:flutter/material.dart';

class FilelistItem extends StatefulWidget {
  String fileName;
  bool selected;
  int index;
  Function(int index) onTap;

  FilelistItem({
    super.key,
    required this.fileName,
    required this.selected,
    required this.onTap,
    required this.index,
  });
  @override
  State<StatefulWidget> createState() {
    return FilelistItemState();
  }
}

class FilelistItemState extends State<FilelistItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index);
      },
      child: Container(
        decoration:
            BoxDecoration(color: widget.selected ? Colors.amber : Colors.green),
        child: Text(widget.fileName),
      ),
    );
  }
}
