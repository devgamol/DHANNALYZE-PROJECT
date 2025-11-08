import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/customer_dashboard_screen.dart';
import '../screens/customer_loan_screen.dart';
import '../screens/customer_accounts_screen.dart';
import '../screens/customer_profile_screen.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppNavigationBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const CustomerDashboardScreen();
        break;
      case 1:
        nextScreen = const CustomerAccountsScreen();
        break;
      case 2:
        nextScreen = const CustomerLoanScreen();
        break;
      case 3:
        nextScreen = const CustomerProfileScreen();
        break;

      default:
        nextScreen = const CustomerDashboardScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Match status bar with app background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF11121A),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF11121A),
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF5E63FF),
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Accounts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_outlined),
          label: 'Loans',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
