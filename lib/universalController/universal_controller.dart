import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobigic/utility/index_finder.dart';

class UniversalController extends GetxController {
  RxInt m = 0.obs;
  RxInt n = 0.obs;
  int get getMValue => m.value == 0 ? 1 : m.value;
  int get getNValue => n.value == 0 ? 1 : n.value;

  RxBool isSearched = false.obs;
  RxBool isClicked = false.obs;
  List<List<int>> foundValues = [];
  int get getMxNValue => m.value * n.value;

  RxList<List<String>> matrixData = [
    ['']
  ].obs;

  String get getTextFieldTitle =>
      !isMatrixFilled ? "Enter Data to Matrix" : "Search Text in Matrix";
  String get buttonTitle => !isMatrixFilled ? "Add" : "Search";

  String get getRowValue =>
      matrixData.isEmpty ? "1" : matrixData.length.toString();

  void setMValue(String text) {
    m.value = int.tryParse(text)!;
  }

  void addValueToMatrix(String value) {
    if (!isMatrixFilled && value.isAlphabetOnly) {
      matrixData.add(value.split(""));
    }
  }

  searchValueInMatrix(String value) {
    foundValues.clear();
    isSearched.value = true;
    FindMatrixIndex findMatrixIndex = FindMatrixIndex(matrixData, value);
    foundValues = findMatrixIndex.wordIndices;
  }

  String? getEveryRowData(int row, col) {
    try {
      return matrixData[row][col].toString().toUpperCase();
    } catch (e) {
      return null;
    }
  }

  Rx<MaterialColor> getColor(int row, col, {bool changeColor = false}) {
    if (changeColor) {
      return Colors.green.obs;
    }
    return getEveryRowData(row, col) == null ? Colors.red.obs : Colors.teal.obs;
  }

  Rx<MaterialColor> getColorsAgain(int row, col) {
    for (var cells in foundValues) {
      if (row == cells[0] && col == cells[1]) {
        return Colors.green.obs;
      }
    }
    return getColor(row, col);
  }

  bool get isMatrixFilled => int.parse(getRowValue) == getNValue;

  void setNValue(String text) {
    n.value = int.tryParse(text)!;
  }

  RxBool validateNMValue(String value) {
    if (!value.isAlphabetOnly &&
        value.isNotEmpty &&
        (int.parse(value) > 0 && int.parse(value) <= 9)) {
      return true.obs;
    }
    return false.obs;
  }
}
