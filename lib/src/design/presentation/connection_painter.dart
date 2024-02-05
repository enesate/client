import 'package:client/src/design/domain/block_model.dart';
import 'package:client/src/design/domain/connection_model.dart';
import 'package:flutter/material.dart';

class ConnectionPainter extends CustomPainter {
  final List<Connection> connections;
  final Map<int, Offset> blockPositions;
  final List<Block> blocks;

  ConnectionPainter(
      {required this.connections,
      required this.blocks,
      required this.blockPositions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    for (var connection in connections) {
      Offset start = _getInputConnectionPoint(connection.outputBlockId);
      Offset end = _getInputConnectionPoint(connection.inputBlockId);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  /*Offset _getOutputConnectionPoint(int blockId) {
    return blockPositions[blockId] ?? Offset.zero;
  }*/

  Offset _getInputConnectionPoint(int blockId) {
    double dx = blocks[blockId].dx!;
    double dy = blocks[blockId].dy!;
    Offset blockPosition = Offset(dx, dy);
    return blockPosition +
        const Offset(50,
            25); // 50: Blok genişliği, 25: Blok yüksekliğinin yarısı (orta nokta)
  }
}
