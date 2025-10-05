import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/network_service.dart';
import '../../shared/services/service_locator.dart';

class NetworkStatusWidget extends StatelessWidget {
  const NetworkStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ServiceLocator.getNetworkService(context).networkStatusStream,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        
        if (isOnline) {
          return const SizedBox.shrink(); // 온라인일 때는 숨김
        }
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.orange.shade100,
          child: Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.orange.shade800,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Offline Mode - Data is loaded from cache',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 