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
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            boxShadow: isClicking.value
                ? []
                : [
                    const BoxShadow(
                      blurRadius: 10,
                      offset: Offset(7, 7),
                    )
                  ],
            borderRadius: BorderRadius.circular(20),
            color: isClicking.value
                ? const Color.fromRGBO(240, 73, 79, 1)
                : const Color.fromRGBO(37, 68, 65, 1),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                  fontFamily: 'PixelText',
                  fontSize: 20,
                  color: isClicking.value
                      ? const Color.fromRGBO(37, 68, 65, 1)
                      : const Color.fromRGBO(240, 73, 79, 1)),
            ),
          ),
        ),
      ),
    );
  }
}

class IconTile extends StatefulWidget {
  const IconTile(
      {super.key, required this.onTap, required this.foregroundIcon});
  final IconData foregroundIcon;
  final Function onTap;
  @override
  State<IconTile> createState() => _IconTileState();
}

class _IconTileState extends State<IconTile> {
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
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            clipBehavior: Clip.hardEdge,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: isClicking.value
                  ? []
                  : [
                      const BoxShadow(
                        blurRadius: 10,
                        offset: Offset(7, 7),
                      )
                    ],
              borderRadius: BorderRadius.circular(50),
              color: isClicking.value
                  ? const Color.fromRGBO(173, 155, 170, 1)
                  : Colors.white,
            ),
            child: Center(
              child: Icon(
                widget.foregroundIcon,
                size: 40,
                color: isClicking.value
                    ? Colors.white
                    : const Color.fromRGBO(173, 155, 170, 1),
              ),
            )),
      ),
    );
  }
}
