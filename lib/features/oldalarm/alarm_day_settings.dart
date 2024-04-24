import 'package:alarm/alarm.dart';

class AlarmDaySettings {
  final AlarmSettings? alarmSettings;
  AlarmDaySettings({
    this.alarmSettings,
  });

  //bool weekday selector
  final List listDays = [];

  AlarmDaySettings copyWith({
    AlarmSettings? alarmSettings,
  }) {
    return AlarmDaySettings(
      alarmSettings: alarmSettings ?? this.alarmSettings,
    );
  }

  @override
  String toString() => 'AlarmDaySettings(alarmSettings: $alarmSettings)';

  @override
  bool operator ==(covariant AlarmDaySettings other) {
    if (identical(this, other)) return true;

    return other.alarmSettings == alarmSettings;
  }

  @override
  int get hashCode => alarmSettings.hashCode;
}
