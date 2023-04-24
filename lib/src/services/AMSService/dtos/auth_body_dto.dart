import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_body_dto.freezed.dart';
part 'auth_body_dto.g.dart';

@freezed
class AuthBodyDto with _$AuthBodyDto {
  const factory AuthBodyDto({required String token}) = _AuthBodyDto;
  factory AuthBodyDto.fromJson(Map<String, Object?> json) =>
      _$AuthBodyDtoFromJson(json);
}
