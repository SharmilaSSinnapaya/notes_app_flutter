import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/about_screen.dart';
import '../screens/home_screen.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text('Notes App', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            secondary: const Icon(Icons.brightness_6),
          ),
        ],
      ),
    );
  }
}
