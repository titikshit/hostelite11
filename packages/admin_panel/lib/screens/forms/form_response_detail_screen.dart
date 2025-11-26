import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../widgets/admin_sidebar.dart';

final formResponsesForFormProvider =
    FutureProvider.family<List<FormResponse>, String>((ref, formId) async {
  final repository = ref.read(formResponseRepositoryProvider);
  return repository.fetchFormResponsesByFormId(formId);
});

class FormResponseDetailScreen extends ConsumerWidget {
  final String formId;
  const FormResponseDetailScreen({super.key, required this.formId});

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

          final responsesAsync =
              ref.watch(formResponsesForFormProvider(formId));

          return Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: responsesAsync.when(
                        data: (responses) => responses.isEmpty
                            ? const Center(
                                child: Text('No responses for this form yet.'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: responses.length,
                                itemBuilder: (context, index) {
                                  final response = responses[index];
                                  return _buildResponseCard(
                                      context, ref, response);
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
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to Forms'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard(
      BuildContext context, WidgetRef ref, FormResponse response) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Response from Student ID: ${response.studentId.substring(0, 8)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
            'Submitted on: ${response.createdAt?.toLocal().toString().substring(0, 16)}'),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...response.response.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(entry.value.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
