import 'package:commander/appstate/state_app.dart';

class StateFilePanelItem {
  String fileName = "";
  String ext = "";
  bool isDir = false;
  int permissions = 0;
  int size = 0;
  String owner = "";
  bool isLink = false;
  String linkTarget = "";
  int panelIndex = 0;
  DateTime modTime = DateTime(0);
  //bool renaming = false;
  //String renamingName = "";

  String key() {
    return panelIndex.toString() + fileName;
  }

  Function onRenameFieldActivated = () {};
  Function onRenameFieldDeActivated = () {};

  void renameCompleted() {
    //print("RENAME COMPLETED $fileName to $renamingName");
    //renaming = false;
    StateApp().setActivatedWidget(StateApp.widgetFilePanel);
    StateApp().notifyChanges();
  }

  String getFileExtension() {
    if (fileName == "..") {
      return "";
    }
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex != 0 && dotIndex != fileName.length - 1) {
      return fileName.substring(dotIndex + 1);
    }
    return "";
  }

  String getFileNameWithoutExtension() {
    if (fileName == "..") {
      return fileName;
    }
    int dotIndex = fileName.lastIndexOf('.');

    // Проверяем, есть ли точка и не является ли она первым символом
    if (dotIndex != -1 && dotIndex != 0) {
      return fileName.substring(0, dotIndex);
    }

    return fileName; // Возвращаем полное имя файла, если расширение не найдено
  }

  String parsePermissions() {
    String binary = permissions.toRadixString(2).padLeft(32, '0');

    String parseRwx(String bits) {
      return '${bits[0] == '1' ? 'r' : '-'}${bits[1] == '1' ? 'w' : '-'}${bits[2] == '1' ? 'x' : '-'}';
    }

    String ownerPerms = parseRwx(binary.substring(23, 26));
    String groupPerms = parseRwx(binary.substring(26, 29));
    String otherPerms = parseRwx(binary.substring(29, 32));

    bool isSticky = binary[21] == '1';
    bool isSgid = binary[22] == '1';
    bool isSuid = binary[23] == '1';

    String specialBits = '';
    specialBits += isSticky ? 't' : '-';
    specialBits += isSgid ? 's' : '-';
    specialBits += isSuid ? 's' : '-';

    return '$ownerPerms $groupPerms $otherPerms $specialBits';
  }
}
