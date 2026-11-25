/// Kumpulan fungsi validasi murni (*pure functions*) untuk formulir edukasi.
///
/// Dipisahkan dari lapisan UI agar aturan validasi dapat digunakan ulang
/// dan diuji secara terisolasi melalui unit test.
abstract final class EducationValidators {
  /// Memvalidasi field teks wajib agar tidak `null`, tidak kosong/spasi saja,
  /// dan tidak melebihi [maxLength] karakter setelah di-trim.
  static String? validateRequiredText(
    String? value,
    String fieldName, {
    int maxLength = 255,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    if (trimmed.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter!';
    }
    return null;
  }

  /// Memvalidasi field teks opsional terhadap batas [maxLength] karakter.
  static String? validateOptionalMaxLength(
    String? value,
    String fieldName, {
    int maxLength = 1000,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter!';
    }
    return null;
  }

  /// Memvalidasi tahun mulai (`started_year`) agar berupa bilangan bulat valid
  /// pada rentang `1950–2100`.
  static String? validateStartedYear(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Tahun mulai tidak boleh kosong!';
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 1950 || parsed > 2100) {
      return 'Masukkan tahun mulai yang valid (1950–2100)!';
    }
    return null;
  }

  /// Memvalidasi tahun selesai (`ended_year`) saat [isCurrent] `false`,
  /// serta memastikan tahun selesai tidak mendahului [startedYearText].
  static String? validateEndedYear({
    required bool isCurrent,
    required String? startedYearText,
    required String? endedYearText,
  }) {
    if (isCurrent) return null;

    final trimmed = endedYearText?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Tahun selesai tidak boleh kosong!';
    }
    final endYear = int.tryParse(trimmed);
    if (endYear == null || endYear < 1950 || endYear > 2100) {
      return 'Masukkan tahun selesai yang valid (1950–2100)!';
    }

    final startYear = int.tryParse(startedYearText?.trim() ?? '');
    if (startYear != null && endYear < startYear) {
      return 'Tahun selesai tidak boleh sebelum tahun mulai!';
    }
    return null;
  }

  /// Mengonversi teks IPK (mendukung pemisah desimal `.` maupun `,`) menjadi
  /// `double?`. Mengembalikan `null` jika input kosong atau tidak valid.
  static double? parseGpa(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  /// Memvalidasi IPK opsional pada rentang `0.00–4.00`.
  static String? validateGpa(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;

    final parsed = parseGpa(trimmed);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return 'Masukkan angka IPK yang valid (contoh: 3.85)!';
    }
    if (parsed < 0.0 || parsed > 4.0) {
      return 'IPK harus berada di antara 0.00 hingga 4.00!';
    }
    return null;
  }

  /// Memvalidasi URL opsional agar memiliki skema `http`/`https` dan host valid.
  static String? validateOptionalUrl(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    final isValidHttp =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty &&
        uri.host.contains('.');
    if (!isValidHttp) {
      return 'Format URL tidak valid (contoh: https://ui.ac.id)!';
    }
    return null;
  }

  /// Memastikan tanggal mulai telah dipilih.
  static String? validateStartDate(DateTime? startDate) {
    if (startDate == null) {
      return 'Tanggal mulai wajib dipilih!';
    }
    return null;
  }

  /// Memvalidasi tanggal selesai apabila [isCurrent] bernilai `false`,
  /// serta memastikan tanggal selesai tidak mendahului [startDate].
  static String? validateEndDate({
    required bool isCurrent,
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    if (isCurrent) return null;
    if (endDate == null) {
      return 'Tanggal selesai wajib dipilih!';
    }
    if (startDate != null && endDate.isBefore(startDate)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }
}
