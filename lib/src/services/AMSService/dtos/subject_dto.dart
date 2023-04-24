import 'package:easy_cron/easy_cron.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'dtos.dart';
import 'json_converters/schedule_json_converter.dart';

part 'subject_dto.freezed.dart';
part 'subject_dto.g.dart';

@freezed
class SubjectDto with _$SubjectDto {
  const factory SubjectDto({
    required String id,
    required String name,
    required UserDto instructor,
    required DateTime createAt,
    @ScheduleJsonConverter() required CronSchedule cronExpr,
    required DateTime updatedAt,
  }) = _SubjectDto;

  factory SubjectDto.fromJson(Map<String, Object?> json) =>
      _$SubjectDtoFromJson(json);
}
