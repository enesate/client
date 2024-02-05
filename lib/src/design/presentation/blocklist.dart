import 'package:flutter/material.dart';

class BlockList extends StatelessWidget {
  const BlockList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Blok Listesi'),
          Row(
            children: [
              Draggable<String>(
                data: "addition",
                feedback: _buildBlockWidget("addition", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("addition"),
              ),
              const SizedBox(
                width: 20,
              ),
              Draggable<String>(
                data: "subtraction",
                feedback: _buildBlockWidget("subtraction", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("subtraction"),
              ),
              const SizedBox(
                width: 20,
              ),
              Draggable<String>(
                data: "multiplication",
                feedback: _buildBlockWidget("multiplication", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("multiplication"),
              ),
              const SizedBox(
                width: 20,
              ),
              Draggable<String>(
                data: "division",
                feedback: _buildBlockWidget("division", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("division"),
              ),
              const SizedBox(
                width: 20,
              ),
              Draggable<String>(
                data: "input",
                feedback: _buildBlockWidget("input", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("input"),
              ),
              const SizedBox(
                width: 20,
              ),
              Draggable<String>(
                data: "display",
                feedback: _buildBlockWidget("display", isDragging: true),
                childWhenDragging: Container(),
                child: _buildBlockWidget("display"),
              ),
            ],
          ),

          // Diğer bloklar buraya eklenebilir
        ],
      ),
    );
  }

  Widget _buildBlockWidget(String blockType, {bool isDragging = false}) {
    return Container(
      width: 50,
      height: 50,
      color: isDragging ? Colors.blue.withOpacity(0.5) : Colors.blue,
      child: Center(
        child: Text(_getBlockLabel(blockType)),
      ),
    );
  }

  String _getBlockLabel(String blocktype) {
    switch (blocktype) {
      case "addition":
        return '+';
      case "subtraction":
        return '-';
      case "multiplication":
        return '*';
      case "division":
        return '÷';
      case "input":
        return 'In';
      case "display":
        return 'Dis';
      default:
        return '';
    }
  }
}
