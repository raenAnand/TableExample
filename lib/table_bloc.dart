import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabeleexample/services/network.dart';
import 'package:tabeleexample/table_model.dart';

class TableState extends Equatable {
  final List<TableData> data;

  TableState(this.data);

  @override
  List<Object?> get props => [data];
}

class TableBloc extends Cubit<TableState> {
  final Network apiService = Network();

  TableBloc() : super(TableState([])) {
    fetchData();
  }

  void fetchData() async {
    try {
      final List<dynamic> result = await apiService.fetchDataFromApi();
      List<TableData> tableData = result.map((data) => TableData.fromJson(data)).toList();
      emit(TableState(tableData));
    } catch (e) {
      // Handle error state if fetching data fails
      emit(TableState([]));
    }
  }

  void deleteData(TableData userData) {
    final List<TableData> updatedData = List<TableData>.from(state.data);
    updatedData.remove(userData); // Remove the specific user data
    emit(TableState(updatedData)); // Emit the updated state without the removed user data
  }
}
