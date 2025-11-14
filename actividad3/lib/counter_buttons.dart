import 'package:flutter/material.dart';

class CounterButtons extends StatelessWidget {
  final VoidCallback increment;
  final VoidCallback decrement;

  const CounterButtons({
    super.key,
    required this.increment,
    required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: decrement, icon: const Icon(Icons.remove)),
        const SizedBox(width: 16),
        IconButton(onPressed: increment, icon: const Icon(Icons.add)),
      ],
    );
  }
}