import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/services.dart';

part 'attendees_controller.freezed.dart';
part 'attendees_controller.g.dart';

@freezed
class AttendeesState with _$AttendeesState {
  const factory AttendeesState.initial({
    @Default([]) List<UserDto> attendees,
  }) = Retreived;
  const factory AttendeesState.loaded({
    required List<UserDto> attendees,
    required String message,
  }) = Loaded;
  const factory AttendeesState.deleted({
    @Default([]) List<UserDto> attendees,
    required String message,
  }) = Deleted;
  const factory AttendeesState.created({
    required List<UserDto> attendees,
    required String message,
  }) = Created;
  const factory AttendeesState.updated({
    @Default([]) List<UserDto> attendees,
    required String message,
  }) = Updated;
  const factory AttendeesState.loading({
    @Default([]) List<UserDto> attendees,
    required String message,
  }) = Loading;
  const factory AttendeesState.failed({
    @Default([]) List<UserDto> attendees,
    required ServiceError error,
  }) = Failed;
}

@riverpod
class AttendeesControleer extends _$AttendeesControleer {
  late final AttendeesService _service;

  @override
  AttendeesState build() {
    _service = ref.watch(attendeesServiceProvider);
    return const AttendeesState.initial();
  }

  Future<void> retreive() async {
    state = AttendeesState.loaded(
      attendees: state.attendees,
      message: 'loading attendees',
    );

    final response = await _service.getAll();

    state = response.when(
      success: (message, data) => AttendeesState.loaded(
        attendees: data!,
        message: message,
      ),
      failure: (error) => AttendeesState.failed(
        error: error,
        attendees: state.attendees,
      ),
    );
  }

  Future<void> delete(String id) async {
    state = AttendeesState.loading(
      attendees: state.attendees,
      message: 'deleting attendee',
    );
    final response = await _service.deleteOne(id);

    state = response.when(
      success: (message, data) => AttendeesState.deleted(
        attendees: state.attendees.where((e) => e.id != id).toList(),
        message: message,
      ),
      failure: (error) => AttendeesState.failed(
        error: error,
        attendees: state.attendees,
      ),
    );
  }

  Future<void> create({
    required String name,
    required int number,
    required String email,
    required String password,
  }) async {
    state = AttendeesState.loading(
      attendees: state.attendees,
      message: 'creating attendee',
    );
    final response = await _service.createOne(CreateUserDto(
      name: name,
      email: email,
      password: password,
      number: number,
    ));

    state = response.when(
      success: (message, data) => AttendeesState.created(
        attendees: [data!, ...state.attendees],
        message: message,
      ),
      failure: (error) => AttendeesState.failed(
        error: error,
        attendees: state.attendees,
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
    state = AttendeesState.loading(
      attendees: state.attendees,
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
            return AttendeesState.failed(error: response as ServiceError);
          }
        }

        return AttendeesState.updated(
          message: message,
          attendees: [data!, ...state.attendees.where((e) => e.id != id)],
        );
      },
      failure: (error) => AttendeesState.failed(
        error: error,
        attendees: state.attendees,
      ),
    );
  }
}
