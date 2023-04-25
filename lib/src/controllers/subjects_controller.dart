import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/services.dart';

part 'subjects_controller.freezed.dart';
part 'subjects_controller.g.dart';

@freezed
class SubjectsState with _$SubjectsState {
  const factory SubjectsState.initial({
    @Default([]) List<SubjectDto> subjects,
  }) = SubjectsInitial;
  const factory SubjectsState.retrieved({
    required List<SubjectDto> subjects,
    required String message,
  }) = SubjectsRetrieved;
  const factory SubjectsState.deleted({
    @Default([]) List<SubjectDto> subjects,
    required String message,
  }) = SubjectsDeleted;
  const factory SubjectsState.created({
    required List<SubjectDto> subjects,
    required String message,
  }) = SubjectsCreated;
  const factory SubjectsState.updated({
    @Default([]) List<SubjectDto> subjects,
    required String message,
  }) = SubjectsUpdated;
  const factory SubjectsState.loading({
    @Default([]) List<SubjectDto> subjects,
    required String message,
  }) = SubjectsLoading;
  const factory SubjectsState.failed({
    @Default([]) List<SubjectDto> subjects,
    required ServiceError error,
  }) = SubjectsFailed;
}

@riverpod
class SubjectsControleer extends _$SubjectsControleer {
  late final SubjectsService _service;

  @override
  SubjectsState build() {
    _service = ref.watch(subjectsServiceProvider);
    return const SubjectsState.initial();
  }

  Future<void> retreive() async {
    state = SubjectsState.loading(
      subjects: state.subjects,
      message: 'loading subjects',
    );

    final response = await _service.getAll();

    state = response.when(
      success: (message, data) => SubjectsState.retrieved(
        subjects: data!,
        message: message,
      ),
      failure: (error) => SubjectsState.failed(
        error: error,
        subjects: state.subjects,
      ),
    );
  }

  Future<void> delete(String id) async {
    state = SubjectsState.loading(
      subjects: state.subjects,
      message: 'deleting subject',
    );
    final response = await _service.deleteOne(id);

    state = response.when(
      success: (message, data) => SubjectsState.deleted(
        subjects: state.subjects.where((e) => e.id != id).toList(),
        message: message,
      ),
      failure: (error) => SubjectsState.failed(
        error: error,
        subjects: state.subjects,
      ),
    );
  }

  Future<void> create({
    required String name,
    required String cronExpr,
  }) async {
    state = SubjectsState.loading(
      subjects: state.subjects,
      message: 'creating subject',
    );
    final response = await _service.createOne(CreateSubjectDto(
      name: name,
      cronExpr: cronExpr,
    ));

    state = response.when(
      success: (message, data) => SubjectsState.created(
        subjects: [data!, ...state.subjects],
        message: message,
      ),
      failure: (error) => SubjectsState.failed(
        error: error,
        subjects: state.subjects,
      ),
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? cronExpr,
  }) async {
    state = SubjectsState.loading(
      subjects: state.subjects,
      message: 'updating subject',
    );
    final response = await _service.updateOne(
      id,
      UpdateSubjectDto(
        name: name,
        cronExpr: cronExpr,
      ),
    );
    state = response.when(
      success: (message, data) => SubjectsState.updated(
        message: message,
        subjects: [data!, ...state.subjects.where((e) => e.id != id).toList()],
      ),
      failure: (error) => SubjectsState.failed(error: error),
    );
  }
}
