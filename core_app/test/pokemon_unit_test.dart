import 'dart:convert';

import 'package:async_resource/async_resource.dart';
import 'package:core_app/core.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';

class LocalResourceMock extends Mock implements CustomLocalResource {}

class ResourceMock extends Mock implements LocalResource<String> {}

void main() {
  var _serviceLocator = CoreServiceLocator();
  var successResponse =
      '{"count":964,"next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20","previous":null,"results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"raticate","url":"https://pokeapi.co/api/v2/pokemon/20/"}]}';
  var _localResource = LocalResourceMock();
  var _resource = ResourceMock();
  group('Pokemon Repo Test', () {
    CoreServiceLocator.instance.reset();

    // mock write cache
    when(_resource.write(any)).thenAnswer((_) => Future.value(successResponse));
    // mock local resource
    when(_localResource.getResourceInstance(any)).thenReturn(_resource);
    _serviceLocator.registerSingleton<CustomLocalResource>(_localResource);

    test('Test Get All Pokemon', () async {
      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(successResponse, 200);
      });
      var res = await api.getAll();
      expect(res, TypeMatcher<List<Pokemon>>());
    });
  });

  group('Pokemon API Test', () {
    CoreServiceLocator.instance.reset();

    // mock local resource
    when(_localResource.getResourceInstance(any)).thenReturn(_resource);
    _serviceLocator.registerSingleton<CustomLocalResource>(_localResource);
    test('Success - Network', () async {
      // mock write cache
      when(_resource.write(any))
          .thenAnswer((_) => Future.value(successResponse));

      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(successResponse, 200);
      });
      var res = await api.getRequest(
        'pokemon',
        isCacheFirst: false,
        forceReload: true,
      );
      expect(res, TypeMatcher<String>());
    });

    test('Failed - Network', () {
      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(
            json.encode(
                {'results': '', 'count': 0, 'next': '', 'previous': ''}),
            500);
      });
      expect(api.getRequest('pokemon', forceReload: true),
          throwsA(const TypeMatcher<NonSuccessResponseException>()));
    });

    test('Success - Failed Network Cache Valid', () async {
      /// mock cache
      when(_resource.get()).thenAnswer((_) => Future.value(successResponse));

      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(
            json.encode(
                {'results': '', 'count': 0, 'next': '', 'previous': ''}),
            500);
      });
      expect(await api.getRequest('pokemon', forceReload: true),
          TypeMatcher<String>());
    });

    test('Failed - Failed Network Cache Invalid', () async {
      /// mock cache invalid
      when(_resource.get()).thenAnswer((_) => null);

      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(
            json.encode(
                {'results': '', 'count': 0, 'next': '', 'previous': ''}),
            500);
      });
      expect(api.getRequest('pokemon', forceReload: true),
          throwsA(const TypeMatcher<NonSuccessResponseException>()));
    });
  });
}
