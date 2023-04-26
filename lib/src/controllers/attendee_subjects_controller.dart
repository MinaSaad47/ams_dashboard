import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/services.dart';

part 'attendee_subjects_controller.g.dart';
part 'attendee_subjects_controller.freezed.dart';

@freezed
class AttendeeSubjectsState with _$AttendeeSubjectsState {
  const factory AttendeeSubjectsState.initial({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
  }) = AttedeeSubjectsInitial;
  const factory AttendeeSubjectsState.retreived({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
    required String message,
  }) = AttedeeSubjectsRetrieved;
  const factory AttendeeSubjectsState.loading({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
    required String message,
  }) = AttedeeSubjectsLoading;
  const factory AttendeeSubjectsState.failed({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
    required ServiceError error,
  }) = AttedeeSubjectsFailed;
  const factory AttendeeSubjectsState.added({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
    required String message,
  }) = AttedeeSubjectsAdded;
  const factory AttendeeSubjectsState.removed({
    @Default([]) List<SubjectDto> self,
    @Default([]) List<SubjectDto> other,
    required String message,
  }) = AttedeeSubjectsRemoved;
}

@riverpod
class AttendeeSubjectsController extends _$AttendeeSubjectsController {
  late final AttendeesService _attendeesService;
  late final SubjectsService _subjectsService;
  late final String _attendeeId;

  @override
  AttendeeSubjectsState build({required String attendeeId}) {
    _attendeesService = ref.watch(attendeesServiceProvider);
    _subjectsService = ref.watch(subjectsServiceProvider);
    _attendeeId = attendeeId;
    return const AttendeeSubjectsState.initial();
  }

  Future<void> retrieve() async {
    state = const AttendeeSubjectsState.loading(
      message: 'retrieving attendee subjects',
    );
    final response = await _attendeesService.getAllSubjects(_attendeeId);
    state = await response.when(
      success: (message, self) async {
        final response = await _subjectsService.getAll();
        return response.when(
          success: (message, all) {
            return AttendeeSubjectsState.retreived(
              message: 'retrieved attendee subjects',
              self: self!,
              other: {...all!}.difference({...self}).toList(),
            );
          },
          failure: (error) => AttendeeSubjectsState.failed(error: error),
        );
      },
      failure: (error) => AttendeeSubjectsState.failed(error: error),
    );
  }

  Future<void> add(SubjectDto subject) async {
    state = AttendeeSubjectsState.loading(
      message: 'adding attendee subjects',
      other: state.other,
      self: state.self,
    );

    final response = await _attendeesService.addOneSubject(
      _attendeeId,
      subjectId: subject.id,
    );

    state = response.when(
      success: (message, _) {
        return AttendeeSubjectsState.added(
          message: message,
          self: [subject, ...state.self],
          other: state.other.where((e) => e.id != subject.id).toList(),
        );
      },
      failure: (error) => AttendeeSubjectsState.failed(error: error),
    );
  }

  Future<void> remove(SubjectDto subject) async {
    state = AttendeeSubjectsState.loading(
      message: 'removing attendee subjects',
      other: state.other,
      self: state.self,
    );

    final response = await _attendeesService.deleteOneSubject(
      _attendeeId,
      subjectId: subject.id,
    );

    state = response.when(
      success: (message, _) {
        return AttendeeSubjectsState.added(
          message: message,
          self: state.self.where((e) => e.id != subject.id).toList(),
          other: [subject, ...state.other],
        );
      },
      failure: (error) => AttendeeSubjectsState.failed(error: error),
    );
  }
}
