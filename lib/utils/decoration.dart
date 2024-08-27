import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final String? svgPath;
  final Color containerColor;
  final Color textColor;

  const CustomContainer({
    Key? key,
    required this.text,
    this.svgPath,
    this.containerColor = const Color.fromARGB(255, 228, 227, 227),
    this.textColor = const Color.fromARGB(255, 65, 65, 65),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgPath != null)
              SvgPicture.asset(
                svgPath!,
                height: 15,
                width: 15,
              ),
            if (svgPath != null)
              SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
