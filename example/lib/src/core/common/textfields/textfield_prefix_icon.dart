import 'package:flutter/material.dart';

class TextfieldPrefixIcon extends StatelessWidget {
  final String assetName;
  const TextfieldPrefixIcon({super.key, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
      child: SizedBox(
          //margin: EdgeInsets.only(left: 10, bottom: 14, top: 14),
          height: 18,
          width: 18,
          child: Image.asset(
            assetName,
            height: 18,
            width: 18,
            fit: BoxFit.contain,
          ),
      ),
    );
  }
}