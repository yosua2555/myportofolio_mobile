import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
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

  group('ApiClient and AuthState', () {
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
