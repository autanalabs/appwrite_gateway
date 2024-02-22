import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../functions/gateway/main.dart' as sut;

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'main_test.mocks.dart';

// Define los mocks para req y res, ajusta según tu implementación real.
class MockReq {
  final String path;
  final Map<String, String> query;

  MockReq(this.path, this.query);
}

class MockRes {
  String? _body;
  String? get body => _body;

  void send(String message) {
    _body = message;
  }
}

class MockContext {
  final MockReq req;
  final MockRes res;

  MockContext(this.req, this.res);
}

// Función para crear un contexto mock.
dynamic createContext(String path, Map<String, String> query) {
  final req = MockReq(path, query);
  final res = MockRes();

  return MockContext(req, res);
}

void main() {
  group('Currency Conversion', () {
    test('Converts EUR to USD successfully', () async {
      final client = MockClient();
      sut.httpClient = client;
      final context = createContext('/eur', {'amount': '100'}); // Asume que tienes una función que crea un contexto mock
      final mockResponse = {
        'quotes': {'EURUSD': 1.12}
      };

      when(client.get(any)).thenAnswer((_) async =>
          http.Response(json.encode(mockResponse), 200));

      await sut.main(context);
      expect(context.res.body, '112.00');
    });

    test('Converts INR to USD successfully', () async {
      final client = MockClient();
      sut.httpClient = client;
      final context = createContext('/inr', {'amount': '100'}); // Asume que tienes una función que crea un contexto mock
      final mockResponse = {
        'quotes': {'INRUSD': 0.013}
      };

      when(client.get(any)).thenAnswer((_) async =>
          http.Response(json.encode(mockResponse), 200));

      await sut.main(context);
      expect(context.res.body, '1.30');
    });

    test('Returns invalid path message', () async {
      final context = createContext('/invalid', {}); // Asume que tienes una función que crea un contexto mock

      expect(await sut.main(context), 'Invalid path');
    });
  });
}
