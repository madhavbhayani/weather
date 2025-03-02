import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_isExpanded ? 0 : 30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.arrow_back : Icons.search),
            onPressed: () {
              setState(() {
                if (_isExpanded) {
                  _isExpanded = false;
                  widget.controller.clear();
                  FocusScope.of(context).unfocus();
                } else {
                  _isExpanded = true;
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              });
            },
            color: Colors.blue.shade700,
          ),
          if (_isExpanded)
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: 'Search city...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                autofocus: true,
                onSubmitted: widget.onSubmitted,
              ),
            ).animate().fadeIn(duration: 200.ms),
          if (_isExpanded)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  widget.onSubmitted(widget.controller.text);
                }
              },
              color: Colors.blue.shade700,
            ),
            
        ],
      ),
    );
  }
}
