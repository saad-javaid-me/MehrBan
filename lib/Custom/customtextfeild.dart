import 'package:donation_app/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labeltext,
    required this.hinttext,
    required this.hidetext,
    required this.borderradius,
    this.controller,
    this.validator,
    this.keyboardtype,
    this.onChanged,
    this.inputFormatters,
  });

  final String labeltext;
  final String hinttext;
  final bool hidetext;
  final double borderradius;
  final TextInputType? keyboardtype;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hidetext,
      validator: validator,
      onChanged: onChanged,
      style:  TextStyle(

        fontSize: 18,
        color: Colors.black,
        fontFamily: "poppins",
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderradius),
          borderSide:  BorderSide(color: FColors.barPurple,),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderradius),
          borderSide:  BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderradius),
          borderSide:  BorderSide(
            color: Colors.red,
            width: 2, // Thicker border for error
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderradius),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2, // Ensures error border stays when focused
          ),
        ),
        labelText: labeltext,
        labelStyle:  TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: "poppins",
        ),
        hintText: hinttext,
        hintStyle:  TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: "poppins",
        ),
      ),
      keyboardType: keyboardtype,
      inputFormatters: inputFormatters,
    );
  }
}
