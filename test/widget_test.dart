import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

void main() {
  testWidgets('Smoke test verify MyPortfolio elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsWidgets);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Tambah Edukasi'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Navigate to EducationFormPage from card and pop back', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Edukasi'));
    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationFormPage), findsOneWidget);
    expect(find.text('Tambah Edukasi'), findsOneWidget);

    // Simulasi tombol kembali perangkat / pop route
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Navigate via LeftDrawer between Home and Add Education', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Buka drawer dari halaman utama
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationFormPage), findsOneWidget);

    // Buka drawer dari EducationFormPage dan kembali ke Home
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('EducationFormPage validation and summary dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const EducationFormPage(),
      ),
    );

    // 1. Submit kosong -> validasi gagal, dialog tidak muncul
    final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Jurusan / Program Studi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai wajib dipilih!'), findsOneWidget);
    expect(find.text('Tanggal selesai wajib dipilih!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    // 2. Uji input invalid (hanya spasi, IPK > 4.0, URL salah)
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Institusi *'),
      '   ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'IPK / Nilai Akhir (Opsional)'),
      '4.50',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tautan Institusi / Kredensial (Opsional)'),
      'bukan-url',
    );
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('IPK harus berada di antara 0.00 hingga 4.00!'), findsOneWidget);
    expect(find.text('Format URL tidak valid (contoh: https://ui.ac.id)!'), findsOneWidget);

    // 3. Lengkapi semua input dengan data valid
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Institusi *'),
      'Universitas Indonesia',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Jurusan / Program Studi *'),
      'Ilmu Komputer',
    );

    // Aktifkan switch "Masih menempuh pendidikan di sini"
    final switchTile = find.byType(SwitchListTile);
    await tester.ensureVisible(switchTile);
    await tester.tap(switchTile);
    await tester.pumpAndSettle();

    // Pilih Tanggal Mulai via showDatePicker
    final startDateField = find.widgetWithText(TextFormField, 'Tanggal Mulai *');
    await tester.ensureVisible(startDateField);
    await tester.tap(startDateField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'IPK / Nilai Akhir (Opsional)'),
      '3.90',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tautan Institusi / Kredensial (Opsional)'),
      'https://cs.ui.ac.id',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Deskripsi / Pencapaian (Opsional)'),
      'Asisten Dosen Pemrograman',
    );

    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Dialog ringkasan muncul dengan semua data
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
    expect(find.textContaining('Universitas Indonesia'), findsWidgets);
    expect(find.textContaining('Ilmu Komputer'), findsWidgets);
    expect(find.textContaining('3.90'), findsWidgets);
    expect(find.textContaining('https://cs.ui.ac.id'), findsWidgets);
    expect(find.textContaining('Asisten Dosen Pemrograman'), findsWidgets);

    // Tutup dialog -> entri ditambahkan ke daftar sesi ini
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Edukasi Ditambahkan (1)'), findsOneWidget);
    expect(find.text('S1 · Ilmu Komputer'), findsOneWidget);

    // Hapus entri dari daftar sesi ini
    final deleteButton = find.byTooltip('Hapus entri');
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Edukasi Ditambahkan (1)'), findsNothing);
    expect(find.text('S1 · Ilmu Komputer'), findsNothing);
  });

  testWidgets('Reset button clears entered input and validation errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const EducationFormPage(),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Institusi *'),
      'ITB',
    );
    final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Jurusan / Program Studi tidak boleh kosong!'), findsOneWidget);

    final resetButton = find.widgetWithText(OutlinedButton, 'Reset');
    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(find.text('Jurusan / Program Studi tidak boleh kosong!'), findsNothing);
    expect(find.text('ITB'), findsNothing);
  });

  testWidgets('EducationFormPage remains usable on narrow mobile screen (360x640)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const EducationFormPage(),
      ),
    );

    final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
  });
}
