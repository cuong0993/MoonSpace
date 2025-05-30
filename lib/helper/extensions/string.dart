import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';

extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
      this,
      (
        String result,
        String pattern,
      ) =>
          result.replaceAll(pattern, ''));
}

String randomString(int length) {
  var result = '';
  var characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.characters
        .elementAt((Random().nextDouble() * charactersLength) ~/ 1);
  }
  return result;
}

String stringSting(String text) {
  String res = text.replaceAllMapped(
      RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => (' ${m.group(0)}'));
  String finalResult = res[0].toUpperCase() + res.substring(1);
  return finalResult;
}

int editDistance(String s1, String s2) {
  if (s1 == s2) {
    return 0;
  }

  if (s1.isEmpty) {
    return s2.length;
  }

  if (s2.isEmpty) {
    return s1.length;
  }

  List<int> v0 = List<int>.generate(s2.length + 1, (i) => i, growable: false);
  List<int> v1 = List<int>.filled(s2.length + 1, 0, growable: false);
  List<int> vtemp;

  for (var i = 0; i < s1.length; i++) {
    v1[0] = i + 1;

    for (var j = 0; j < s2.length; j++) {
      int cost = 1;
      if (s1.codeUnitAt(i) == s2.codeUnitAt(j)) {
        cost = 0;
      }
      v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
    }

    vtemp = v0;
    v0 = v1;
    v1 = vtemp;
  }

  return v0[s2.length];
}

double normEditDistance(String s1, String s2) {
  int maxLength = max(s1.length, s2.length);
  if (maxLength == 0) {
    return 0.0;
  }
  return editDistance(s1, s2) / maxLength;
}

Map<String, dynamic>? decodeJWT(String? refreshToken) {
  final jwt = refreshToken?.split('.');
  if (jwt != null && jwt.length > 1) {
    String token = jwt[1];
    int l = (token.length % 4);
    token += List.generate((4 - l) % 4, (index) => '=').join();
    final decoded = base64.decode(token);
    token = utf8.decode(decoded);
    return json.decode(token) as Map<String, dynamic>;
  }
  return null;
}
