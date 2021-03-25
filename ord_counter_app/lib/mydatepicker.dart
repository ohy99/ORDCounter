import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MyDateTimePicker
{
  static Future<String> selectDate(BuildContext context, String formatPattern, int yearRange) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - yearRange),
        lastDate: DateTime(DateTime.now().year + yearRange));
    if (picked != null)
      return DateFormat(formatPattern).format(picked);
    return "";
  }

  static Future<String> selectDateRange(BuildContext context, String formatPattern, int yearRange) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - yearRange),
        lastDate: DateTime(DateTime.now().year + yearRange));
    if (picked != null)
      return DateFormat(formatPattern).format(picked);
    return "";
  }
}