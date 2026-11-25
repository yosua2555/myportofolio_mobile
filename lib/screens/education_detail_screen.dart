import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Halaman detail untuk menampilkan seluruh atribut sebuah entri [Education],
/// lengkap dengan aksi terautentikasi untuk Star, Edit (`PATCH`),
/// dan Hapus (`DELETE`).
class EducationDetailScreen extends StatefulWidget {
  const EducationDetailScreen({required this.education, super.key});

  final Education education;

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  late Education _education;
  bool _hasChanged = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _education = widget.education;
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

  Future<void> _handleApiException(ApiException e, String actionLabel) async {
    if (e.statusCode == 401) {
      await context.read<AuthState>().logout();
      if (!mounted) return;
      _showSnackBar('Sesi login berakhir. Silakan login kembali.');
      await ensureLoggedIn(context);
    } else if (e.statusCode == 403) {
      _showSnackBar(
        'Akses ditolak (HTTP 403). '
        'Anda tidak memiliki izin untuk $actionLabel.',
      );
    } else {
      _showSnackBar('Gagal $actionLabel (HTTP ${e.statusCode}).');
    }
  }

  Future<void> _toggleStar() async {
    final id = _education.id;
    if (id == null) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isBusy = true);
    try {
      final updated = await context.read<ApiClient>().toggleEducationStar(
        id,
        token: token,
      );
      if (!mounted) return;
      setState(() {
        _education = updated;
        _hasChanged = true;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      await _handleApiException(e, 'mengubah status star');
    } on Object catch (_) {
      if (!mounted) return;
      _showSnackBar('Gagal terhubung ke server. Coba lagi.');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _editEducation() async {
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final updated = await Navigator.push<Education>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EducationFormPage(initialEducation: _education, popOnSuccess: true),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _education = updated;
        _hasChanged = true;
      });
    }
  }

  Future<void> _deleteEducation() async {
    final id = _education.id;
    if (id == null) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Edukasi?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus riwayat edukasi di '
          '${_education.institution}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isBusy = true);
    try {
      await context.read<ApiClient>().deleteEducation(id, token: token);
      if (!mounted) return;
      setState(() => _isBusy = false);
      _showSnackBar('Edukasi berhasil dihapus.');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isBusy = false);
      await _handleApiException(e, 'menghapus edukasi');
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _isBusy = false);
      _showSnackBar('Gagal terhubung ke server. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.pop(context, _hasChanged);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _education.institution,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Edit Edukasi',
              onPressed: _isBusy ? null : _editEducation,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Hapus Edukasi',
              onPressed: _isBusy ? null : _deleteEducation,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _education.institution,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _education.degree,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _DetailLabel('Periode Studi'),
                    const SizedBox(height: 4),
                    Text(
                      _education.formattedPeriod,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailLabel('Tahun Mulai'),
                    const SizedBox(height: 4),
                    Text(
                      '${_education.startedYear}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailLabel('Tahun Selesai'),
                    const SizedBox(height: 4),
                    Text(
                      _education.endedYear == null
                          ? 'Saat ini (Masih berlangsung)'
                          : '${_education.endedYear}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailLabel('Deskripsi / Pencapaian'),
                    const SizedBox(height: 4),
                    Text(
                      _education.description.isEmpty
                          ? '-'
                          : _education.description,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailLabel('Stars'),
                    const SizedBox(height: 4),
                    Text(
                      _education.starredByNames.isEmpty
                          ? '${_education.starCount} stars'
                          : '${_education.starCount} stars '
                                '(${_education.starredByNames})',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isBusy ? null : _toggleStar,
                        icon: Icon(
                          _education.isStarred
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.amber[700],
                        ),
                        label: Text(
                          _education.isStarred
                              ? 'Batalkan Star (${_education.starCount})'
                              : 'Beri Star (${_education.starCount})',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailLabel extends StatelessWidget {
  const _DetailLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
      ),
    );
  }
}
