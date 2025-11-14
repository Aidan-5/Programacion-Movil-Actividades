import 'package:flutter/material.dart';
import 'counter_buttons.dart';
import 'counter_text.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decrement() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CounterText(value: _counter),
          const SizedBox(height: 20),
          CounterButtons(increment: increment, decrement: decrement),
        ],
      ),
    );
  }
}