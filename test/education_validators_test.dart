import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education_entry.dart';
import 'package:myportofolio_mobile/utils/education_validators.dart';

void main() {
  group('EducationValidators', () {
    test(
      'validateRequiredText rejects null, empty, spaces, and oversized text',
      () {
        expect(
          EducationValidators.validateRequiredText(null, 'Institusi'),
          'Institusi tidak boleh kosong!',
        );
        expect(
          EducationValidators.validateRequiredText('', 'Institusi'),
          'Institusi tidak boleh kosong!',
        );
        expect(
          EducationValidators.validateRequiredText('   \t\n ', 'Institusi'),
          'Institusi tidak boleh kosong!',
        );
        expect(
          EducationValidators.validateRequiredText(
            'abcde',
            'Institusi',
            maxLength: 4,
          ),
          'Institusi maksimal 4 karakter!',
        );
        expect(
          EducationValidators.validateRequiredText(
            'Universitas Indonesia',
            'Institusi',
          ),
          isNull,
        );
      },
    );

    test(
      'validateGpa accepts dot/comma in 0.00-4.00 and rejects invalid values',
      () {
        expect(EducationValidators.validateGpa(null), isNull);
        expect(EducationValidators.validateGpa('  '), isNull);
        expect(EducationValidators.validateGpa('0.00'), isNull);
        expect(EducationValidators.validateGpa('3.85'), isNull);
        expect(EducationValidators.validateGpa('3,92'), isNull);
        expect(EducationValidators.validateGpa('4.0'), isNull);

        expect(
          EducationValidators.validateGpa('abc'),
          'Masukkan angka IPK yang valid (contoh: 3.85)!',
        );
        expect(
          EducationValidators.validateGpa('-0.1'),
          'IPK harus berada di antara 0.00 hingga 4.00!',
        );
        expect(
          EducationValidators.validateGpa('4.01'),
          'IPK harus berada di antara 0.00 hingga 4.00!',
        );
      },
    );

    test(
      'validateOptionalUrl validates http/https URLs with host and rejects invalid formats',
      () {
        expect(EducationValidators.validateOptionalUrl(null), isNull);
        expect(EducationValidators.validateOptionalUrl(''), isNull);
        expect(
          EducationValidators.validateOptionalUrl('https://ui.ac.id'),
          isNull,
        );
        expect(
          EducationValidators.validateOptionalUrl('http://cs.ui.ac.id/path'),
          isNull,
        );

        expect(
          EducationValidators.validateOptionalUrl('ui.ac.id'),
          'Format URL tidak valid (contoh: https://ui.ac.id)!',
        );
        expect(
          EducationValidators.validateOptionalUrl('ftp://ui.ac.id'),
          'Format URL tidak valid (contoh: https://ui.ac.id)!',
        );
        expect(
          EducationValidators.validateOptionalUrl('https://localhost'),
          'Format URL tidak valid (contoh: https://ui.ac.id)!',
        );
      },
    );

    test('validateEndDate enforces presence and order when not current', () {
      final start = DateTime(2023, 8);
      final beforeStart = DateTime(2023, 7, 31);
      final afterStart = DateTime(2027, 6, 15);

      expect(
        EducationValidators.validateEndDate(
          isCurrent: true,
          startDate: start,
          endDate: null,
        ),
        isNull,
      );
      expect(
        EducationValidators.validateEndDate(
          isCurrent: false,
          startDate: start,
          endDate: null,
        ),
        'Tanggal selesai wajib dipilih!',
      );
      expect(
        EducationValidators.validateEndDate(
          isCurrent: false,
          startDate: start,
          endDate: beforeStart,
        ),
        'Tanggal selesai tidak boleh sebelum tanggal mulai!',
      );
      expect(
        EducationValidators.validateEndDate(
          isCurrent: false,
          startDate: start,
          endDate: afterStart,
        ),
        isNull,
      );
    });

    test('validateStartedYear and validateEndedYear enforce valid ranges', () {
      expect(
        EducationValidators.validateStartedYear(''),
        'Tahun mulai tidak boleh kosong!',
      );
      expect(
        EducationValidators.validateStartedYear('abc'),
        'Masukkan tahun mulai yang valid (1950–2100)!',
      );
      expect(EducationValidators.validateStartedYear('2025'), isNull);

      expect(
        EducationValidators.validateEndedYear(
          isCurrent: true,
          startedYearText: '2025',
          endedYearText: '',
        ),
        isNull,
      );
      expect(
        EducationValidators.validateEndedYear(
          isCurrent: false,
          startedYearText: '2025',
          endedYearText: '',
        ),
        'Tahun selesai tidak boleh kosong!',
      );
      expect(
        EducationValidators.validateEndedYear(
          isCurrent: false,
          startedYearText: '2025',
          endedYearText: '2023',
        ),
        'Tahun selesai tidak boleh sebelum tahun mulai!',
      );
      expect(
        EducationValidators.validateEndedYear(
          isCurrent: false,
          startedYearText: '2025',
          endedYearText: '2029',
        ),
        isNull,
      );
    });
  });

  group('EducationEntry', () {
    test('formats date, period, and GPA cleanly', () {
      final entry = EducationEntry(
        institution: 'Universitas Indonesia',
        degree: 'S1',
        major: 'Ilmu Komputer',
        startDate: DateTime(2024, 9, 2),
        isCurrent: true,
        gpa: 3.9,
      );

      expect(EducationEntry.formatDate(DateTime(2024, 9, 2)), '2 Sep 2024');
      expect(entry.formattedPeriod, '2 Sep 2024 - Saat ini');
      expect(entry.formattedGpa, '3.90');
    });
  });
}
