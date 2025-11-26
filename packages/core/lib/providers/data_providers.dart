import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notice.dart';
import '../models/complaint.dart';
import '../models/fee.dart';
import '../models/room.dart';
import '../models/form.dart';
import '../repositories/notice_repository.dart';
import '../repositories/complaint_repository.dart';
import '../repositories/fee_repository.dart';
import '../repositories/room_repository.dart';
import '../repositories/form_repository.dart';
import '../repositories/form_response_repository.dart';

// Repository providers
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository();
});

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  return ComplaintRepository();
});

final feeRepositoryProvider = Provider<FeeRepository>((ref) {
  return FeeRepository();
});

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository();
});

final formRepositoryProvider = Provider<FormRepository>((ref) {
  return FormRepository();
});

final formResponseRepositoryProvider = Provider<FormResponseRepository>((ref) {
  return FormResponseRepository();
});

// Data providers
final noticesProvider =
    FutureProvider.family<List<Notice>, String>((ref, hostelId) async {
  final repository = ref.read(noticeRepositoryProvider);
  return repository.fetchNotices(hostelId);
});

final studentComplaintsProvider =
    FutureProvider.family<List<Complaint>, String>((ref, studentId) async {
  final repository = ref.read(complaintRepositoryProvider);
  return repository.fetchComplaintsByStudent(studentId);
});

final hostelComplaintsProvider =
    FutureProvider.family<List<Complaint>, String>((ref, hostelId) async {
  final repository = ref.read(complaintRepositoryProvider);
  return repository.fetchComplaintsByHostel(hostelId);
});

final studentFeesProvider =
    FutureProvider.family<List<Fee>, String>((ref, studentId) async {
  final repository = ref.read(feeRepositoryProvider);
  return repository.fetchFeesByStudent(studentId);
});

final hostelFeesProvider =
    FutureProvider.family<List<Fee>, String>((ref, hostelId) async {
  final repository = ref.read(feeRepositoryProvider);
  return repository.fetchFeesByHostel(hostelId);
});

final hostelRoomsProvider =
    FutureProvider.family<List<Room>, String>((ref, hostelId) async {
  final repository = ref.read(roomRepositoryProvider);
  return repository.fetchRoomsByHostel(hostelId);
});

final roomStatsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, hostelId) async {
  final repository = ref.read(roomRepositoryProvider);
  return repository.getRoomStats(hostelId);
});

final studentFormsProvider =
    FutureProvider.family<List<HostelForm>, String>((ref, hostelId) async {
  final repository = ref.read(formRepositoryProvider);
  return repository.fetchFormsByHostel(hostelId);
});

final studentFormResponsesProvider =
    FutureProvider.family<List<FormResponse>, String>((ref, studentId) async {
  final repository = ref.read(formResponseRepositoryProvider);
  return repository.fetchFormResponsesByStudent(studentId);
});

// New provider for the admin dashboard
final adminFormResponsesProvider =
    FutureProvider.family<List<FormResponse>, String>((ref, hostelId) async {
  final formRepo = ref.read(formRepositoryProvider);
  final formResponseRepo = ref.read(formResponseRepositoryProvider);

  // Fetch all forms for the hostel
  final forms = await formRepo.fetchFormsByHostel(hostelId);
  final formIds = forms.map((f) => f.id).toList();

  // Fetch all responses for those forms
  List<FormResponse> allResponses = [];
  for (String formId in formIds) {
    final responses = await formResponseRepo.fetchFormResponsesByFormId(formId);
    allResponses.addAll(responses);
  }

  // Sort by created_at descending and take the first 3
  allResponses.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  return allResponses.take(3).toList();
});

// State notifier providers for managing state changes
final noticesStateProvider = StateNotifierProvider.family<NoticesNotifier,
    AsyncValue<List<Notice>>, String>(
  (ref, hostelId) => NoticesNotifier(ref, hostelId),
);

class NoticesNotifier extends StateNotifier<AsyncValue<List<Notice>>> {
  final Ref _ref;
  final String _hostelId;

  NoticesNotifier(this._ref, this._hostelId)
      : super(const AsyncValue.loading()) {
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final repository = _ref.read(noticeRepositoryProvider);
      final notices = await repository.fetchNotices(_hostelId);
      state = AsyncValue.data(notices);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadNotices();
  }

  Future<void> createNotice({
    required String title,
    String? body,
    String tag = 'General',
  }) async {
    try {
      final repository = _ref.read(noticeRepositoryProvider);
      await repository.createNotice(
        hostelId: _hostelId,
        title: title,
        body: body,
        tag: tag,
      );
      await refresh();
    } catch (error) {
      rethrow;
    }
  }
}
