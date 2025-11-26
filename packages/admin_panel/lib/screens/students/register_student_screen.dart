import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:convert';
import '../widgets/admin_sidebar.dart';

class RegisterStudentScreen extends ConsumerStatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  ConsumerState<RegisterStudentScreen> createState() =>
      _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends ConsumerState<RegisterStudentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Single registration form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roomController = TextEditingController();
  String _course = 'CSE';
  String _year = '1st';
  bool _isLoading = false;

  // Bulk import variables
  List<Map<String, dynamic>> _previewData = [];
  String? _fileName;
  bool _isBulkLoading = false;
  Map<String, dynamic>? _bulkResults;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final client = SupabaseService.client;

      String hostelId;
      switch (_year) {
        case '1st':
        case '2nd':
          hostelId = 'mvcv_hostel';
          break;
        case '3rd':
        case '4th':
          hostelId = 'bose_hostel';
          break;
        default:
          hostelId = 'bose_hostel';
      }

      await client.rpc('create_simple_student', params: {
        'user_email': _emailController.text.trim(),
        'user_password': 'password123',
        'user_name': _nameController.text.trim(),
        'user_phone': _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        'user_hostel': hostelId,
        'user_room': _roomController.text.trim().isNotEmpty
            ? _roomController.text.trim()
            : null,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Student registered successfully!\nEmail: ${_emailController.text.trim()}\nPassword: password123'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _roomController.clear();
        setState(() {
          _course = 'CSE';
          _year = '1st';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      _fileName = file.name;

      try {
        List<Map<String, dynamic>> data = [];

        print('File name: ${file.name}');
        print('File extension: ${file.extension}');
        print('File bytes length: ${file.bytes?.length}');

        if (file.extension == 'csv') {
          // Parse CSV
          String csvString = String.fromCharCodes(file.bytes!);
          print(
              'CSV content preview: ${csvString.substring(0, csvString.length > 200 ? 200 : csvString.length)}');

          List<List<dynamic>> csvTable =
              const CsvToListConverter().convert(csvString);
          print('CSV table length: ${csvTable.length}');

          if (csvTable.isNotEmpty) {
            List<String> headers = csvTable[0]
                .map((e) => e.toString().toLowerCase().trim())
                .toList();
            print('Headers found: $headers');

            for (int i = 1; i < csvTable.length; i++) {
              Map<String, dynamic> row = {};
              for (int j = 0;
                  j < headers.length && j < csvTable[i].length;
                  j++) {
                String value = csvTable[i][j]?.toString().trim() ?? '';
                row[headers[j]] = value;
              }
              print('Row $i: $row');

              // More lenient validation - check if name OR email exists
              String name = row['name']?.toString().trim() ?? '';
              String email = row['email']?.toString().trim() ?? '';

              if (name.isNotEmpty && email.isNotEmpty) {
                data.add(row);
                print('Added row $i to data');
              } else {
                print('Skipped row $i - name: "$name", email: "$email"');
              }
            }
          }
        } else if (file.extension == 'xlsx' || file.extension == 'xls') {
          // Parse Excel
          var excel = Excel.decodeBytes(file.bytes!);
          print('Excel sheets: ${excel.tables.keys.toList()}');

          var table = excel.tables.keys.first;
          var sheet = excel.tables[table]!;
          print('Sheet rows: ${sheet.rows.length}');

          if (sheet.rows.isNotEmpty) {
            List<String> headers = sheet.rows[0]
                .map((cell) =>
                    cell?.value?.toString().toLowerCase().trim() ?? '')
                .toList();
            print('Excel headers: $headers');

            for (int i = 1; i < sheet.rows.length; i++) {
              Map<String, dynamic> row = {};
              for (int j = 0;
                  j < headers.length && j < sheet.rows[i].length;
                  j++) {
                String value = sheet.rows[i][j]?.value?.toString().trim() ?? '';
                row[headers[j]] = value;
              }
              print('Excel row $i: $row');

              String name = row['name']?.toString().trim() ?? '';
              String email = row['email']?.toString().trim() ?? '';

              if (name.isNotEmpty && email.isNotEmpty) {
                data.add(row);
                print('Added Excel row $i to data');
              } else {
                print('Skipped Excel row $i - name: "$name", email: "$email"');
              }
            }
          }
        }

        print('Total parsed data: ${data.length}');

        // Process and validate data
        List<Map<String, dynamic>> processedData = data.map((row) {
          String year = row['year']?.toString().trim() ?? '1st';
          String hostel = _getHostelFromYear(year);

          Map<String, dynamic> processed = {
            'name': row['name']?.toString().trim() ?? '',
            'email': row['email']?.toString().trim() ?? '',
            'phone': row['phone']?.toString().trim() ?? '',
            'room': row['room']?.toString().trim() ?? '',
            'course': row['course']?.toString().trim() ?? 'CSE',
            'year': year,
            'hostel': hostel,
          };

          print('Processed row: $processed');
          return processed;
        }).toList();

        print('Final processed data count: ${processedData.length}');

        setState(() {
          _previewData = processedData;
          _bulkResults = null;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'File parsed successfully! Found ${processedData.length} students.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('Error parsing file: $e');
        print('Error stack trace: ${StackTrace.current}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error parsing file: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  String _getHostelFromYear(String year) {
    switch (year) {
      case '1st':
      case '2nd':
        return 'mvcv_hostel';
      case '3rd':
      case '4th':
        return 'bose_hostel';
      default:
        return 'bose_hostel';
    }
  }

  Future<void> _importStudents() async {
    if (_previewData.isEmpty) return;

    setState(() => _isBulkLoading = true);

    try {
      final client = SupabaseService.client;

      final response = await client.rpc('create_bulk_profiles', params: {
        'students_data': _previewData,
      });

      setState(() {
        _bulkResults = response;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Import completed!\n'
              'Imported: ${response['imported']}\n'
              'Duplicates: ${response['duplicates']}\n'
              'Errors: ${response['errors']}',
            ),
            backgroundColor:
                response['errors'] == 0 ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkLoading = false);
      }
    }
  }

  void _clearImport() {
    setState(() {
      _previewData = [];
      _fileName = null;
      _bulkResults = null;
    });
  }

  Widget _buildSingleRegistrationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _roomController,
                        decoration: const InputDecoration(
                          labelText: 'Room No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _course,
                            isExpanded: true,
                            items: ['CSE', 'ECE', 'ME', 'CE'].map((course) {
                              return DropdownMenuItem(
                                  value: course, child: Text(course));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _course = value!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _year,
                            isExpanded: true,
                            items: ['1st', '2nd', '3rd', '4th'].map((year) {
                              return DropdownMenuItem(
                                  value: year, child: Text(year));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _year = value!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _registerStudent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register Student',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulkImportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Instructions Card
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bulk Import Instructions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload a CSV or Excel file with the following columns:',
                  ),
                  const SizedBox(height: 8),
                  const Text('• name (required)'),
                  const Text('• email (required)'),
                  const Text('• phone (optional)'),
                  const Text('• room (optional)'),
                  const Text('• course (optional, defaults to CSE)'),
                  const Text('• year (optional, defaults to 1st)'),
                  const SizedBox(height: 8),
                  const Text(
                    'Note: Default password will be "password123" for all students.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // File Upload Card
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (_fileName == null) ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: _pickFile,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Click to upload CSV or Excel file',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        const Icon(Icons.file_present, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$_fileName (${_previewData.length} students)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: _clearImport,
                          child: const Text('Remove'),
                        ),
                      ],
                    ),
                    if (_previewData.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Preview (First 5 students):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Room')),
                            DataColumn(label: Text('Course')),
                            DataColumn(label: Text('Year')),
                          ],
                          rows: _previewData.take(5).map((student) {
                            return DataRow(cells: [
                              DataCell(Text(student['name'] ?? '')),
                              DataCell(Text(student['email'] ?? '')),
                              DataCell(Text(student['phone'] ?? '')),
                              DataCell(Text(student['room'] ?? '')),
                              DataCell(Text(student['course'] ?? '')),
                              DataCell(Text(student['year'] ?? '')),
                            ]);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isBulkLoading ? null : _importStudents,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.teal,
                          ),
                          child: _isBulkLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Import ${_previewData.length} Students',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Results Card
          if (_bulkResults != null) ...[
            const SizedBox(height: 16),
            Card(
              color: _bulkResults!['errors'] == 0
                  ? Colors.green[50]
                  : Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import Results',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _bulkResults!['errors'] == 0
                            ? Colors.green[800]
                            : Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('✅ Imported: ${_bulkResults!['imported']}'),
                    Text('⚠️ Duplicates: ${_bulkResults!['duplicates']}'),
                    Text('❌ Errors: ${_bulkResults!['errors']}'),
                    if (_bulkResults!['error_details'] != null &&
                        (_bulkResults!['error_details'] as List)
                            .isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text('Error Details:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(_bulkResults!['error_details'] as List).map((error) =>
                          Text('• ${error['email']}: ${error['error']}')),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
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
                        'Register Students',
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

                // Tab Bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.teal,
                    tabs: const [
                      Tab(text: 'Single Registration'),
                      Tab(text: 'Bulk Import'),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSingleRegistrationTab(),
                      _buildBulkImportTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
