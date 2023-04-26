import 'dart:io';

import 'package:ams_dashboard/src/services/AMSService/dtos/dtos.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/common.dart';

part 'ams_service.g.dart';

@RestApi()
abstract class InstructorsService {
  factory InstructorsService(Dio dio, {String baseUrl}) = _InstructorsService;

  @GET('')
  Future<ResponseDto<List<UserDto>>> getAll();

  @GET('/{id}')
  Future<ResponseDto<UserDto>> getOne(@Path() String id);

  @POST('')
  Future<ResponseDto<UserDto>> createOne(
    @Body() CreateUserDto create,
  );

  @MultiPart()
  @POST('/{id}/image')
  Future<ResponseDto> uploadPhoto(
    @Path() String id,
    @Part(name: 'image') File image,
  );

  @DELETE('/{id}')
  Future<ResponseDto> deleteOne(@Path() String id);

  @PATCH('/{id}')
  Future<ResponseDto<UserDto>> updateOne(
    @Path() String id,
    @Body() UpdateUserDto update,
  );
}

@RestApi()
abstract class AttendeesService {
  factory AttendeesService(Dio dio, {String baseUrl}) = _AttendeesService;

  @GET('')
  Future<ResponseDto<List<UserDto>>> getAll();

  @GET('/{id}')
  Future<ResponseDto<UserDto>> getOne(@Path() String id);

  @POST('')
  Future<ResponseDto<UserDto>> createOne(
    @Body() CreateUserDto create,
  );

  @MultiPart()
  @POST('/{id}/image')
  Future<ResponseDto> uploadPhoto(
    @Path() String id,
    @Part(name: 'image') File image,
  );

  @DELETE('/{id}')
  Future<ResponseDto> deleteOne(@Path() String id);

  @PATCH('/{id}')
  Future<ResponseDto<UserDto>> updateOne(
    @Path() String id,
    @Body() UpdateUserDto update,
  );

  @GET('/{id}/subjects')
  Future<ResponseDto<List<SubjectDto>>> getAllSubjects(
    @Path() String id,
  );

  @PUT('/{id}/subjects/{subjectId}')
  Future<ResponseDto> addOneSubject(
    @Path() String id, {
    @Path() required String subjectId,
  });

  @DELETE('/{id}/subjects/{subjectId}')
  Future<ResponseDto> deleteOneSubject(
    @Path() String id, {
    @Path() required String subjectId,
  });
}

@RestApi()
abstract class SubjectsService {
  factory SubjectsService(Dio dio, {String baseUrl}) = _SubjectsService;

  @GET('')
  Future<ResponseDto<List<SubjectDto>>> getAll();

  @GET('/{id}')
  Future<ResponseDto<SubjectDto>> getOne(@Path() String id);

  @POST('')
  Future<ResponseDto<SubjectDto>> createOne(
    @Body() CreateSubjectDto create,
  );

  @DELETE('/{id}')
  Future<ResponseDto> deleteOne(@Path() String id);

  @PATCH('/{id}')
  Future<ResponseDto<SubjectDto>> updateOne(
    @Path() String id,
    @Body() UpdateSubjectDto update,
  );
}

@riverpod
Dio dio(DioRef ref) {
  var dio = Dio();
  dio.options.headers.addAll({
    'Authorization': 'Bearer ${EnvVars.apiToken}',
  });
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );
  return dio;
}

@riverpod
AttendeesService attendeesService(AttendeesServiceRef ref) {
  return AttendeesService(
    ref.watch(dioProvider),
    baseUrl: '${EnvVars.apiUrl}/api/attendees',
  );
}

@riverpod
InstructorsService instructorsService(InstructorsServiceRef ref) {
  return InstructorsService(
    ref.watch(dioProvider),
    baseUrl: '${EnvVars.apiUrl}/api/instructors',
  );
}

@riverpod
SubjectsService subjectsService(SubjectsServiceRef ref) {
  return SubjectsService(
    ref.watch(dioProvider),
    baseUrl: '${EnvVars.apiUrl}/api/subjects',
  );
}
