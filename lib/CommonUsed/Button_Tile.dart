import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonTile extends StatefulWidget {
  const ButtonTile({super.key, required this.text, required this.onTap});
  final String text;
  final Function onTap;
  @override
  State<ButtonTile> createState() => _ButtonTileState();
}

class _ButtonTileState extends State<ButtonTile> {
  RxBool isClicking = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => isClicking(true),
      onTapUp: (details) => isClicking(false),
      onTap: () {
        widget.onTap();
      },
      child: Obx(
        () => Container(
          width: 200,
          height: 50,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            boxShadow: isClicking.value
                ? []
                : [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(7, 7),
                    )
                  ],
            borderRadius: BorderRadius.circular(20),
            color: isClicking.value
                ? Color.fromRGBO(240, 73, 79, 1)
                : Color.fromRGBO(37, 68, 65, 1),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                  fontFamily: 'PixelText',
                  fontSize: 20,
                  color: isClicking.value
                      ? Color.fromRGBO(37, 68, 65, 1)
                      : Color.fromRGBO(240, 73, 79, 1)),
            ),
          ),
        ),
      ),
    );
  }
}
