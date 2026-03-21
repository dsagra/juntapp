import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  static String date(DateTime? value) {
    if (value == null) return '-';
    return _dateFormat.format(value);
  }

  static String currency(num value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
