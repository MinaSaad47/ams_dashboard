import 'dart:io';

import 'package:ams_dashboard/src/services/AMSService/dtos/dtos.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/env.dart';

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
    @Body() CreateUserDto create,
  );

  @DELETE('/{id}')
  Future<ResponseDto> deleteOne(@Path() String id);

  @PATCH('/{id}')
  Future<ResponseDto<SubjectDto>> updateOne(
    @Path() String id,
    @Body() UpdateUserDto update,
  );
}

@riverpod
AttendeesService attendeesService(AttendeesServiceRef ref) {
  final dio = Dio();

  dio.options.headers.addAll({
    'Authorization': 'Bearer ${EnvVars.apiToken}',
  });

  return AttendeesService(dio, baseUrl: '${EnvVars.apiUrl}/api/attendees');
}

@riverpod
InstructorsService instructorsService(InstructorsServiceRef ref) {
  final dio = Dio();

  dio.options.headers.addAll({
    'Authorization': 'Bearer ${EnvVars.apiToken}',
  });

  return InstructorsService(dio, baseUrl: '${EnvVars.apiUrl}/api/instructors');
}
