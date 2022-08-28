import 'package:app_reports/src/screens/screens.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    const AddReportScreen(),
    const ReportListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items:  menuNavigationItems(),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 8,
      ),
      body: SafeArea(child: _screens.elementAt(_selectedIndex)),
    );
  }
}

menuNavigationItems() {
  return [
    const BottomNavigationBarItem(
      icon:  Icon(Icons.add_box_rounded, color: Colors.black54,),
      label: 'Add',
      activeIcon: Icon(Icons.add_box_rounded, color: Colors.blue,)
    ),
    const BottomNavigationBarItem(
      icon:  Icon(Icons.list_rounded, color: Colors.black54),
      label: 'Reports',
      activeIcon: Icon(Icons.list_rounded, color: Colors.blue,)
    ),
  ];
}