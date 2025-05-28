import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';
import 'package:repairo_provider/presentation/screens/home_screen.dart';
import 'package:repairo_provider/presentation/screens/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // getLocation();

    super.initState();

    _pages = [const HomeScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromRGBO(95, 96, 185, 1),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: _pages),
      ),
    );
  }
}
