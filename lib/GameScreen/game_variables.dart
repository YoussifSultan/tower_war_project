import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tower_war/Classes/player.dart';
import 'package:undo/undo.dart';

class GameVariables {
  static Rx<int> currentPlayerIndex = 0.obs;
  static List<Player> activePlayers = [];

  static late SimpleStack<List<List<String>>> historyController;
  static RxBool isCellSelectionModeSelected = false.obs;
  static RxInt turnRemainingTroops = 0.obs;

  static List<List<RxString>> grid = [];
}
