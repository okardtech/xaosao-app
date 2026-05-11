import 'package:flutter/material.dart';

import '../constants/app_color.dart';

Future<DateTime?> pickDate(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  Color headerColor = AppColors.primary,
}) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(1950),
    lastDate: lastDate ?? DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: headerColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.primaryVariant,
          ),
          dividerColor: headerColor,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: headerColor,
            headerForegroundColor: Colors.white,
            backgroundColor: Colors.white,
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return headerColor;
              return null;
            }),
            todayForegroundColor: WidgetStatePropertyAll(headerColor),
            todayBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
            todayBorder: BorderSide(color: headerColor, width: 1.5),
          ),
        ),
        child: child!,
      );
    },
  );

  return date;
}

Future<TimeOfDay?> pickTime(BuildContext context) => showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
  builder: (ctx, child) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: Colors.white,
          backgroundColor: Colors.white,
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return null;
          }),
          todayForegroundColor: WidgetStatePropertyAll(Colors.blue),
          todayBorder: BorderSide(color: AppColors.primary),
        ),
      ),
      child: child!,
    );
  },
);
