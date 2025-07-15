import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockTransactions = [
      {
        'id': 'TXN001',
        'amount': 2500.0,
        'station': 'Total Filling Station - VI',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'Completed',
        'type': 'Fuel Advance',
      },
      {
        'id': 'TXN002',
        'amount': 1800.0,
        'station': 'Mobil Filling Station - Ikoyi',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Repaid',
        'type': 'Fuel Advance',
      },
      {
        'id': 'TXN003',
        'amount': 3200.0,
        'station': 'Oando Filling Station - Lekki',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'Repaid',
        'type': 'Fuel Advance',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Filter by Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'repaid', child: Text('Repaid')),
                    ],
                    onChanged: (value) {},
                    value: 'all',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Time Period',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Time')),
                      DropdownMenuItem(value: 'week', child: Text('This Week')),
                      DropdownMenuItem(value: 'month', child: Text('This Month')),
                    ],
                    onChanged: (value) {},
                    value: 'all',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockTransactions.length,
              itemBuilder: (context, index) {
                final transaction = mockTransactions[index];
                final date = transaction['date'] as DateTime;
                final status = transaction['status'] as String;
                
                Color statusColor;
                IconData statusIcon;
                
                switch (status.toLowerCase()) {
                  case 'completed':
                    statusColor = Colors.blue;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'repaid':
                    statusColor = Colors.green;
                    statusIcon = Icons.payment;
                    break;
                  case 'pending':
                    statusColor = Colors.orange;
                    statusIcon = Icons.pending;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.help;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                    ),
                    title: Text(
                      '${AppConstants.currency}${(transaction['amount'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(transaction['station'] as String),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
