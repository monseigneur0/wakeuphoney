import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('yyyy년 MM월 dd일').format(this);

  String get formattedTime => DateFormat('HH:mm').format(this);

  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);
}
