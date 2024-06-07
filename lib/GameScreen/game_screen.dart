import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tower_war/CommonUsed/Enums.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  RxBool isAddTroopsModeSelected = false.obs;
  RxBool isReduceTroopsModeSelected = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(76, 179, 212, 1),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 20),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (_, index) {
                RxInt numberOfTroops = 0.obs;
                Rx<TileStatus> statusOfTile = TileStatus.blankTile.obs;
                return GestureDetector(
                    onTap: () {
                      if (isAddTroopsModeSelected.value) {
                        numberOfTroops(numberOfTroops.value + 1);
                      } else if (isReduceTroopsModeSelected.value &&
                          numberOfTroops > 0) {
                        numberOfTroops(numberOfTroops.value - 1);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => Text(
                          numberOfTroops.value != 0
                              ? numberOfTroops.string
                              : '',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ));
              },
              itemCount: 104,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          /*  *SECTION - Modify Add troops Mode  Button*/
          GestureDetector(
            onTap: () {
              isAddTroopsModeSelected(!isAddTroopsModeSelected.value);
              isReduceTroopsModeSelected(false);
            },
            child: Obx(
              () => Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  boxShadow: isAddTroopsModeSelected.value
                      ? []
                      : [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(7, 7),
                          )
                        ],
                  borderRadius: BorderRadius.circular(20),
                  color: isAddTroopsModeSelected.value
                      ? Color.fromRGBO(240, 73, 79, 1)
                      : Color.fromRGBO(37, 68, 65, 1),
                ),
                child: Center(
                  child: Text(
                    'Add Troops',
                    style: TextStyle(
                        fontFamily: 'PixelText',
                        fontSize: 20,
                        color: isAddTroopsModeSelected.value
                            ? Color.fromRGBO(37, 68, 65, 1)
                            : Color.fromRGBO(240, 73, 79, 1)),
                  ),
                ),
              ),
            ),
          ),
          /* *!SECTION */
          /* *SECTION - Modify reduce troops Mode Button*/
          GestureDetector(
            onTap: () {
              isAddTroopsModeSelected(false);
              isReduceTroopsModeSelected(!isReduceTroopsModeSelected.value);
            },
            child: Obx(
              () => Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  boxShadow: isReduceTroopsModeSelected.value
                      ? []
                      : [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(7, 7),
                          )
                        ],
                  borderRadius: BorderRadius.circular(20),
                  color: isReduceTroopsModeSelected.value
                      ? Color.fromRGBO(240, 73, 79, 1)
                      : Color.fromRGBO(37, 68, 65, 1),
                ),
                child: Center(
                  child: Text(
                    'Reduce Troops',
                    style: TextStyle(
                        fontFamily: 'PixelText',
                        fontSize: 20,
                        color: isReduceTroopsModeSelected.value
                            ? Color.fromRGBO(37, 68, 65, 1)
                            : Color.fromRGBO(240, 73, 79, 1)),
                  ),
                ),
              ),
            ),
          )
          /* *!SECTION */
        ],
      ),
    );
  }
}
