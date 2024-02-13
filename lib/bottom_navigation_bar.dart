import 'package:flutter/material.dart';
import 'views/home/add_clients3.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userRole;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userRole,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<Employee> employees = <Employee>[];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final role = widget.userRole;
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        if (role == 'admin')
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Sales',
          )
        else
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Sales',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      onTap: (index) {
        widget.onItemTapped(index);
        switch (index) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            break;
        }
      },
    );
  }
}
