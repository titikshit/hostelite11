import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../widgets/admin_sidebar.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  String? _selectedCourse;
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: userProfileAsync.when(
        data: (profile) {
          if (profile?.role != 'admin') {
            return const Center(child: Text('Access denied'));
          }

          return Row(
            children: [
              // Left Sidebar
              const AdminSidebar(),

              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Top Bar
                    _buildTopBar(),

                    // Dashboard Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // KPI Cards
                            _buildKPICards(profile!.hostelId),
                            const SizedBox(height: 32),

                            // Recent Panels Row
                            _buildRecentPanels(profile.hostelId),
                            const SizedBox(height: 32),

                            // Student Information Table
                            _buildStudentTable(profile.hostelId),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Hostel Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 32),

          // Course Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  hint: const Text('Choose Course'),
                  value: _selectedCourse,
                  underline: const SizedBox(),
                  items: ['CSE', 'ECE', 'ME', 'CE'].map((course) {
                    return DropdownMenuItem(value: course, child: Text(course));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCourse = value),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Year Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  hint: const Text('Year'),
                  value: _selectedYear,
                  underline: const SizedBox(),
                  items: ['1st', '2nd', '3rd', '4th'].map((year) {
                    return DropdownMenuItem(value: year, child: Text(year));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedYear = value),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards(String hostelId) {
    final roomStatsAsync = ref.watch(roomStatsProvider(hostelId));
    final studentsAsync = ref.watch(FutureProvider((ref) =>
        ref.read(profileRepositoryProvider).fetchProfilesByHostel(hostelId)));

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Students',
            studentsAsync.when(
              data: (students) =>
                  students.where((s) => s.role == 'student').length.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Total Rooms',
            roomStatsAsync.when(
              data: (stats) => stats['totalRooms'].toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.room,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Allotted Rooms',
            roomStatsAsync.when(
              data: (stats) => stats['allottedRooms'].toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Empty Rooms',
            roomStatsAsync.when(
              data: (stats) => stats['emptyRooms'].toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            Icons.cancel,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPanels(String hostelId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildRecentFormResponses(hostelId)),
        const SizedBox(width: 16),
        Expanded(child: _buildRecentComplaints(hostelId)),
        const SizedBox(width: 16),
        Expanded(child: _buildRecentNotices(hostelId)),
      ],
    );
  }

  Widget _buildRecentFormResponses(String hostelId) {
    final formResponsesAsync = ref.watch(adminFormResponsesProvider(hostelId));

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Form Responses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/admin/form-responses'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            formResponsesAsync.when(
              data: (responses) => responses.isEmpty
                  ? const Text('No recent form responses.')
                  : Column(
                      children: responses
                          .map((response) => _buildFormResponseItem(response))
                          .toList(),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading form responses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormResponseItem(FormResponse response) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student ID: ${response.studentId.substring(0, 8)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            'Submitted: ${response.createdAt?.toLocal().toString().substring(0, 16) ?? ''}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Chip(
            label: Text(response.status, style: const TextStyle(fontSize: 11)),
            backgroundColor: response.status == 'Pending'
                ? Colors.orange.withOpacity(0.2)
                : Colors.green.withOpacity(0.2),
            labelStyle: TextStyle(
              color:
                  response.status == 'Pending' ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentComplaints(String hostelId) {
    final complaintsAsync = ref.watch(hostelComplaintsProvider(hostelId));

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Complaints',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            complaintsAsync.when(
              data: (complaints) => Column(
                children: complaints
                    .take(3)
                    .map((complaint) => _buildComplaintItem(complaint))
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading complaints'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintItem(Complaint complaint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            complaint.title ?? 'Complaint',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '${complaint.roomNo ?? 'N/A'} - ${complaint.createdAt?.toString().substring(0, 10) ?? ''}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Chip(
            label:
                Text(complaint.severity, style: const TextStyle(fontSize: 11)),
            backgroundColor:
                _getSeverityColor(complaint.severity).withOpacity(0.2),
            labelStyle: TextStyle(color: _getSeverityColor(complaint.severity)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNotices(String hostelId) {
    final noticesAsync = ref.watch(noticesProvider(hostelId));

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Notices',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            noticesAsync.when(
              data: (notices) => Column(
                children: notices
                    .take(3)
                    .map((notice) => _buildNoticeItem(notice))
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading notices'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeItem(Notice notice) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notice.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            notice.createdAt?.toString().substring(0, 10) ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Chip(
            label: Text(notice.tag, style: const TextStyle(fontSize: 11)),
            backgroundColor: notice.tag == 'Important'
                ? Colors.red.withOpacity(0.2)
                : Colors.blue.withOpacity(0.2),
            labelStyle: TextStyle(
              color: notice.tag == 'Important' ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget _buildStudentTable(String hostelId) {
    final studentsAsync = ref.watch(FutureProvider(
        (ref) => ref.read(profileRepositoryProvider).fetchStudentsByFilters(
              hostelId: hostelId,
              course: _selectedCourse,
              year: _selectedYear,
            )));

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            studentsAsync.when(
              data: (students) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Enrollment No')),
                    DataColumn(label: Text('Student Name')),
                    DataColumn(label: Text('Room No')),
                    DataColumn(label: Text('Father Name')),
                    DataColumn(label: Text('Contact')),
                    DataColumn(label: Text('Fee Status')),
                  ],
                  rows: students
                      .map((student) => DataRow(
                            cells: [
                              DataCell(Text(student.id.substring(0, 8))),
                              DataCell(Text(student.fullName ?? 'N/A')),
                              DataCell(Text(student.roomNo ?? 'N/A')),
                              DataCell(const Text(
                                  'N/A')), // Father name not in model
                              DataCell(Text(student.phone ?? 'N/A')),
                              DataCell(
                                Chip(
                                  label: const Text('Paid',
                                      style: TextStyle(fontSize: 11)),
                                  backgroundColor:
                                      Colors.green.withOpacity(0.2),
                                  labelStyle:
                                      const TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading students'),
            ),
          ],
        ),
      ),
    );
  }
}
