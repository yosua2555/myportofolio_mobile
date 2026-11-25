/// Model data immutable untuk merepresentasikan satu entri riwayat edukasi
/// pada portofolio pengguna.
class EducationEntry {
  /// Membuat instance [EducationEntry] baru.
  const EducationEntry({
    required this.institution,
    required this.degree,
    required this.major,
    required this.startDate,
    required this.isCurrent,
    this.endDate,
    this.gpa,
    this.institutionUrl,
    this.description,
  });

  /// Nama institusi pendidikan (mis. universitas, sekolah, atau bootcamp).
  final String institution;

  /// Jenjang pendidikan (mis. SMA / Sederajat, D3, S1, S2, S3, Bootcamp).
  final String degree;

  /// Nama jurusan atau program studi.
  final String major;

  /// Tanggal mulai menempuh pendidikan.
  final DateTime startDate;

  /// Tanggal selesai studi; bernilai `null` jika [isCurrent] aktif.
  final DateTime? endDate;

  /// Menandakan apakah pengguna masih aktif menempuh pendidikan di sini.
  final bool isCurrent;

  /// Indeks Prestasi Kumulatif (skala 0.00–4.00), bersifat opsional.
  final double? gpa;

  /// Tautan situs institusi atau kredensial digital, bersifat opsional.
  final String? institutionUrl;

  /// Deskripsi singkat pencapaian, organisasi, atau mata kuliah relevan.
  final String? description;

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Memformat [DateTime] menjadi string ringkas (`17 Nov 2026`).
  static String formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
  }

  /// Mengembalikan rentang tanggal mulai hingga selesai (atau `"Saat ini"`).
  String get formattedPeriod {
    final start = formatDate(startDate);
    final end = isCurrent || endDate == null
        ? 'Saat ini'
        : formatDate(endDate!);
    return '$start - $end';
  }

  /// Mengembalikan IPK terformat 2 angka desimal, atau `null` jika kosong.
  String? get formattedGpa => gpa?.toStringAsFixed(2);
}
