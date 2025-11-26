import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.teal, size: 24),
                SizedBox(width: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem(
                  context,
                  Icons.dashboard,
                  'Dashboard',
                  '/admin',
                  isSelected:
                      GoRouterState.of(context).matchedLocation == '/admin',
                ),
                _buildNavItem(
                  context,
                  Icons.person_add,
                  'Register Student',
                  '/admin/register-student',
                  isSelected: GoRouterState.of(context).matchedLocation ==
                      '/admin/register-student',
                ),
                _buildNavItem(
                  context,
                  Icons.edit,
                  'Edit Student',
                  '/admin/edit-student',
                  isSelected: false,
                ),
                _buildNavItem(
                  context,
                  Icons.room,
                  'Manage Rooms',
                  '/admin/manage-rooms',
                  isSelected: false,
                ),
                _buildNavItem(
                  context,
                  Icons.notification_add,
                  'Create Notice',
                  '/admin/create-notice',
                  isSelected: GoRouterState.of(context).matchedLocation ==
                      '/admin/create-notice',
                ),
                _buildNavItem(
                  context,
                  Icons.assignment,
                  'Create Form',
                  '/admin/create-form',
                  isSelected: GoRouterState.of(context).matchedLocation ==
                      '/admin/create-form',
                ),
                _buildNavItem(
                  context,
                  Icons.view_list,
                  'View Form Responses',
                  '/admin/form-responses',
                  isSelected: GoRouterState.of(context).matchedLocation ==
                      '/admin/form-responses',
                ),
                _buildNavItem(
                  context,
                  Icons.report,
                  'View Complaints',
                  '/admin/complaints',
                  isSelected: GoRouterState.of(context).matchedLocation ==
                      '/admin/complaints',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => context.go(route),
      ),
    );
  }
}
