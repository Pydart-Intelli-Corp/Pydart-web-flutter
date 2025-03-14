import 'dart:math';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String query, String category) onSearch;
  final double width; // The desired maximum width

  SearchWidget({
    required this.controller,
    required this.onSearch,
    required this.width,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;
  final FocusNode _focusNode = FocusNode();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Posters',
    'Books',
    'T-Shirts',
    'Artwork'
  ];

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _iconAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() => setState(() {}));
  }

  void _handleSearch() {
    widget.onSearch(widget.controller.text, _selectedCategory);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate a responsive width:
    // Use the smaller value between the provided width and 90% of the screen width.
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = min(widget.width, screenWidth * 0.9);

    return Container(
      width: containerWidth,
      // This constraint makes sure the container doesn't exceed the provided width.
      constraints: BoxConstraints(maxWidth: widget.width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: _focusNode.hasFocus
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 0,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: TextStyle(color: const Color.fromARGB(204, 255, 255, 255)),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
              color: const Color.fromARGB(215, 237, 237, 237), fontSize: 12),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(18, 32, 95, 122),
          prefixIcon: _buildCategoryDropdown(), // Dropdown on left
          suffixIcon: _buildSearchButton(), // Search button on right
        ),
        onChanged: (_) => _handleSearch(),
      ),
    );
  }

  /// Dropdown Button (Placed at the Start)
  Widget _buildCategoryDropdown() {
    return Padding(
      padding: EdgeInsets.only(left: 10), // Adjust left padding
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
          dropdownColor: const Color.fromARGB(57, 32, 95, 122),
          style: TextStyle(color: Colors.white, fontSize: 12),
          borderRadius: BorderRadius.circular(0),
          items: _categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => _selectedCategory = newValue!);
            _handleSearch();
          },
        ),
      ),
    );
  }

  /// Search Button (Placed at the End)
  Widget _buildSearchButton() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: IconButton(
        icon: Icon(Icons.search, color: Colors.white70),
        onPressed: () {
          _iconController.forward().then((_) => _iconController.reverse());
          _handleSearch();
        },
      ),
    );
  }
}
