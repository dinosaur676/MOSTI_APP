
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';

int getSinListNumForMnemonic(int sum, int index, int max, int min, int mnemonicWordlength) {
  int num = getSinListNumForHex(sum, index, max, min);

  double output = (num / 255) * mnemonicWordlength;


  return output.toInt();
}

int getSinListNumForHex(int sum, int index, int max, int min) {
  double sinResult = (sin(getRadians(index.toDouble())) + 1) * 0.5;
  double x = (sum - min) * 255 / (max - min);
  int num = (x * sinResult).toInt();

  return num;
}

List<int> compressString(String string, int count) {
  List<int> strList = utf8.encode(string);

  return compressStringBytes(strList, count);
}

List<int> compressStringBytes(List<int> bytes, int count) {
  List<int> output = [];

  int perListLength = bytes.length ~/ count;
  for(int i = 0; i < count; ++i) {
    var temp = bytes.getRange(i * perListLength, (i + 1) * perListLength);
    int sum = temp.fold(0, (total, element) {
      return total + element;
    });

    output.add(sum ~/ temp.length);
  }

  return output;
}

List<int> stretchList(List<int> list) {
  List<int> sortDatas = [];
  sortDatas.addAll(list);
  sortDatas.sort();
  int max = sortDatas.last;
  int min = sortDatas.first;

  return list.asMap().entries.map((entry) {
    int index = entry.key;
    int value = entry.value;

    return getSinListNumForHex(value, index * 3, max, min);
  }).toList();
}

double getRadians(double degree) {
  return degree * (pi / 180.0);
}