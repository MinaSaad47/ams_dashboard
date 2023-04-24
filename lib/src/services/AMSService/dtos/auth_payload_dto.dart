import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_payload_dto.g.dart';
part 'auth_payload_dto.freezed.dart';

@freezed
class AuthPayloadDto with _$AuthPayloadDto {
  const factory AuthPayloadDto({
    required String email,
    required String password,
  }) = _AuthPayloadDto;

  factory AuthPayloadDto.fromJson(Map<String, Object?> json) =>
      _$AuthPayloadDtoFromJson(json);
}
