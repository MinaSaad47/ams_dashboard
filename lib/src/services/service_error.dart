import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_error.freezed.dart';
part 'service_error.g.dart';

@Freezed(unionKey: 'type')
class ServiceError with _$ServiceError {
  const factory ServiceError.network() = Network;
  const factory ServiceError.notFound(String message) = NotFound;
  const factory ServiceError.unauthorized(String message) = Authorization;
  const factory ServiceError.faceRecognition() = FaceRecogintion;
  const factory ServiceError.badRequest() = BadRequest;
  const factory ServiceError.invalidOperation(String message) =
      InvalidOperation;
  const factory ServiceError.internal() = Internal;
  const factory ServiceError.duplcate(String message) = Duplicate;
  const factory ServiceError.duplicateAttendance(
    String subjectId,
    String attendeeId,
  ) = DuplicateAttendance;

  factory ServiceError.fromJson(Map<String, dynamic> json) =>
      _$ServiceErrorFromJson(json);
}
