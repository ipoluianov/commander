import 'dart:ffi';
import 'dart:convert';
import 'dart:io';

typedef BeginFunc = Int64 Function();
typedef Beginf = int Function();

typedef IsReadyFunc = Int64 Function(Int64 trId);
typedef IsReadyf = int Function(int trId);

typedef CommitFunc = Int64 Function(Int64 trId);
typedef Commitf = int Function(int trId);

typedef InFunc = Int64 Function(Int64 trId, Int64 data);
typedef Inf = int Function(int trId, int data);

typedef OutFunc = Int64 Function(Int64 trId);
typedef Outf = int Function(int trId);

Future<dynamic> callGo(String param) async {
  String libPath = "";
  String fileName = "";
  if (Platform.isMacOS) {
    fileName = "mylib.dylib";
  }
  if (Platform.isWindows) {
    fileName = "mylib.dll";
  }

  libPath += fileName;

  final dll = DynamicLibrary.open(libPath);
  final Beginf begin =
      dll.lookup<NativeFunction<BeginFunc>>('Begin').asFunction();
  final IsReadyf isReady =
      dll.lookup<NativeFunction<IsReadyFunc>>('IsReady').asFunction();
  final Commitf commit =
      dll.lookup<NativeFunction<CommitFunc>>('Commit').asFunction();
  final Inf input = dll.lookup<NativeFunction<InFunc>>('In').asFunction();
  final Outf output = dll.lookup<NativeFunction<OutFunc>>('Out').asFunction();

  int trId = begin();
  //print("FL: BEGIN: $trId");

  List<int> bytesToSend = utf8.encode(param);
  for (var b in bytesToSend) {
    input(trId, b);
  }
  input(trId, 0xFFFFFFFF);
  while (true) {
    var r = isReady(trId);
    if (r != 0) {
      break;
    }
    await Future.delayed(const Duration(milliseconds: 1));
  }

  List<int> resultBytes = [];

  if (isReady(trId) != 0) {
    while (true) {
      var b = output(trId);
      if (b == 0xFFFFFFFF) {
        break;
      }
      resultBytes.add(b);
    }
    commit(trId);
  }

  return jsonDecode(utf8.decode(resultBytes));
}
