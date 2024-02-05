import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  final VoidCallback? onPressedClear;
  final VoidCallback? onPressedSave;
  final VoidCallback? onPressedRun;

  const Buttons(
      {super.key,
      required this.onPressedClear,
      required this.onPressedSave,
      required this.onPressedRun});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: widget.onPressedRun,
          child: const Text('Run'),
        ),
        const SizedBox(
          width: 30,
        ),
        ElevatedButton(
          onPressed: widget.onPressedSave,
          child: const Text('Save'),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: widget.onPressedClear,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
