class Block {
  final int id1;
  final String blockType;
  double? dx;
  double? dy;
  int? value;
  int? input1;
  int? input2;
  int? output;
  List<int> connectedBlocks = [];

  Block(
      {required this.blockType,
      required this.id1,
      this.value,
      this.dx,
      this.dy,
      this.input1,
      this.input2,
      this.output,
      required this.connectedBlocks});

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'blockType': blockType,
      'id1': id1,
      'dx': dx,
      'dy': dy,
      'value': value,
      'input1': input1,
      'input2': input2,
      'output': output,
      'connectedBlocks': connectedBlocks,
    };
  }

  // fromJson fabrika metodu
  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        blockType: json['blockType'],
        id1: json['id1'],
        dx: json['dx'],
        dy: json['dy'],
        value: json['value'],
        input1: json['input1'],
        input2: json['input2'],
        output: json['output'],
        connectedBlocks: List<int>.from(json['connectedBlocks']));
  }
}
