import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:easy_cron/easy_cron.dart';

final parser = UnixCronParser();

class DurationJsonConverter extends JsonConverter<Duration, int> {
  const DurationJsonConverter();

  @override
  Duration fromJson(int json) => Duration(minutes: json);

  @override
  int toJson(Duration object) => object.inMinutes;
}
