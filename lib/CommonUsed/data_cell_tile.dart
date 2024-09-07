import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DataCardTile extends StatelessWidget {
  const DataCardTile({
    super.key,
    required this.hintingText,
    required this.dataText,
    this.width = 150,
  });
  final String hintingText;
  final double width;
  final RxString dataText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(5),
      width: width,
      height: 100,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(37, 68, 65, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            dataText.value,
            style: const TextStyle(
                fontFamily: 'PixelText',
                fontSize: 20,
                color: Color.fromRGBO(240, 73, 79, 1)),
          ),
          Text(
            hintingText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400),
          )
        ],
      ),
    );
  }
}
