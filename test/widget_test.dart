import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

ApiClient _createMockApiClient({
  List<Map<String, dynamic>>? projects,
  List<Map<String, dynamic>>? educations,
  bool rejectEducationPostWith401 = false,
}) {
  final projectItems =
      projects ??
      [
        {
          'id': 'uuid-1',
          'name': 'Portfolio Backend',
          'description':
              'Django REST Framework backend for personal portfolio.',
          'date': 2026,
          'star_count': 4,
          'is_starred': false,
          'starred_by_names': 'burhan',
        },
      ];

  final educationItems =
      educations ??
      [
        {
          'id': 'edu-1',
          'institution': 'Universitas Indonesia',
          'degree': 'S1 Ilmu Komputer',
          'description': 'Fasilkom UI',
          'started_year': 2025,
          'ended_year': null,
          'star_count': 2,
          'is_starred': false,
          'starred_by_names': 'owner',
        },
      ];

  final mockClient = MockClient((request) async {
    if (request.method == 'GET' && request.url.path == '/api/v1/projects/') {
      return http.Response(jsonEncode(projectItems), 200);
    }
    if (request.method == 'POST' && request.url.path == '/api/v1/projects/') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({'id': 'uuid-created', ...body}), 201);
    }
    if (request.method == 'GET' && request.url.path == '/api/v1/education/') {
      return http.Response(jsonEncode(educationItems), 200);
    }
    if (request.method == 'POST' && request.url.path == '/api/v1/education/') {
      if (rejectEducationPostWith401) {
        return http.Response('{"detail": "Invalid token."}', 401);
      }
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final created = {
        'id': 'edu-created',
        'star_count': 0,
        'is_starred': false,
        'starred_by_names': '',
        ...body,
      };
      educationItems.add(created);
      return http.Response(jsonEncode(created), 201);
    }
    if (request.method == 'PATCH' &&
        request.url.path.startsWith('/api/v1/education/')) {
      final id = request.url.pathSegments[request.url.pathSegments.length - 2];
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final index = educationItems.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        educationItems[index] = {...educationItems[index], ...body};
        return http.Response(jsonEncode(educationItems[index]), 200);
      }
      return http.Response('Not Found', 404);
    }
    if (request.method == 'POST' &&
        request.url.path.endsWith('/star/') &&
        request.url.path.startsWith('/api/v1/education/')) {
      final id = request.url.pathSegments[request.url.pathSegments.length - 3];
      final index = educationItems.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        final current = educationItems[index];
        final wasStarred = current['is_starred'] as bool;
        final nextCount =
            (current['star_count'] as int) + (wasStarred ? -1 : 1);
        educationItems[index] = {
          ...current,
          'is_starred': !wasStarred,
          'star_count': nextCount,
        };
        return http.Response(jsonEncode(educationItems[index]), 200);
      }
      return http.Response('Not Found', 404);
    }
    if (request.method == 'DELETE' &&
        request.url.path.startsWith('/api/v1/education/')) {
      final id = request.url.pathSegments[request.url.pathSegments.length - 2];
      educationItems.removeWhere((e) => e['id'] == id);
      return http.Response('', 204);
    }
    if (request.method == 'POST' && request.url.path == '/api/v1/auth/token/') {
      return http.Response(jsonEncode({'token': 'test-token-123'}), 200);
    }
    if (request.method == 'POST' &&
        request.url.path == '/api/v1/auth/logout/') {
      return http.Response('', 204);
    }
    return http.Response('Not Found', 404);
  });

  return ApiClient(client: mockClient, baseUrl: 'http://test');
}

Widget _wrapWithProviders(
  Widget home, {
  ApiClient? apiClient,
  String? initialToken,
}) {
  final client = apiClient ?? _createMockApiClient();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: client),
      ChangeNotifierProvider<AuthState>(
        create: (_) => AuthState(client, initialToken: initialToken),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: home,
    ),
  );
}

void main() {
  testWidgets('Smoke test verify MyPortfolio elements', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

    expect(find.text('MyPortfolio'), findsWidgets);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Lihat Edukasi'), findsOneWidget);
    expect(find.text('Tambah Edukasi'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('View public projects and navigate to detail without login', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

    await tester.ensureVisible(find.text('Lihat Proyek'));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.text('Portfolio Backend'), findsOneWidget);
    expect(find.text('Year: 2026  ·  Stars: 4'), findsOneWidget);

    await tester.tap(find.text('Portfolio Backend'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('4 stars (burhan)'), findsOneWidget);
  });

  testWidgets(
    'View public educations and open EducationDetailScreen without login',
    (tester) async {
      await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

      await tester.ensureVisible(find.text('Lihat Edukasi'));
      await tester.tap(find.text('Lihat Edukasi'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationListScreen), findsOneWidget);
      expect(find.text('Universitas Indonesia'), findsOneWidget);
      expect(find.text('S1 Ilmu Komputer  ·  2025 - Saat ini'), findsOneWidget);

      await tester.tap(find.text('Universitas Indonesia'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationDetailScreen), findsOneWidget);
      expect(find.text('2025 - Saat ini'), findsOneWidget);
      expect(find.text('Fasilkom UI'), findsOneWidget);
    },
  );

  testWidgets(
    'Unauthenticated Tambah Proyek redirects to LoginScreen then form',
    (tester) async {
      await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

      await tester.ensureVisible(find.text('Tambah Proyek'));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormPage), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Proyek'),
        'Mobile App',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tahun Proyek'),
        '2026',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi Proyek'),
        'Flutter client app',
      );

      // Tunggu SnackBar navigasi menghilang sebelum menekan tombol Save
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
      expect(find.text('Name: Mobile App'), findsOneWidget);
      expect(find.text('Year: 2026'), findsOneWidget);
    },
  );

  testWidgets(
    'Unauthenticated Tambah Edukasi logs in, submits POST, and opens list',
    (tester) async {
      await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

      await tester.ensureVisible(find.text('Tambah Edukasi'));
      await tester.tap(find.text('Tambah Edukasi'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'admin',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationFormPage), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Institusi *'),
        'SMA Negeri 1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Jenjang / Gelar *'),
        'MIPA',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tahun Mulai *'),
        '2021',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tahun Selesai *'),
        '2024',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi / Pencapaian *'),
        'Juara Olimpiade',
      );

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
      expect(find.textContaining('SMA Negeri 1'), findsWidgets);

      await tester.tap(find.text('Lihat Daftar'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationListScreen), findsOneWidget);
      expect(find.text('SMA Negeri 1'), findsOneWidget);
    },
  );

  testWidgets(
    '401 on EducationFormPage clears AuthState and prompts LoginScreen',
    (tester) async {
      final apiClient = _createMockApiClient(rejectEducationPostWith401: true);
      await tester.pumpWidget(
        _wrapWithProviders(
          const EducationFormPage(),
          apiClient: apiClient,
          initialToken: 'expired-token',
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Institusi *'),
        'UI',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Jenjang / Gelar *'),
        'S1',
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tahun Mulai *'),
        '2025',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi / Pencapaian *'),
        'Aktif',
      );

      final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets('Navigate via LeftDrawer between Home and Education', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: _createMockApiClient()));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationListScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('EducationFormPage validation and reset button work cleanly', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithProviders(
        const EducationFormPage(),
        initialToken: 'valid-token',
      ),
    );

    final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Jenjang / Gelar tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tahun mulai tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tahun selesai tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tahun Mulai *'),
      '2025',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tahun Selesai *'),
      '2023',
    );
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Tahun selesai tidak boleh sebelum tahun mulai!'),
      findsOneWidget,
    );

    final resetButton = find.widgetWithText(OutlinedButton, 'Reset');
    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama institusi tidak boleh kosong!'), findsNothing);
    expect(find.text('2025'), findsNothing);
  });

  testWidgets(
    'EducationFormPage remains usable on narrow mobile screen (360x640)',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapWithProviders(
          const EducationFormPage(),
          initialToken: 'valid-token',
        ),
      );

      final saveButton = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    },
  );

  testWidgets('EducationListScreen handles empty state and error retry', (
    tester,
  ) async {
    var shouldFail = true;
    final mockClient = MockClient((request) async {
      if (shouldFail) {
        return http.Response('Server Error', 500);
      }
      return http.Response(jsonEncode(<Map<String, dynamic>>[]), 200);
    });
    final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');

    await tester.pumpWidget(
      _wrapWithProviders(const EducationListScreen(), apiClient: apiClient),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load educations'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    shouldFail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('No educations found.'), findsOneWidget);
  });

  testWidgets(
    'EducationDetailScreen supports authenticated Star, Edit PATCH, and Delete',
    (tester) async {
      final apiClient = _createMockApiClient();
      await tester.pumpWidget(
        _wrapWithProviders(
          const EducationListScreen(),
          apiClient: apiClient,
          initialToken: 'valid-token',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Universitas Indonesia'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationDetailScreen), findsOneWidget);

      // 1. Toggle Star
      await tester.tap(find.text('Beri Star (2)'));
      await tester.pumpAndSettle();
      expect(find.text('Batalkan Star (3)'), findsOneWidget);

      // 2. Edit (PATCH)
      await tester.tap(find.byTooltip('Edit Edukasi'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Jenjang / Gelar *'),
        'S1 Sistem Informasi',
      );
      final updateButton = find.widgetWithText(ElevatedButton, 'Perbarui');
      await tester.ensureVisible(updateButton);
      await tester.tap(updateButton);
      await tester.pumpAndSettle();

      expect(find.text('Edukasi berhasil diperbarui!'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationDetailScreen), findsOneWidget);
      expect(find.text('S1 Sistem Informasi'), findsOneWidget);

      // 3. Delete (DELETE)
      await tester.tap(find.byTooltip('Hapus Edukasi'));
      await tester.pumpAndSettle();
      expect(find.text('Hapus Edukasi?'), findsOneWidget);

      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      expect(find.byType(EducationListScreen), findsOneWidget);
      expect(find.text('No educations found.'), findsOneWidget);
    },
  );
}
