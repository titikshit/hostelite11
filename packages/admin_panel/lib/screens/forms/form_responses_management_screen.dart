import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../widgets/admin_sidebar.dart';

// Provider to fetch all forms for the admin's hostel
final adminFormsProvider =
    FutureProvider.family<List<HostelForm>, String>((ref, hostelId) {
  final repository = ref.read(formRepositoryProvider);
  return repository.fetchFormsByHostel(hostelId);
});

class FormResponsesManagementScreen extends ConsumerWidget {
  const FormResponsesManagementScreen({super.key});

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

          final formsAsync = ref.watch(adminFormsProvider(profile!.hostelId));

          return Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: formsAsync.when(
                        data: (forms) => forms.isEmpty
                            ? const Center(
                                child: Text('No forms have been created yet.'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: forms.length,
                                itemBuilder: (context, index) {
                                  final form = forms[index];
                                  return _buildFormCard(context, form);
                                },
                              ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) =>
                            Center(child: Text('Error: $error')),
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

  Widget _buildTopBar(BuildContext context) {
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
            'Form Responses',
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
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, HostelForm form) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(form.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          form.description ?? 'No description.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.push('/admin/form-responses/${form.id}');
        },
      ),
    );
  }
}
