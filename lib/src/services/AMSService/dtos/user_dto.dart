import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required int number,
    required String name,
    required String email,
    required DateTime createAt,
    required DateTime updatedAt,
    String? image,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, Object?> json) =>
      _$UserDtoFromJson(json);
}

@freezed
class CreateUserDto with _$CreateUserDto {
  const factory CreateUserDto({
    required String name,
    required String email,
    required String password,
    required int number,
  }) = _CreateUserDto;

  factory CreateUserDto.fromJson(Map<String, Object?> json) =>
      _$CreateUserDtoFromJson(json);
}

@freezed
class UpdateUserDto with _$UpdateUserDto {
  const factory UpdateUserDto({
    String? name,
    String? email,
    String? password,
    int? number,
  }) = _UpdateUserDto;

  factory UpdateUserDto.fromJson(Map<String, Object?> json) =>
      _$UpdateUserDtoFromJson(json);
}

@freezed
class MyState with _$MyState {
  const factory MyState.init() = Init;
  const factory MyState.loaded({required List<String> data}) = Loaded;
  const factory MyState.errored({
    required List<String> data,
    required String error,
  }) = Errored;
}
