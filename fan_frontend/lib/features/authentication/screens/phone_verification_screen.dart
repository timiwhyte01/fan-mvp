import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/auth_provider.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  ConsumerState<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends ConsumerState<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.startsWith('0')) {
      phone = '+234${phone.substring(1)}';
    } else if (!phone.startsWith('+234')) {
      phone = '+234$phone';
    }
    return phone;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _formatPhoneNumber(_phoneController.text);
    final success = await ref.read(authProvider.notifier).sendOtp(phone);
    
    if (success && mounted) {
      context.go('/auth/otp-verification', extra: phone);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(authProvider).error ?? 'Failed to send OTP'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Enter your phone number',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll send you a verification code to confirm your number',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '08012345678',
                  prefixText: '+234 ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _sendOtp,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send Verification Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
