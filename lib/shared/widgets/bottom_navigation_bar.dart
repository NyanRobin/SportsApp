import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                index: 0,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                label: 'Games',
                index: 1,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.announcement_outlined,
                label: 'Announcements',
                index: 2,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_outlined,
                label: 'Statistics',
                index: 3,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'My Profile',
                index: 4,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = index == currentIndex;
    
    return InkWell(
      onTap: () {
        if (index != currentIndex) {
          if (onTap != null) {
            onTap!(index);
          } else {
            // Fallback to go_router navigation
            switch (index) {
              case 0:
                context.go(AppConstants.homeRoute);
                break;
              case 1:
                context.go(AppConstants.gamesRoute);
                break;
              case 2:
                context.go(AppConstants.announcementsRoute);
                break;
              case 3:
                context.go(AppConstants.statisticsRoute);
                break;
              case 4:
                context.go(AppConstants.profileRoute);
                break;
            }
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
