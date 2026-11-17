import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/education_entry.dart';
import 'package:myportofolio_mobile/utils/education_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan dan meninjau riwayat edukasi portofolio.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _gpaController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const List<String> _degrees = [
    'SMA / Sederajat',
    'D3',
    'S1',
    'S2',
    'S3',
    'Bootcamp / Non-Gelar',
  ];

  String _degree = 'S1';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  /// Daftar sementara entri edukasi yang berhasil disubmit selama sesi berjalan.
  final List<EducationEntry> _addedEducations = [];

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _gpaController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Membuka dialog pemilih tanggal bawaan Material untuk mulai atau selesai studi.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 10),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = EducationEntry.formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = EducationEntry.formatDate(picked);
      }
    });
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
    );
  }

  /// Mengosongkan seluruh controller, pilihan dropdown, dan tanggal ke nilai awal.
  void _resetForm() {
    _formKey.currentState?.reset();
    _institutionController.clear();
    _majorController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _gpaController.clear();
    _urlController.clear();
    _descriptionController.clear();
    setState(() {
      _degree = 'S1';
      _startDate = null;
      _endDate = null;
      _isCurrent = false;
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(message),
        ),
      );
  }

  /// Memvalidasi formulir, membangun [EducationEntry], dan menampilkan dialog
  /// ringkasan apabila seluruh input lolos validasi.
  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final urlText = _urlController.text.trim();
    final descText = _descriptionController.text.trim();
    final entry = EducationEntry(
      institution: _institutionController.text.trim(),
      degree: _degree,
      major: _majorController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrent ? null : _endDate,
      isCurrent: _isCurrent,
      gpa: EducationValidators.parseGpa(_gpaController.text),
      institutionUrl: urlText.isEmpty ? null : urlText,
      description: descText.isEmpty ? null : descText,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        final primaryColor = Theme.of(dialogContext).colorScheme.primary;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: primaryColor),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Edukasi berhasil ditambahkan!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryRow(label: 'Institusi', value: entry.institution),
                _SummaryRow(label: 'Jenjang', value: entry.degree),
                _SummaryRow(label: 'Jurusan / Prodi', value: entry.major),
                _SummaryRow(
                  label: 'Tanggal Mulai',
                  value: EducationEntry.formatDate(entry.startDate),
                ),
                _SummaryRow(
                  label: 'Tanggal Selesai',
                  value: entry.isCurrent || entry.endDate == null
                      ? 'Saat ini'
                      : EducationEntry.formatDate(entry.endDate!),
                ),
                _SummaryRow(
                  label: 'IPK / Nilai',
                  value: entry.formattedGpa ?? '-',
                ),
                _SummaryRow(
                  label: 'Tautan',
                  value: entry.institutionUrl ?? '-',
                ),
                _SummaryRow(
                  label: 'Deskripsi',
                  value: entry.description ?? '-',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _addedEducations.insert(0, entry);
                });
                _resetForm();
                _showSnackBar(
                  'Edukasi di ${entry.institution} berhasil ditambahkan!',
                );
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tambah Edukasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Informasi Riwayat Pendidikan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lengkapi data institusi, jurusan, dan periode studi.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama Institusi
                    TextFormField(
                      controller: _institutionController,
                      maxLength: 120,
                      textInputAction: TextInputAction.next,
                      decoration: _buildInputDecoration(
                        labelText: 'Nama Institusi *',
                        hintText: 'Contoh: Universitas Indonesia',
                        prefixIcon: Icons.account_balance_outlined,
                      ),
                      validator: (value) =>
                          EducationValidators.validateRequiredText(
                        value,
                        'Nama institusi',
                        maxLength: 120,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Jenjang Pendidikan
                    DropdownButtonFormField<String>(
                      initialValue: _degree,
                      isExpanded: true,
                      decoration: _buildInputDecoration(
                        labelText: 'Jenjang Pendidikan *',
                        hintText: 'Pilih jenjang',
                        prefixIcon: Icons.school_outlined,
                      ),
                      items: _degrees
                          .map(
                            (degree) => DropdownMenuItem(
                              value: degree,
                              child: Text(
                                degree,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _degree = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Jurusan / Program Studi
                    TextFormField(
                      controller: _majorController,
                      maxLength: 100,
                      textInputAction: TextInputAction.next,
                      decoration: _buildInputDecoration(
                        labelText: 'Jurusan / Program Studi *',
                        hintText: 'Contoh: Ilmu Komputer',
                        prefixIcon: Icons.menu_book_outlined,
                      ),
                      validator: (value) =>
                          EducationValidators.validateRequiredText(
                        value,
                        'Jurusan / Program Studi',
                        maxLength: 100,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Masih Berlangsung
                    Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SwitchListTile(
                        title: const Text(
                          'Masih menempuh pendidikan di sini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: _isCurrent,
                        onChanged: (bool value) {
                          setState(() {
                            _isCurrent = value;
                            if (value) {
                              _endDate = null;
                              _endDateController.clear();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Tanggal Mulai
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => _pickDate(isStart: true),
                      decoration: _buildInputDecoration(
                        labelText: 'Tanggal Mulai *',
                        hintText: 'Pilih tanggal mulai studi',
                        prefixIcon: Icons.calendar_today_outlined,
                      ),
                      validator: (_) =>
                          EducationValidators.validateStartDate(_startDate),
                    ),
                    const SizedBox(height: 14),

                    // Tanggal Selesai
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      enabled: !_isCurrent,
                      onTap: _isCurrent ? null : () => _pickDate(isStart: false),
                      decoration: _buildInputDecoration(
                        labelText: _isCurrent
                            ? 'Tanggal Selesai (Saat ini)'
                            : 'Tanggal Selesai *',
                        hintText: _isCurrent
                            ? 'Saat ini'
                            : 'Pilih tanggal selesai studi',
                        prefixIcon: Icons.event_available_outlined,
                      ),
                      validator: (_) => EducationValidators.validateEndDate(
                        isCurrent: _isCurrent,
                        startDate: _startDate,
                        endDate: _endDate,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // IPK / Nilai Akhir (Opsional)
                    TextFormField(
                      controller: _gpaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      decoration: _buildInputDecoration(
                        labelText: 'IPK / Nilai Akhir (Opsional)',
                        hintText: 'Contoh: 3.85 (skala 4.00)',
                        prefixIcon: Icons.grade_outlined,
                      ),
                      validator: EducationValidators.validateGpa,
                    ),
                    const SizedBox(height: 14),

                    // Tautan Institusi / Kredensial (Opsional)
                    TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      decoration: _buildInputDecoration(
                        labelText: 'Tautan Institusi / Kredensial (Opsional)',
                        hintText: 'Contoh: https://ui.ac.id',
                        prefixIcon: Icons.link_outlined,
                      ),
                      validator: EducationValidators.validateOptionalUrl,
                    ),
                    const SizedBox(height: 14),

                    // Deskripsi / Pencapaian (Opsional)
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: _buildInputDecoration(
                        labelText: 'Deskripsi / Pencapaian (Opsional)',
                        hintText:
                            'Tuliskan prestasi, organisasi, atau mata kuliah relevan...',
                        prefixIcon: Icons.notes_outlined,
                      ),
                      validator: (value) =>
                          EducationValidators.validateOptionalMaxLength(
                        value,
                        'Deskripsi',
                        maxLength: 500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Aksi: Reset & Simpan
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.primary,
                                side: BorderSide(color: colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _resetForm();
                                _showSnackBar('Formulir edukasi direset.');
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _submitForm,
                              icon: const Icon(Icons.save_rounded),
                              label: const Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_addedEducations.isNotEmpty) ...[
                const SizedBox(height: 28),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  'Edukasi Ditambahkan (${_addedEducations.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(_addedEducations.length, (index) {
                  final item = _addedEducations[index];
                  return _EducationSessionCard(
                    entry: item,
                    primaryColor: colorScheme.primary,
                    onDelete: () {
                      setState(() {
                        _addedEducations.removeAt(index);
                      });
                      _showSnackBar(
                        'Entri ${item.institution} dihapus dari daftar sesi.',
                      );
                    },
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 13.5),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _EducationSessionCard extends StatelessWidget {
  final EducationEntry entry;
  final Color primaryColor;
  final VoidCallback onDelete;

  const _EducationSessionCard({
    required this.entry,
    required this.primaryColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.school_rounded, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.institution,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.degree} · ${entry.major}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.formattedPeriod,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  if (entry.formattedGpa != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'IPK: ${entry.formattedGpa}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Hapus entri',
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
