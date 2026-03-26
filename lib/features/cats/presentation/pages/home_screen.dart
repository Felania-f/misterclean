import 'package:flutter/material.dart';

import 'cat_list_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

//!1.2.2 YAGNI,_toggleDarkMode, _syncWithCloud, _exportData affichent uniquement "coming soon", code non fonctionnel, inutile pour le moment
//!Dead code, ces trois méthodes sont du dead code fonctionnel aussi, elles existent mais ne font rien d'utile
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heliosito'),
        actions: [
          IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: () => _toggleDarkMode(context)),
          IconButton(
              icon: const Icon(Icons.cloud_sync),
              onPressed: () => _syncWithCloud(context)),
          IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _exportData(context)),
        ],
      ),
      body: const CatListPage(),
    );
  }

  void _toggleDarkMode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dark mode coming soon')));
  }

  void _syncWithCloud(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloud sync coming soon')));
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Export coming soon')));
  }
}
