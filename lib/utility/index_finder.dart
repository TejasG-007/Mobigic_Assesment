class FindMatrixIndex{
  final List<List<String>> mMatrix;
  final String wordToFind;

  FindMatrixIndex(this.mMatrix,this.wordToFind){
    findWordIndices(mMatrix, wordToFind);
  }

  List<List<List<int>>> findWordIndices(List<List<String>> mMatrix, String wordToFind) {
    List<List<List<int>>> allIndices = [];

    int rows = mMatrix.length;
    int cols = mMatrix[0].length;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (mMatrix[i][j] == wordToFind[0]) {
          List<List<int>> wordIndices = searchWord(mMatrix, wordToFind, i, j);
          if (wordIndices.isNotEmpty) {
            allIndices.add(wordIndices);
          }
        }
      }
    }

    return allIndices;
  }

  List<List<int>> wordIndices = [];
  List<List<int>> searchWord(List<List<String>> mMatrix, String wordToFind, int startRow, int startCol) {
    int rows = mMatrix.length;
    int cols = mMatrix[0].length;
    int wordLength = wordToFind.length;

    if (startCol + wordLength <= cols) {
      bool found = true;
      for (int i = 0; i < wordLength; i++) {
        if (mMatrix[startRow][startCol + i] != wordToFind[i]) {
          found = false;
          break;
        }
      }
      if (found) {
        for (int i = 0; i < wordLength; i++) {
          wordIndices.add([startRow, startCol + i]);
        }
        return wordIndices;
      }
    }

    if (startRow + wordLength <= rows) {
      bool found = true;
      for (int i = 0; i < wordLength; i++) {
        if (mMatrix[startRow + i][startCol] != wordToFind[i]) {
          found = false;
          break;
        }
      }
      if (found) {
        for (int i = 0; i < wordLength; i++) {
          wordIndices.add([startRow + i, startCol]);
        }
        return wordIndices;
      }
    }

    if (startRow + wordLength <= rows && startCol + wordLength <= cols) {
      bool found = true;
      for (int i = 0; i < wordLength; i++) {
        if (mMatrix[startRow + i][startCol + i] != wordToFind[i]) {
          found = false;
          break;
        }
      }
      if (found) {
        for (int i = 0; i < wordLength; i++) {
          wordIndices.add([startRow + i, startCol + i]);
        }
        return wordIndices;
      }
    }
    return wordIndices;
  }

}