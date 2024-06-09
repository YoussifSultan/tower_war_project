import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class dataCardTile extends StatelessWidget {
  const dataCardTile({
    super.key,
    required this.hintingText,
    required this.DataText,
  });
  final String hintingText;
  final RxString DataText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'data',
              style: TextStyle(
                  fontFamily: 'PixelText', fontSize: 20, color: Colors.black),
            ),
            Text(
              'placeholder',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400),
            )
          ],
        ),
      ),
    );
  }
}
