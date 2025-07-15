import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

class QrDisplayScreen extends StatefulWidget {
  final String qrCode;
  
  const QrDisplayScreen({super.key, required this.qrCode});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  Duration _timeRemaining = const Duration(hours: 24);
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }
  
  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeRemaining.inSeconds > 0) {
        setState(() {
          _timeRemaining = _timeRemaining - const Duration(seconds: 1);
        });
        _startCountdown();
      }
    });
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Fuel Advance'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advance Approved!',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Show this QR code at any partner station',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    QrImageView(
                      data: widget.qrCode,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'QR Code',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.qrCode,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Time Remaining',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(_timeRemaining),
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/stations'),
                    icon: const Icon(Icons.location_on),
                    label: const Text('Find Stations'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/dashboard'),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
