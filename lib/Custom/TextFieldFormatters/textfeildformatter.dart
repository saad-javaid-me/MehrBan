import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digits from the new value
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert hyphens after every 4 digits
    String formattedText = '';
    for (int i = 0; i < cleanedText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += '-';
      }
      formattedText += cleanedText[i];
    }

    // Limit the length to 16 digits + 3 hyphens (19 characters)
    if (formattedText.length > 19) {
      formattedText = formattedText.substring(0, 19);
    }

    // Return the formatted text
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}





class ExpirationDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digits from the new value
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the input as MM/YY
    String formattedText = '';

    // Limit the input to 2 digits for the month
    if (cleanedText.length >= 1) {
      formattedText += cleanedText.substring(0, 1); // First digit for the month
    }
    if (cleanedText.length >= 2) {
      formattedText = cleanedText.substring(0, 2); // Second digit for the month
    }

    // Add '/' after 2 digits of month
    if (cleanedText.length > 2) {
      formattedText += '/';
    }

    // Limit the input to 2 digits for the year (after the '/')
    if (cleanedText.length >= 3) {
      formattedText += cleanedText.substring(2, 4); // First digit for year (YY)
    }
    if (cleanedText.length >= 4) {
      formattedText = formattedText.substring(0, formattedText.length - 1) + cleanedText.substring(3, 4); // Second digit for year (YY)
    }

    // Limit the length to 5 characters (MM/YY)
    if (formattedText.length > 5) {
      formattedText = formattedText.substring(0, 5);
    }

    // Ensure valid month range (01-12)
    if (formattedText.length >= 2) {
      String monthPart = formattedText.substring(0, 2);
      if (int.tryParse(monthPart) != null && int.parse(monthPart) > 12) {
        formattedText = '12' + formattedText.substring(2); // Force to 12 if the month exceeds 12
      }
    }

    // Validate the year range (YY should be between 25 and 35)
    if (formattedText.length >= 5) {
      String yearPart = formattedText.substring(3, 5);
      int year = int.tryParse(yearPart) ?? 0;
      if (year < 25) {
        // If year is less than 25, adjust it to 25
        formattedText = formattedText.substring(0, 3) + '25';
      } else if (year > 35) {
        // If year is greater than 35, adjust it to 35
        formattedText = formattedText.substring(0, 3) + '35';
      }
    }

    // Return the formatted text
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


class CVVInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digits from the input
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit the input to 3 digits
    if (cleanedText.length > 3) {
      cleanedText = cleanedText.substring(0, 3);
    }

    // Return the formatted text
    return TextEditingValue(
      text: cleanedText,
      selection: TextSelection.collapsed(offset: cleanedText.length),
    );
  }
}
