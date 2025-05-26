
import 'package:intl/intl.dart';

class TextFormatter {

  TextFormatter._();

  static final formaRealPattern = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  
  static String formatReal(double value) => formaRealPattern.format(value);
}