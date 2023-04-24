import 'package:cron/cron.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:easy_cron/easy_cron.dart';

final parser = UnixCronParser();

extension EasyCronExt on CronSchedule {
  Schedule into() => Schedule(
        seconds: seconds?.toList(),
        hours: hours?.toList(),
        days: daysOfMonth?.toList(),
        weekdays: daysOfWeek?.toList(),
        minutes: minutes?.toList(),
        months: months?.toList(),
      );
}

extension CronExt on Schedule {
  CronSchedule into() => CronSchedule(
        seconds: seconds?.toSet(),
        hours: hours?.toSet(),
        daysOfMonth: days?.toSet(),
        daysOfWeek: weekdays?.toSet(),
        minutes: minutes?.toSet(),
        months: months?.toSet(),
      );
}

class ScheduleJsonConverter extends JsonConverter<CronSchedule, String> {
  const ScheduleJsonConverter();

  @override
  CronSchedule fromJson(String json) {
    final cron = Schedule.parse(json);
    return cron.into();
  }

  @override
  String toJson(CronSchedule object) => object.toString();
}
