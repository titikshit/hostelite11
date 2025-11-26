import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
          const SizedBox(width: 16),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) => _buildDashboardContent(context, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, Profile? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Section
          _buildProfileSection(profile),
          const SizedBox(height: 40),

          // Action Cards Grid
          _buildActionCardsGrid(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Profile? profile) {
    return Column(
      children: [
        // Profile Circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
              width: 4,
            ),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),

        // User Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoChip(
              Icons.person,
              profile?.fullName ?? 'Student Name',
              Colors.grey[700]!,
            ),
            const SizedBox(width: 16),
            _buildInfoChip(
              Icons.home,
              _getHostelDisplayName(profile?.hostelId ?? 'bose_hostel'),
              Colors.grey[700]!,
            ),
            const SizedBox(width: 16),
            _buildInfoChip(
              Icons.room,
              'Room ${profile?.roomNo ?? 'A-204'}',
              Colors.grey[700]!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCardsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildActionCard(
          context,
          'Register Complaint',
          'Report issues or concerns',
          Icons.description,
          Colors.green,
          Colors.green[50]!,
          () => context.push('/register-complaint'),
        ),
        _buildActionCard(
          context,
          'View Notices',
          'Check latest announcements',
          Icons.notifications,
          Colors.orange[700]!,
          Colors.orange[50]!,
          () => context.push('/notices'),
        ),
        _buildActionCard(
          context,
          'Fee Status',
          'View payment details',
          Icons.credit_card,
          Colors.orange[700]!,
          Colors.orange[50]!,
          () => context.push('/fees'),
        ),
        _buildActionCard(
          context,
          'Fill Form',
          'Fill out important forms',
          Icons.assignment,
          Colors.blue[700]!,
          Colors.blue[50]!,
          () => context.push('/forms'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getHostelDisplayName(String hostelId) {
    switch (hostelId) {
      case 'mvcv_hostel':
        return 'MVCV Hostel';
      case 'bhaba_hostel':
        return 'Bhaba Hostel';
      case 'bose_hostel':
        return 'Bose Hostel';
      default:
        return 'Sunrise Hostel';
    }
  }
}
