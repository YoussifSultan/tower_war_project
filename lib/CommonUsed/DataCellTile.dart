import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class dataCardTile extends StatelessWidget {
  const dataCardTile({
    super.key,
    required this.hintingText,
    required this.DataText,
    this.width = 150,
  });
  final String hintingText;
  final double width;
  final RxString DataText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(5),
      width: width,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DataText.value,
            style: TextStyle(
                fontFamily: 'PixelText', fontSize: 20, color: Colors.black),
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
