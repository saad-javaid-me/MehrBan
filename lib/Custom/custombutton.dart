import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bcolor,
    required this.fcolor,
    required this.bordercolor,
    this.assetIconPath,
    required this.fontsize,
  });

  final String text;
  final VoidCallback onPressed;
  final Color bcolor;
  final Color fcolor;
  final Color bordercolor;
  final double fontsize;
  final String? assetIconPath; // Optional path for asset icon

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate button width based on screen size
    double buttonWidth = screenWidth * 0.8; // Use 80% of the screen width
    double buttonHeight = screenWidth * 0.12; // Use 80% of the screen width
    // if (buttonWidth > 300) buttonWidth = 300; // Cap the width at 300

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: buttonWidth, // Use the calculated button width
        height: buttonHeight,
        child: GestureDetector(
          onTap: (){

          },
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: 1, color: bordercolor),
              elevation: 10,
              backgroundColor: bcolor,
              foregroundColor: fcolor,
              textStyle:  TextStyle(fontSize: fontsize, fontFamily: "poppins"),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (assetIconPath != null) ...[
                  Image.asset(
                    assetIconPath!,
                    height: 24, // Adjust the height to fit your design
                    width: 24,  // Adjust the width to fit your design
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                ],
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
