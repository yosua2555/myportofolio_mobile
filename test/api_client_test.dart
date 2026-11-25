import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  group('Project JSON serialization', () {
    test('deserializes snake_case JSON and defaults optional fields', () {
      final project = Project.fromJson({
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'MyPortfolio',
        'description': 'Personal portfolio app',
        'date': 2026,
        'star_count': 3,
        'is_starred': true,
        'starred_by_names': 'alice, bob',
      });

      expect(project.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(project.name, 'MyPortfolio');
      expect(project.description, 'Personal portfolio app');
      expect(project.date, 2026);
      expect(project.starCount, 3);
      expect(project.isStarred, isTrue);
      expect(project.starredByNames, 'alice, bob');
      expect(project.projectImageUrl, '');
    });

    test('serializes only writable fields and excludes read-only fields', () {
      const project = Project(
        id: 'should-not-be-sent',
        name: 'MyPortfolio',
        description: 'Personal portfolio app',
        date: 2026,
        starCount: 5,
        isStarred: true,
        starredByNames: 'alice',
      );

      final json = project.toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('star_count'), isFalse);
      expect(json.containsKey('is_starred'), isFalse);
      expect(json.containsKey('starred_by_names'), isFalse);
      expect(json['name'], 'MyPortfolio');
      expect(json['description'], 'Personal portfolio app');
      expect(json['date'], 2026);
    });
  });

  group('Education JSON serialization', () {
    test('deserializes snake_case JSON including nullable ended_year', () {
      final ongoing = Education.fromJson({
        'id': 'edu-uuid-1',
        'institution': 'Universitas Indonesia',
        'degree': 'S1 Sistem Informasi',
        'description': 'Fasilkom UI',
        'started_year': 2025,
        'ended_year': null,
        'star_count': 2,
        'is_starred': true,
        'starred_by_names': 'yosua',
      });

      expect(ongoing.id, 'edu-uuid-1');
      expect(ongoing.institution, 'Universitas Indonesia');
      expect(ongoing.degree, 'S1 Sistem Informasi');
      expect(ongoing.startedYear, 2025);
      expect(ongoing.endedYear, isNull);
      expect(ongoing.isCurrent, isTrue);
      expect(ongoing.formattedPeriod, '2025 - Saat ini');
      expect(ongoing.starCount, 2);
      expect(ongoing.isStarred, isTrue);
      expect(ongoing.starredByNames, 'yosua');
    });

    test(
      'serializes to snake_case JSON and excludes server-managed fields',
      () {
        const edu = Education(
          id: 'server-id',
          institution: 'SMA Negeri 1',
          degree: 'MIPA',
          description: 'Jurusan IPA',
          startedYear: 2021,
          endedYear: 2024,
          starCount: 10,
          isStarred: true,
          starredByNames: 'admin',
        );

        final json = edu.toJson();
        expect(json.containsKey('id'), isFalse);
        expect(json.containsKey('star_count'), isFalse);
        expect(json.containsKey('is_starred'), isFalse);
        expect(json.containsKey('starred_by_names'), isFalse);
        expect(json['institution'], 'SMA Negeri 1');
        expect(json['degree'], 'MIPA');
        expect(json['description'], 'Jurusan IPA');
        expect(json['started_year'], 2021);
        expect(json['ended_year'], 2024);
      },
    );
  });

  group('ApiClient Projects, Education, and AuthState', () {
    test('getProjects fetches and parses project list', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['Accept'], 'application/json');

        return http.Response(
          jsonEncode([
            {
              'id': 'uuid-1',
              'name': 'Project One',
              'description': 'First project',
              'date': 2026,
              'star_count': 2,
              'is_starred': false,
              'starred_by_names': 'alice',
            },
          ]),
          200,
        );
      });

      final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');
      final projects = await apiClient.getProjects();

      expect(projects, hasLength(1));
      expect(projects.first.name, 'Project One');
      expect(projects.first.date, 2026);
      expect(projects.first.starCount, 2);
    });

    test(
      'createProject sends Authorization header and returns created project',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/v1/projects/');
          expect(request.headers['Authorization'], 'Token secret-token');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body.containsKey('id'), isFalse);
          expect(body['name'], 'New Project');
          expect(body['date'], 2026);

          return http.Response(
            jsonEncode({
              'id': 'uuid-created',
              'star_count': 0,
              'is_starred': false,
              'starred_by_names': '',
              ...body,
            }),
            201,
          );
        });

        final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');
        final created = await apiClient.createProject(
          const Project(
            name: 'New Project',
            description: 'Created via API',
            date: 2026,
          ),
          token: 'secret-token',
        );

        expect(created.id, 'uuid-created');
        expect(created.name, 'New Project');
        expect(created.date, 2026);
      },
    );

    test(
      'Education CRUD and star endpoints send expected requests and responses',
      () async {
        final mockClient = MockClient((request) async {
          if (request.method == 'GET' &&
              request.url.path == '/api/v1/education/') {
            return http.Response(
              jsonEncode([
                {
                  'id': 'edu-1',
                  'institution': 'Universitas Indonesia',
                  'degree': 'S1 Ilmu Komputer',
                  'description': 'Fasilkom UI',
                  'started_year': 2025,
                  'ended_year': null,
                  'star_count': 1,
                  'is_starred': false,
                  'starred_by_names': 'owner',
                },
              ]),
              200,
            );
          }
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/education/') {
            expect(request.headers['Authorization'], 'Token tok-1');
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(body.containsKey('id'), isFalse);
            expect(body['started_year'], 2021);
            expect(body['ended_year'], 2024);
            return http.Response(jsonEncode({'id': 'edu-2', ...body}), 201);
          }
          if (request.method == 'PATCH' &&
              request.url.path == '/api/v1/education/edu-2/') {
            expect(request.headers['Authorization'], 'Token tok-1');
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            return http.Response(jsonEncode({'id': 'edu-2', ...body}), 200);
          }
          if (request.method == 'POST' &&
              request.url.path == '/api/v1/education/edu-2/star/') {
            expect(request.headers['Authorization'], 'Token tok-1');
            return http.Response(
              jsonEncode({
                'id': 'edu-2',
                'institution': 'SMA Negeri 1',
                'degree': 'MIPA Unggulan',
                'description': 'Updated',
                'started_year': 2021,
                'ended_year': 2024,
                'star_count': 1,
                'is_starred': true,
                'starred_by_names': 'admin',
              }),
              200,
            );
          }
          if (request.method == 'DELETE' &&
              request.url.path == '/api/v1/education/edu-2/') {
            expect(request.headers['Authorization'], 'Token tok-1');
            return http.Response('', 204);
          }
          return http.Response('Not Found', 404);
        });

        final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');

        final list = await apiClient.getEducations();
        expect(list, hasLength(1));
        expect(list.first.institution, 'Universitas Indonesia');

        final created = await apiClient.createEducation(
          const Education(
            institution: 'SMA Negeri 1',
            degree: 'MIPA',
            description: 'IPA',
            startedYear: 2021,
            endedYear: 2024,
          ),
          token: 'tok-1',
        );
        expect(created.id, 'edu-2');

        final updated = await apiClient.updateEducation(
          'edu-2',
          const Education(
            institution: 'SMA Negeri 1',
            degree: 'MIPA Unggulan',
            description: 'Updated',
            startedYear: 2021,
            endedYear: 2024,
          ),
          token: 'tok-1',
        );
        expect(updated.degree, 'MIPA Unggulan');

        final starred = await apiClient.toggleEducationStar(
          'edu-2',
          token: 'tok-1',
        );
        expect(starred.isStarred, isTrue);
        expect(starred.starCount, 1);

        await apiClient.deleteEducation('edu-2', token: 'tok-1');
      },
    );

    test('throws ApiException on non-2xx responses', () async {
      final mockClient = MockClient(
        (_) async => http.Response('{"detail": "Invalid token."}', 401),
      );
      final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');

      await expectLater(
        () => apiClient.createEducation(
          const Education(
            institution: 'UI',
            degree: 'S1',
            description: 'Test',
            startedYear: 2025,
          ),
          token: 'revoked',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test(
      'AuthState login stores token and logout clears token even on API error',
      () async {
        final mockClient = MockClient((request) async {
          if (request.url.path == '/api/v1/auth/token/') {
            return http.Response(jsonEncode({'token': 'abc-123'}), 200);
          }
          if (request.url.path == '/api/v1/auth/logout/') {
            return http.Response('Unauthorized', 401);
          }
          return http.Response('Not Found', 404);
        });

        final apiClient = ApiClient(client: mockClient, baseUrl: 'http://test');
        final authState = AuthState(apiClient);

        expect(authState.isLoggedIn, isFalse);
        await authState.login('admin', 'pass123');
        expect(authState.isLoggedIn, isTrue);
        expect(authState.token, 'abc-123');

        await authState.logout();
        expect(authState.isLoggedIn, isFalse);
        expect(authState.token, isNull);
      },
    );
  });
}
