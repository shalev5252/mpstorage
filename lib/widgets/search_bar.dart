import 'package:flutter/material.dart';

Widget buildSearchBar({required TextEditingController controller, required Function(String) onSearch}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      onSubmitted: onSearch,
    ),
  );
}
