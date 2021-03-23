import 'package:intl/intl.dart';

extension DoubleFormat on double {
  String toCurrency() => NumberFormat.simpleCurrency().format(this);
}
