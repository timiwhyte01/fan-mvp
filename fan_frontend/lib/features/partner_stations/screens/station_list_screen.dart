import 'package:flutter/material.dart';

class StationListScreen extends StatelessWidget {
  const StationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockStations = [
      {
        'name': 'Total Filling Station - Victoria Island',
        'address': '123 Ahmadu Bello Way, Victoria Island, Lagos',
        'distance': '0.5 km',
        'status': 'Open',
        'hours': '24 Hours',
      },
      {
        'name': 'Mobil Filling Station - Ikoyi',
        'address': '45 Kingsway Road, Ikoyi, Lagos',
        'distance': '1.2 km',
        'status': 'Open',
        'hours': '6:00 AM - 10:00 PM',
      },
      {
        'name': 'Oando Filling Station - Lekki',
        'address': '78 Lekki-Epe Expressway, Lekki, Lagos',
        'distance': '2.8 km',
        'status': 'Open',
        'hours': '24 Hours',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search stations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockStations.length,
              itemBuilder: (context, index) {
                final station = mockStations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_gas_station,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      station['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(station['address']!),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              station['distance']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              station['hours']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            station['status']!,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.directions,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
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
