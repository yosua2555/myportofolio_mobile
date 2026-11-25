import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/education_validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Halaman formulir terautentikasi untuk menambah (`POST`) atau memperbarui
/// (`PATCH`) entri [Education] pada backend Django REST Framework.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({
    this.initialEducation,
    this.popOnSuccess = false,
    super.key,
  });

  /// Jika diberikan, formulir berjalan pada mode edit (`PATCH`).
  final Education? initialEducation;

  /// Jika `true`, halaman akan kembali ke layar pemanggil membawa objek hasil
  /// setelah penyimpanan berhasil agar daftar langsung tersinkronisasi.
  final bool popOnSuccess;

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _institutionController;
  late final TextEditingController _degreeController;
  late final TextEditingController _startedYearController;
  late final TextEditingController _endedYearController;
  late final TextEditingController _descriptionController;

  late bool _isCurrent;
  bool _isSubmitting = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isEditMode => widget.initialEducation?.id != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialEducation;
    _institutionController = TextEditingController(
      text: initial?.institution ?? '',
    );
    _degreeController = TextEditingController(text: initial?.degree ?? '');
    _startedYearController = TextEditingController(
      text: initial != null ? '${initial.startedYear}' : '',
    );
    _endedYearController = TextEditingController(
      text: initial?.endedYear != null ? '${initial!.endedYear}' : '',
    );
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _isCurrent = initial != null && initial.isCurrent;
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _startedYearController.dispose();
    _endedYearController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _institutionController.clear();
    _degreeController.clear();
    _startedYearController.clear();
    _endedYearController.clear();
    _descriptionController.clear();
    setState(() {
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

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final payload = Education(
      institution: _institutionController.text.trim(),
      degree: _degreeController.text.trim(),
      description: _descriptionController.text.trim(),
      startedYear: int.parse(_startedYearController.text.trim()),
      endedYear: _isCurrent
          ? null
          : int.parse(_endedYearController.text.trim()),
    );

    try {
      final apiClient = context.read<ApiClient>();
      final saved = _isEditMode
          ? await apiClient.updateEducation(
              widget.initialEducation!.id!,
              payload,
              token: token,
            )
          : await apiClient.createEducation(payload, token: token);

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      final shouldOpenList = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final primaryColor = Theme.of(dialogContext).colorScheme.primary;
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isEditMode
                        ? 'Edukasi berhasil diperbarui!'
                        : 'Edukasi berhasil ditambahkan!',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SummaryRow(label: 'Institusi', value: saved.institution),
                  _SummaryRow(label: 'Jenjang / Gelar', value: saved.degree),
                  _SummaryRow(
                    label: 'Tahun Mulai',
                    value: '${saved.startedYear}',
                  ),
                  _SummaryRow(
                    label: 'Tahun Selesai',
                    value: saved.endedYear == null
                        ? 'Saat ini'
                        : '${saved.endedYear}',
                  ),
                  _SummaryRow(
                    label: 'Deskripsi',
                    value: saved.description.isEmpty ? '-' : saved.description,
                  ),
                ],
              ),
            ),
            actions: [
              if (!widget.popOnSuccess)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Lihat Daftar'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;
      if (widget.popOnSuccess) {
        Navigator.pop(context, saved);
        return;
      }
      if (shouldOpenList == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const EducationListScreen(),
          ),
        );
        return;
      }
      _resetForm();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        _showSnackBar('Sesi login berakhir. Silakan login kembali.');
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        _showSnackBar(
          'Akses ditolak (HTTP 403). Anda tidak memiliki izin untuk aksi ini.',
        );
      } else {
        _showSnackBar('Gagal menyimpan edukasi (HTTP ${e.statusCode}).');
      }
    } on Object catch (_) {
      if (!mounted) return;
      _showSnackBar('Gagal terhubung ke server. Coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
        title: Text(
          _isEditMode ? 'Edit Edukasi' : 'Tambah Edukasi',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: _isEditMode ? null : const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditMode
                      ? 'Perbarui Riwayat Pendidikan'
                      : 'Informasi Riwayat Pendidikan',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Data akan disinkronkan langsung dengan backend DRF (/api/v1/education/).',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),

                // Nama Institusi
                TextFormField(
                  controller: _institutionController,
                  maxLength: 255,
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
                      ),
                ),
                const SizedBox(height: 12),

                // Jenjang / Gelar (degree)
                TextFormField(
                  controller: _degreeController,
                  maxLength: 255,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    labelText: 'Jenjang / Gelar *',
                    hintText: 'Contoh: S1 Ilmu Komputer',
                    prefixIcon: Icons.school_outlined,
                  ),
                  validator: (value) =>
                      EducationValidators.validateRequiredText(
                        value,
                        'Jenjang / Gelar',
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
                    onChanged: (value) {
                      setState(() {
                        _isCurrent = value;
                        if (value) {
                          _endedYearController.clear();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),

                // Tahun Mulai (started_year)
                TextFormField(
                  controller: _startedYearController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    labelText: 'Tahun Mulai *',
                    hintText: 'Contoh: 2025',
                    prefixIcon: Icons.calendar_today_outlined,
                  ),
                  validator: EducationValidators.validateStartedYear,
                ),
                const SizedBox(height: 14),

                // Tahun Selesai (ended_year)
                TextFormField(
                  controller: _endedYearController,
                  enabled: !_isCurrent,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(
                    labelText: _isCurrent
                        ? 'Tahun Selesai (Saat ini)'
                        : 'Tahun Selesai *',
                    hintText: _isCurrent ? 'Saat ini' : 'Contoh: 2029',
                    prefixIcon: Icons.event_available_outlined,
                  ),
                  validator: (value) => EducationValidators.validateEndedYear(
                    isCurrent: _isCurrent,
                    startedYearText: _startedYearController.text,
                    endedYearText: value,
                  ),
                ),
                const SizedBox(height: 14),

                // Deskripsi / Pencapaian (description)
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 1000,
                  decoration: _buildInputDecoration(
                    labelText: 'Deskripsi / Pencapaian *',
                    hintText:
                        'Tuliskan prestasi, organisasi, atau mata kuliah '
                        'relevan...',
                    prefixIcon: Icons.notes_outlined,
                  ),
                  validator: (value) =>
                      EducationValidators.validateRequiredText(
                        value,
                        'Deskripsi',
                        maxLength: 1000,
                      ),
                ),
                const SizedBox(height: 20),

                // Tombol Aksi: Reset & Simpan
                Row(
                  children: [
                    if (!_isEditMode) ...[
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
                            onPressed: _isSubmitting
                                ? null
                                : () {
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
                    ],
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
                          onPressed: _isSubmitting ? null : _submitForm,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_rounded),
                          label: Text(
                            _isEditMode ? 'Perbarui' : 'Simpan',
                            style: const TextStyle(
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
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
