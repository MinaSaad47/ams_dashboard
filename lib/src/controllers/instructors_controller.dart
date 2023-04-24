import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/services.dart';

part 'instructors_controller.freezed.dart';
part 'instructors_controller.g.dart';

@freezed
class InstructorsState with _$InstructorsState {
  const factory InstructorsState.initial({
    @Default([]) List<UserDto> instructors,
  }) = InstructorsRetreived;
  const factory InstructorsState.loaded({
    required List<UserDto> instructors,
    required String message,
  }) = InstructorsLoaded;
  const factory InstructorsState.deleted({
    @Default([]) List<UserDto> instructors,
    required String message,
  }) = InstructorsDeleted;
  const factory InstructorsState.created({
    required List<UserDto> instructors,
    required String message,
  }) = InstructorsCreated;
  const factory InstructorsState.updated({
    @Default([]) List<UserDto> instructors,
    required String message,
  }) = InstructorsUpdated;
  const factory InstructorsState.loading({
    @Default([]) List<UserDto> instructors,
    required String message,
  }) = InstructorsLoading;
  const factory InstructorsState.failed({
    @Default([]) List<UserDto> instructors,
    required ServiceError error,
  }) = InstructorsFailed;
}

@riverpod
class InstructorsControleer extends _$InstructorsControleer {
  late final InstructorsService _service;

  @override
  InstructorsState build() {
    _service = ref.watch(instructorsServiceProvider);
    return const InstructorsState.initial();
  }

  Future<void> retreive() async {
    state = InstructorsState.loaded(
      instructors: state.instructors,
      message: 'loading attendees',
    );

    final response = await _service.getAll();

    state = response.when(
      success: (message, data) => InstructorsState.loaded(
        instructors: data!,
        message: message,
      ),
      failure: (error) => InstructorsState.failed(
        error: error,
        instructors: state.instructors,
      ),
    );
  }

  Future<void> delete(String id) async {
    state = InstructorsState.loading(
      instructors: state.instructors,
      message: 'deleting attendee',
    );
    final response = await _service.deleteOne(id);

    state = response.when(
      success: (message, data) => InstructorsState.deleted(
        instructors: state.instructors.where((e) => e.id != id).toList(),
        message: message,
      ),
      failure: (error) => InstructorsState.failed(
        error: error,
        instructors: state.instructors,
      ),
    );
  }

  Future<void> create({
    required String name,
    required int number,
    required String email,
    required String password,
  }) async {
    state = InstructorsState.loading(
      instructors: state.instructors,
      message: 'creating attendee',
    );
    final response = await _service.createOne(CreateUserDto(
      name: name,
      email: email,
      password: password,
      number: number,
    ));

    state = response.when(
      success: (message, data) => InstructorsState.created(
        instructors: [data!, ...state.instructors],
        message: message,
      ),
      failure: (error) => InstructorsState.failed(
        error: error,
        instructors: state.instructors,
      ),
    );
  }

  Future<void> update(
    String id, {
    String? name,
    int? number,
    String? email,
    String? password,
    File? image,
  }) async {
    state = InstructorsState.loading(
      instructors: state.instructors,
      message: 'updating attendee',
    );
    final response = await _service.updateOne(
        id,
        UpdateUserDto(
          name: name,
          email: email,
          password: password,
          number: number,
        ));

    state = await response.when(
      success: (message, data) async {
        if (image != null) {
          final response = await _service.uploadPhoto(id, image);
          if (response is ServiceError) {
            return InstructorsState.failed(error: response as ServiceError);
          }
        }

        return InstructorsState.updated(
          message: message,
          instructors: [data!, ...state.instructors.where((e) => e.id != id)],
        );
      },
      failure: (error) => InstructorsState.failed(
        error: error,
        instructors: state.instructors,
      ),
    );
  }
}
