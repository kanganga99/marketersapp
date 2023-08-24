import 'package:flutter/material.dart';
import 'views/home/add_clients3.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
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
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
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
            // Navigator.pushNamed(context, "/home");
            break;
          case 1:
            // Navigator.pushNamed(context, "/search");
            break;
          case 2:
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const AddedClients(
            //       isEditing: false,
            //       id: 0,
            //     ),
            //   ),
            // );
            break;
          case 3:
            // Navigator.pushNamed(context, "/profile");
            break;
        }
      },
    );
  }
}
