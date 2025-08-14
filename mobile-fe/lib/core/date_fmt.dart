import 'package:intl/intl.dart';

String yyyyMmDd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
String weekdayPl(DateTime d) =>
    DateFormat('EEEE', 'pl_PL').format(d); // e.g., "sobota"
