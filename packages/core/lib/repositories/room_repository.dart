import '../models/room.dart';
import '../services/supabase_service.dart';
import '../utils/case_converter.dart';

class RoomRepository {
  final _client = SupabaseService.client;

  Future<List<Room>> fetchRoomsByHostel(String hostelId) async {
    final response = await _client
        .from('rooms')
        .select()
        .eq('hostel_id', hostelId)
        .order('number', ascending: true);
    
    return (response as List)
        .map((e) => Room.fromJson(toCamelCase(e)))
        .toList();
  }

  Future<Room?> fetchRoomById(String id) async {
    final response = await _client
        .from('rooms')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return Room.fromJson(toCamelCase(response));
  }

  Future<void> createRoom({
    required String hostelId,
    required String number,
    int capacity = 1,
    int allotted = 0,
  }) async {
    await _client.from('rooms').insert({
      'hostel_id': hostelId,
      'number': number,
      'capacity': capacity,
      'allotted': allotted,
    });
  }

  Future<void> updateRoom({
    required String id,
    String? number,
    int? capacity,
    int? allotted,
  }) async {
    final updates = <String, dynamic>{};
    
    if (number != null) updates['number'] = number;
    if (capacity != null) updates['capacity'] = capacity;
    if (allotted != null) updates['allotted'] = allotted;
    
    if (updates.isNotEmpty) {
      await _client
          .from('rooms')
          .update(updates)
          .eq('id', id);
    }
  }

  Future<void> deleteRoom(String id) async {
    await _client
        .from('rooms')
        .delete()
        .eq('id', id);
  }

  Future<Map<String, int>> getRoomStats(String hostelId) async {
    final rooms = await fetchRoomsByHostel(hostelId);
    
    final totalRooms = rooms.length;
    final allottedRooms = rooms.where((room) => room.allotted > 0).length;
    final emptyRooms = totalRooms - allottedRooms;
    final totalCapacity = rooms.fold<int>(0, (sum, room) => sum + room.capacity);
    final totalAllotted = rooms.fold<int>(0, (sum, room) => sum + room.allotted);
    
    return {
      'totalRooms': totalRooms,
      'allottedRooms': allottedRooms,
      'emptyRooms': emptyRooms,
      'totalCapacity': totalCapacity,
      'totalAllotted': totalAllotted,
    };
  }
}
