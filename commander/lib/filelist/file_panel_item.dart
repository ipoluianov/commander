import 'package:commander/appstate/state_filepanel_item.dart';
import 'package:flutter/material.dart';

class FilelistItem extends StatefulWidget {
  StateFilePanelItem item;
  bool selected;
  int index;
  Function(int index) onTap;

  FilelistItem({
    super.key,
    required this.item,
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
    String text = widget.item.getFileNameWithoutExtension();
    String ext = widget.item.getFileExtension();
    String sizeString = "";
    String permissionsString = "";
    String owner = "";
    if (widget.item.isDir) {
      text = '[${widget.item.fileName}]';
      sizeString = '[DIR]';
    } else {
      sizeString = widget.item.size.toString();
    }
    permissionsString = widget.item.parsePermissions();
    owner = widget.item.owner;
    if (owner.length > 11) {
      owner = owner.substring(0, 11);
      owner += "...";
    }

    if (widget.item.fileName == "..") {
      owner = "";
      permissionsString = "";
    }

    Color color = Colors.white70;

    if (widget.item.isDir) {
      color = Colors.white;
    }

    if (widget.item.isLink) {
      color = Colors.green;
    }

    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index);
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: widget.selected ? Colors.white24 : Colors.transparent,
          border:
              const Border(bottom: BorderSide(color: Colors.white30, width: 1)),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 18,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.white30, width: 1),
                  ),
                ),
                child: SizedBox(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ext,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.white30,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sizeString,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        widget.item.linkTarget,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      owner,
                      style: const TextStyle(
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white30,
                      ),
                    ),
                    Text(
                      permissionsString,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
