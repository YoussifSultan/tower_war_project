enum TileStatus {
  blankTile,
  deadTroopsTile,
  TroopsTile,
  TowerTile,
  BrokenTowerTile,
}

enum SelectedMode {
  AddTroops,
  ReduceTroops,
}

class Convertions {
  static TileStatus GetCellStatusFromCellData(String CellData) {
    return CellData.contains('T') && !CellData.contains('C')
        ? TileStatus.TowerTile
        : CellData.contains('TC')
            ? TileStatus.BrokenTowerTile
            : CellData.contains('W')
                ? TileStatus.TroopsTile
                : CellData.contains('.')
                    ? TileStatus.deadTroopsTile
                    : CellData == '_'
                        ? TileStatus.blankTile
                        : TileStatus.blankTile;
  }
}
