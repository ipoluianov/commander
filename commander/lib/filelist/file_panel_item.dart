import 'package:flutter/material.dart';

class FilelistItem extends StatefulWidget {
  String fileName;
  bool isDir;
  bool selected;
  int index;
  Function(int index) onTap;

  FilelistItem({
    super.key,
    required this.fileName,
    required this.selected,
    required this.onTap,
    required this.index,
    required this.isDir,
  });
  @override
  State<StatefulWidget> createState() {
    return FilelistItemState();
  }
}

class FilelistItemState extends State<FilelistItem> {
  @override
  Widget build(BuildContext context) {
    String text = widget.fileName;
    if (widget.isDir) {
      text = '[${widget.fileName}]';
    }
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index);
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: widget.selected ? Colors.white54 : Colors.transparent,
          border:
              const Border(bottom: BorderSide(color: Colors.white30, width: 1)),
        ),
        child: Text(text),
      ),
    );
  }
}
