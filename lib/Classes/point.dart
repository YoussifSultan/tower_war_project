class Point {
  int rowIndex, colIndex;
  Point({
    required this.rowIndex,
    required this.colIndex,
  });
  @override
  String toString() {
    return 'rowIndex : ${rowIndex + 1} colIndex : ${colIndex + 1} \n';
  }
}
