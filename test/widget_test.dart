import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tabeleexample/services/network.dart';
import 'package:tabeleexample/table_bloc.dart';
import 'package:tabeleexample/table_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Network Test Cases', () {
    test('should fetch data successfully', () async {
      final mockClient = MockClient();
      final networkService = Network(httpClient: mockClient);
      when(mockClient.get(Uri.parse('https://jsonplaceholder.typicode.com/users')))
          .thenAnswer((_) async => http.Response('{"id": 1, "name": "Test User"}', 200));

      final response = await networkService.fetchDataFromApi();

      expect(response, isNotNull); // Check if the response is not null or empty
    });

    test('should throw an exception on failed network request', () async {
      final mockClient = MockClient();
      final networkService = Network(httpClient: mockClient);
      when(mockClient.get(Uri.parse('https://jsonplaceholder.typicode.com/users')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => networkService.fetchDataFromApi(), throwsException);
    });
  });

  group('Bloc Test Cases', () {
    test('initial state should be empty', () {
      final tableBloc = TableBloc();

      expect(tableBloc.state, TableState([]));
    });

    test('should emit table data after fetching', () {
      final tableBloc = TableBloc();
      final expectedData = [
        TableData(id: 1, name: 'User 1'),
        TableData(id: 2, name: 'User 2'),
      ];

      tableBloc.fetchData();
      tableBloc.stream.listen((state) {
        expect(state.data, equals(expectedData));
      });
    });

    test('should emit updated state after deleting data', () {
      final tableBloc = TableBloc();
      final expectedData = [
        TableData(id: 1, name: 'User 1'),
        TableData(id: 2, name: 'User 2'),
      ];
      tableBloc.emit(TableState(expectedData));

      final userToDelete = TableData(id: 1, name: 'User 1');
      tableBloc.deleteData(userToDelete);

      tableBloc.stream.listen((state) {
        expect(state.data, equals([TableData(id: 2, name: 'User 2')]));
      });
    });
  });
}
