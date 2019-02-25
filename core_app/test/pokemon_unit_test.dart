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
  var serviceLocator = CoreServiceLocator();

  group('Pokemon Repo Test', () {
    CoreServiceLocator.instance.reset();
    test('Test Get All Pokemon', () async {
      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response('', 200);
      });
      var res = await api.getRequest('pokemon');
      expect(res, TypeMatcher<String>());
    });
  });

  group('Pokemon API Test', () {
    CoreServiceLocator.instance.reset();
    var localResource = LocalResourceMock();
    var resource = ResourceMock();
    when(resource.parser).thenReturn((content) {
      return content;
    });
    when(localResource.getResourceInstance(any)).thenReturn(resource);
    // when(localResource.getResourceInstance(any).parser)
    //     .thenReturn((content) {});
    serviceLocator.registerSingleton<CustomLocalResource>(localResource);
    test('Test Success Network', () async {
      var inputList = List<String>();
      inputList.add(
          '{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"}');
      var mockResult = json.encode({
        "results": inputList,
        "count": 0,
        "next": "",
        "previous": "",
      });

      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(mockResult, 200);
      });
      var res = await api.getRequest(
        'pokemon',
        isCacheFirst: false,
        forceReload: true,
      );
      expect(res, TypeMatcher<String>());
    });

    test('Test Failed Network', () {
      var api = PokemonRepo();
      api.client = MockClient((request) async {
        return http.Response(
            json.encode(
                {'results': '', 'count': 0, 'next': '', 'previous': ''}),
            500);
      });
      expect(api.getRequest('pokemon'),
          throwsA(const TypeMatcher<NonSuccessResponseException>()));
    });
  });
}
