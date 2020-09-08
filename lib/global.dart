import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

int any2int(dynamic o) {
  try {
    return int.parse(o.toString().split('.').first);
  } catch (e) {
    return 0;
  }
}

/// Version =1.0.0
bool needUpgrade(String old, String ver) {
  var upgrade = false;
  if (old != ver) {
    var nvl = ver.split('.');
    var ovl = old.split('.');
    if (nvl.length != ovl.length) {
      upgrade = true;
    } else {
      for (var i = 0; i < nvl.length; i++) {
        var nvln = any2int(nvl[i]);
        var ovln = any2int(ovl[i]);
        if (nvln > ovln) {
          upgrade = true;
          break;
        }
        if (nvln < ovln) break;
      }
    }
  }
  return upgrade;
}

String int2hex(int n, {int padLeft = 8}) {
  return n.toRadixString(16).padLeft(padLeft, '0');
}

DateTime timedate([Duration duration]) {
  if (duration != null) {
    var isAdd = duration > Duration.zero;
    if (isAdd) {
      return DateTime.now().add(duration);
    } else {
      return DateTime.now().subtract(duration);
    }
  }
  return DateTime.now();
}

String timestamp([dynamic duration]) {
  if (duration is Duration) {
    return timedate(duration).toString();
  }
  if (duration is int) {
    return DateTime.fromMicrosecondsSinceEpoch(duration).toString();
  }
  return timedate().toString();
}

String timeymd([Duration duration]) {
  return timedate(duration).toIso8601String().split('T').first;
}

int timeint([Duration duration]) {
  return timedate(duration).millisecondsSinceEpoch;
}

Duration timediff([int start, int end]) {
  var origin = end ?? timeint();
  var res = Duration(milliseconds: (origin - start));
  if (res == Duration.zero) return Duration(milliseconds: 1);
  return res;
}

class Timero {
  int start;

  Timero() {
    start = timeint();
  }

  bool isTimeOut(int second) => timediff(start) > Duration(seconds: second);
}

int duration2time(String input) {
  return DateTime.parse('${timeymd()} $input').millisecondsSinceEpoch;
}

String str2md5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String strcut(String input, {int len}) {
  if (len != null) return input.substring(0, min(len, input.length));
  return input;
}

Future<void> delayed(Duration duration) async {
  await Future.delayed(duration);
}

String fileNameStarReset(String string) {
  for (var i = 0; i < 20; i++) {
    string = string.replaceAll('****', '***');
  }
  return string;
}

String convertBytes(int size, {String format = 'PB', int fixed = 2}) {
  var Kb = 1024;
  var Mb = Kb * 1024;
  var Gb = Mb * 1024;
  var Tb = Gb * 1024;
  var Pb = Tb * 1024;
  if (size < Kb || format == 'B') return size.toString() + 'B';
  if (size < Mb || format == 'KB') return (size / Kb).toStringAsFixed(fixed) + 'KB';
  if (size < Gb || format == 'MB') return (size / Mb).toStringAsFixed(fixed) + 'MB';
  if (size < Tb || format == 'GB') return (size / Gb).toStringAsFixed(fixed) + 'GB';
  if (size < Pb || format == 'TB') return (size / Tb).toStringAsFixed(fixed) + 'TB';
  return (size / Pb).toStringAsFixed(fixed) + 'PB';
}
