import 'package:freezed_annotation/freezed_annotation.dart';

import 'dtos.dart';

part 'attendance_dto.freezed.dart';
part 'attendance_dto.g.dart';

@freezed
class AttendanceDto with _$AttendanceDto {
  const factory AttendanceDto({
    required String id,
    required UserDto attendee,
    required SubjectDto subject,
    required DateTime createAt,
  }) = _AttendanceDto;

  factory AttendanceDto.fromJson(Map<String, Object?> json) =>
      _$AttendanceDtoFromJson(json);
}

@freezed
@freezed
class CreateAttendancesDto with _$CreateAttendancesDto {
  const factory CreateAttendancesDto({
    required List<String> attendeeIds,
  }) = _CreateAttendancesDto;

  factory CreateAttendancesDto.fromJson(Map<String, Object?> json) =>
      _$CreateAttendancesDtoFromJson(json);
}
