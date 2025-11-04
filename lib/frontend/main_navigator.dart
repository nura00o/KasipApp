import 'package:career_compasp/frontend/HomePage.dart';
import 'package:flutter/material.dart';


class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 129, 125, 232),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              backgroundColor: Colors.blue[200],

              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue[300],
              unselectedItemColor: Colors.blue[300],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _onItemTapped,
              elevation: 2,

              items: [
                _navBarItem(Icons.home, 0),

                _navBarItem(Icons.assignment, 1),

                _navBarItem(Icons.add_circle, 2),

                _navBarItem(Icons.account_circle, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navBarItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Icon(icon),
      ),
      label: '',
    );
  }
}
