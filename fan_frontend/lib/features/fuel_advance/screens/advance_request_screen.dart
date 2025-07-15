import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';

class AdvanceRequestScreen extends ConsumerStatefulWidget {
  const AdvanceRequestScreen({super.key});

  @override
  ConsumerState<AdvanceRequestScreen> createState() => _AdvanceRequestScreenState();
}

class _AdvanceRequestScreenState extends ConsumerState<AdvanceRequestScreen> {
  double _amount = 1000.0;
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Fuel Advance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Credit Limit',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppConstants.currency}${user.creditLimit.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Select Amount',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${AppConstants.currency}${_amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _amount,
                      min: 500.0,
                      max: user.creditLimit,
                      divisions: ((user.creditLimit - 500) / 100).round(),
                      onChanged: (value) {
                        setState(() {
                          _amount = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppConstants.currency}500'),
                        Text('${AppConstants.currency}${user.creditLimit.toStringAsFixed(0)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You have 24 hours to use this advance at any partner station. Repayment is due within 24 hours.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/qr-display', extra: 'SAMPLE_QR_${DateTime.now().millisecondsSinceEpoch}');
                },
                child: Text('Request ${AppConstants.currency}${_amount.toStringAsFixed(2)} Advance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
