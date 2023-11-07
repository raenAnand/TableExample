import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabeleexample/table_bloc.dart';
import 'package:tabeleexample/table_model.dart';

class TableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Table'),
      ),
      body: BlocBuilder<TableBloc, TableState>(
        builder: (context, state) {
          if (state.data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('UserName')),
                    DataColumn(label: Text('Zip')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Company Name')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [
                    for (var userData in state.data)
                      DataRow(
                        cells: [
                          DataCell(Text(userData.id?.toString() ?? '')),
                          DataCell(Text(userData.name ?? '')),
                          DataCell(Text(userData.email ?? '')),
                          DataCell(Text(userData.username ?? '')),
                          DataCell(Text(userData.address?.zipcode ?? '')),
                          DataCell(Text(userData.phone ?? '')),
                          DataCell(Text(userData.company?.name ?? '')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                context.read<TableBloc>().deleteData(userData);
                              },
                            ),
                          ),
                        ],
                        onSelectChanged: (selected) {
                          // Show popup with user's details on tap
                          _showDetailsDialog(context, userData);
                        },
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Function to show user details in a popup
  void _showDetailsDialog(BuildContext context, TableData userData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${userData.id}'),
              Text('Name: ${userData.name}'),
              Text('Email: ${userData.email}'),
              Text('Username: ${userData.username}'),
              Text('Zip: ${userData.address?.zipcode ?? ''}'),
              Text('Phone: ${userData.phone ?? ''}'),
              Text('Company Name: ${userData.company?.name ?? ''}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
