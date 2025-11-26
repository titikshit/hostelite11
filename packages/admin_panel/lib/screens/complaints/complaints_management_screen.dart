import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../widgets/admin_sidebar.dart';

class ComplaintsManagementScreen extends ConsumerWidget {
  const ComplaintsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: userProfileAsync.when(
        data: (profile) {
          if (profile?.role != 'admin') {
            return const Center(child: Text('Access denied'));
          }
          
          final complaintsAsync = ref.watch(hostelComplaintsProvider(profile!.hostelId));
          
          return Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Column(
                  children: [
                    Container(
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
                            'View Complaints',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () => context.go('/admin'),
                            icon: const Icon(Icons.arrow_back, size: 16),
                            label: const Text('Back to Dashboard'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: complaintsAsync.when(
                        data: (complaints) => complaints.isEmpty
                            ? const Center(child: Text('No complaints found'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: complaints.length,
                                itemBuilder: (context, index) {
                                  final complaint = complaints[index];
                                  return _buildComplaintCard(context, ref, complaint);
                                },
                              ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Error: $error')),
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

  Widget _buildComplaintCard(BuildContext context, WidgetRef ref, Complaint complaint) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    complaint.title ?? 'Complaint',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusDropdown(ref, complaint),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              complaint.description,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Room: ${complaint.roomNo ?? 'N/A'}', Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip('Severity: ${complaint.severity}', _getSeverityColor(complaint.severity)),
                const SizedBox(width: 8),
                _buildInfoChip(
                  complaint.createdAt?.toString().substring(0, 10) ?? '',
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(WidgetRef ref, Complaint complaint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: complaint.status,
        underline: const SizedBox(),
        items: ['open', 'in_progress', 'resolved'].map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status.replaceAll('_', ' ').toUpperCase()),
          );
        }).toList(),
        onChanged: (newStatus) async {
          if (newStatus != null && newStatus != complaint.status) {
            try {
              await ref.read(complaintRepositoryProvider).updateComplaintStatus(
                complaint.id,
                newStatus,
              );
              // Refresh the complaints list
              ref.invalidate(hostelComplaintsProvider);
            } catch (e) {
              // Handle error
            }
          }
        },
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
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
}
