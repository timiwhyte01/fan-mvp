import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class RepaymentScreen extends StatefulWidget {
  final int transactionId;
  
  const RepaymentScreen({super.key, required this.transactionId});

  @override
  State<RepaymentScreen> createState() => _RepaymentScreenState();
}

class _RepaymentScreenState extends State<RepaymentScreen> {
  String _selectedMethod = 'Bank Transfer';
  final _amountController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _amountController.text = '2500.00';
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Outstanding Debt',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppConstants.currency}2,500.00',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due: Today, 11:59 PM',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Payment Amount',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (${AppConstants.currency})',
                prefixText: AppConstants.currency,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...AppConstants.paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Text(method),
                value: method,
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 24),
            if (_selectedMethod == 'Bank Transfer') ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Transfer Details',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Account Name: Fuel Advance Network\nAccount Number: 1234567890\nBank: GTBank\nReference: FAN${widget.transactionId}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment processed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Pay ${AppConstants.currency}${_amountController.text}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
