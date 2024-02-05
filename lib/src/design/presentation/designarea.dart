import 'package:client/src/design/domain/block_model.dart';
import 'package:client/src/design/domain/connection_model.dart';
import 'package:client/src/design/presentation/buttons.dart';
import 'package:client/src/design/presentation/connection_painter.dart';
import 'package:client/src/project/data/project_model.dart';
import 'package:client/src/project/data/project_repository.dart';
import 'package:client/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesignArea extends StatefulWidget {
  final Project project;

  const DesignArea({super.key, required this.project});
  @override
  State<DesignArea> createState() => _DesignAreaState();
}

class _DesignAreaState extends State<DesignArea> {
  List<Block> blocks = [];
  Map<int, Offset> blockPositions = {};
  List<Connection> connections = [];
  ProjectRepository projectRepository = ProjectRepository();
  TextEditingController inputController = TextEditingController();

  Offset? lineOffset;
  int? selectedOutputBlockId;
  int? selectedInputBlockId;

  //Önceden proje varsa providerdan çekiyor
  void _fetchData() {
    Project project1 =
        Provider.of<DataProvider>(context, listen: false).project!;
    blocks = project1.blocks!;
    for (Block block in blocks) {
      for (int connectedBlockId in block.connectedBlocks) {
        // Her bir bağlantıyı oluşturup listeye ekle
        connections.add(Connection(
            inputBlockId: block.id1, outputBlockId: connectedBlockId));
      }
    }
    setState(() {});
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tasarım Kayıt Edilmiştir"),
          content: const Text("Tasarım Kayıt Edilmiştir"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Buttons(onPressedRun: () {
          projectRepository.saveBlocks(widget.project.id1!, blocks);
          Provider.of<DataProvider>(context, listen: false).setrunBtn(1);
          setState(() {});
        }, onPressedClear: () {
          blocks = [];
          connections = [];
          setState(() {});
        }, onPressedSave: () {
          projectRepository
              .saveBlocks(widget.project.id1!, blocks)
              .then((value) => _showDialog());
        }),
        Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 280,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Stack(
                children: [
                  CustomPaint(
                    painter: ConnectionPainter(
                        connections: connections,
                        blockPositions: blockPositions,
                        blocks: blocks),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tasarım Alanı'),
                    ],
                  ),
                  // Eklenen blokları göster
                  for (var block in blocks)
                    Positioned(
                      left: block.dx,
                      top: block.dy,
                      child: _buildBlockWidget1(block),
                    ),
                ],
              );
            },
            onWillAccept: (data) {
              return true;
            },
            onAcceptWithDetails: (details) {
              setState(() {
                int blockId = blocks.length; // Bloğun sıra numarasını al
                blocks.add(Block(
                  id1: blockId,
                  blockType: details.data,
                  connectedBlocks: [],
                ));
                blocks[blockId].dx = details.offset.dx - 30;
                blocks[blockId].dy = details.offset.dy - 248;
                print(blocks);
                print(blockPositions); // Başlangıç konumu
              });
            },
            onAccept: (data) {},
          ),
        ),
      ],
    );
  }

  Widget _buildBlockWidget1(Block block) {
    if (block.blockType == "input") {
      return _buildInputBlockWidget(block);
    } else if (block.blockType == "display") {
      return _buildOutputBlockWidget(block);
    } else {
      return _buildBlockWidget(block);
    }
  }

  Widget _buildInputBlockWidget(Block block) {
    return GestureDetector(
      onTap: () {
        _handleBlockTap(block);
      },
      onPanUpdate: (details) {
        // Yeni pozisyonu hesapla
        setState(() {
          double dx = block.dx!;
          double dy = block.dy!;
          Offset blockOffset = Offset(dx, dy);
          Offset newPosition =
              blockOffset.translate(details.delta.dx, details.delta.dy);

          // Kontrolü ekleyin: Blokların üst üste gelmesini ve tasarım alanının dışına çıkmasını engelle
          for (var otherBlock in blocks) {
            double dx = otherBlock.dx!;
            double dy = otherBlock.dy!;
            Offset otherBlockOffset = Offset(dx, dy);
            if (otherBlock.id1 != block.id1) {
              double distance = (newPosition - otherBlockOffset).distance;
              if (distance < 60) {
                // 50: Blok genişliği/yüksekliği, blokların arasındaki minimum mesafe
                // Bloklar birbirine çok yakın, çakışmayı engellemek için güncelleme yapma
                return;
              }
            }
          }

          // Tasarım alanının sınırlarını kontrol et
          newPosition = Offset(
            newPosition.dx.clamp(0, MediaQuery.of(context).size.width - 50),
            newPosition.dy.clamp(0, MediaQuery.of(context).size.height - 50),
          );
          block.dx = newPosition.dx;
          block.dy = newPosition.dy;
          //blockPositions[block.id] = newPosition;

          print(blocks);
          //print(blockPositions);
        });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: TextField(
              controller: TextEditingController(
                  text: block.value != null ? block.value.toString() : ""),
              onChanged: (value) {
                setState(() {
                  block.value = int.tryParse(value);
                });
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockWidget(Block block) {
    return GestureDetector(
      onTap: () {
        _handleBlockTap(block);
      },
      onPanUpdate: (details) {
        // Bloğu sürükle
        // Yeni pozisyonu hesapla
        setState(() {
          double dx = block.dx!;
          double dy = block.dy!;
          Offset blockOffset = Offset(dx, dy);
          Offset newPosition =
              blockOffset.translate(details.delta.dx, details.delta.dy);

          // Kontrolü ekleyin: Blokların üst üste gelmesini ve tasarım alanının dışına çıkmasını engelle
          for (var otherBlock in blocks) {
            double dx = otherBlock.dx!;
            double dy = otherBlock.dy!;
            Offset otherBlockOffset = Offset(dx, dy);
            if (otherBlock.id1 != block.id1) {
              double distance = (newPosition - otherBlockOffset).distance;
              if (distance < 60) {
                // 50: Blok genişliği/yüksekliği, blokların arasındaki minimum mesafe
                // Bloklar birbirine çok yakın, çakışmayı engellemek için güncelleme yapma
                return;
              }
            }
          }

          // Tasarım alanının sınırlarını kontrol et
          newPosition = Offset(
            newPosition.dx.clamp(0, MediaQuery.of(context).size.width - 50),
            newPosition.dy.clamp(0, MediaQuery.of(context).size.height - 50),
          );
          block.dx = newPosition.dx;
          block.dy = newPosition.dy;
          //blockPositions[block.id] = newPosition;
          print(blocks);
          //print(blockPositions);
        });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.blue,
        child: Center(
          child: Text(_getBlockLabel(block.blockType)),
        ),
      ),
    );
  }

  Widget _buildOutputBlockWidget(Block block) {
    int runBtn = Provider.of<DataProvider>(context, listen: true).runButton;
    return GestureDetector(
      onTap: () {
        _handleBlockTap(block);
      },
      onPanUpdate: (details) {
        // Bloğu sürükle
        // Yeni pozisyonu hesapla
        setState(() {
          double dx = block.dx!;
          double dy = block.dy!;
          Offset blockOffset = Offset(dx, dy);
          Offset newPosition =
              blockOffset.translate(details.delta.dx, details.delta.dy);

          // Kontrolü ekleyin: Blokların üst üste gelmesini ve tasarım alanının dışına çıkmasını engelle
          for (var otherBlock in blocks) {
            double dx = otherBlock.dx!;
            double dy = otherBlock.dy!;
            Offset otherBlockOffset = Offset(dx, dy);
            if (otherBlock.id1 != block.id1) {
              double distance = (newPosition - otherBlockOffset).distance;
              if (distance < 60) {
                // 50: Blok genişliği/yüksekliği, blokların arasındaki minimum mesafe
                // Bloklar birbirine çok yakın, çakışmayı engellemek için güncelleme yapma
                return;
              }
            }
          }

          // Tasarım alanının sınırlarını kontrol et
          newPosition = Offset(
            newPosition.dx.clamp(0, MediaQuery.of(context).size.width - 50),
            newPosition.dy.clamp(0, MediaQuery.of(context).size.height - 50),
          );
          block.dx = newPosition.dx;
          block.dy = newPosition.dy;
          //blockPositions[block.id] = newPosition;
          print(blocks);
          //print(blockPositions);
        });
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.blue,
            child: Center(
              child: block.input1 != null
                  ? (runBtn == 1
                      ? Text(block.input1.toString())
                      : Text(_getBlockLabel(block.blockType)))
                  : Text(_getBlockLabel(block.blockType)),
            ),
          ),
        ],
      ),
    );
  }

  //block tipleri
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

  //matematik işlemlerinin yapıldığı yer
  int _performMathOperation(int input1, int input2, String operator) {
    switch (operator) {
      case "addition":
        return input1 + input2;
      case "subtraction":
        return input1 - input2;
      case "multiplication":
        return input1 * input2;
      case "division":
        return input1 ~/ input2; // ~/ bölme işleminden tam sayı sonucu alır
      default:
        return 0;
    }
  }

  //bloklara tıklandığında bağlantı kurulmasını sağlayan fonksiyon
  void _handleBlockTap(Block block) {
    if (selectedInputBlockId == null) {
      setState(() {
        selectedInputBlockId = block.id1;
      });
    } else if (selectedOutputBlockId == null) {
      setState(() {
        selectedOutputBlockId = block.id1;
        Block inputBlock = blocks[selectedInputBlockId!];
        Block outputBlock = blocks[selectedOutputBlockId!];
        if (selectedInputBlockId != selectedOutputBlockId) {
          if ((inputBlock.blockType == "input" &&
              inputBlock.connectedBlocks.isEmpty &&
              inputBlock.value != null)) {
            if ((outputBlock.blockType != "input" &&
                    outputBlock.blockType != "display" &&
                    outputBlock.connectedBlocks.length < 3) &&
                outputBlock.output == null) {
              if (outputBlock.input1 == null) {
                outputBlock.input1 = inputBlock.value;
              } else {
                outputBlock.input2 = inputBlock.value;
              }
              if (outputBlock.input1 != null && outputBlock.input2 != null) {
                outputBlock.output = _performMathOperation(outputBlock.input1!,
                    outputBlock.input2!, outputBlock.blockType);
              }
              _createConnection(selectedOutputBlockId!, selectedInputBlockId!);
            }
          } else if ((inputBlock.blockType != "display" &&
                  inputBlock.blockType != "input" &&
                  inputBlock.connectedBlocks.length < 3) &&
              (outputBlock.blockType == "display" &&
                  outputBlock.connectedBlocks.length < 2 &&
                  outputBlock.input1 == null)) {
            outputBlock.input1 = inputBlock.output;
            _createConnection(selectedOutputBlockId!, selectedInputBlockId!);
          } else if ((inputBlock.blockType != "display" &&
                  inputBlock.blockType != "input" &&
                  inputBlock.connectedBlocks.length == 2) &&
              (outputBlock.blockType != "display" &&
                  outputBlock.blockType != "input" &&
                  outputBlock.connectedBlocks.length < 3) &&
              outputBlock.output == null) {
            if (outputBlock.input1 == null) {
              outputBlock.input1 = inputBlock.output;
            } else {
              outputBlock.input2 = inputBlock.output;
            }
            if (outputBlock.input1 != null && outputBlock.input2 != null) {
              outputBlock.output = _performMathOperation(outputBlock.input1!,
                  outputBlock.input2!, outputBlock.blockType);
            }
            _createConnection(selectedOutputBlockId!, selectedInputBlockId!);
          }
        }
        selectedOutputBlockId = null;
        selectedInputBlockId = null;
      });
    }
  }

  //iki tane block id leri alıp arasında bağlantı oluşturuyor
  void _createConnection(int outputBlockId, int inputBlockId) {
    setState(() {
      blocks[inputBlockId].connectedBlocks.add(outputBlockId);
      blocks[outputBlockId].connectedBlocks.add(inputBlockId);
      connections.add(
          Connection(outputBlockId: outputBlockId, inputBlockId: inputBlockId));
      print(blocks[outputBlockId].toJson());
      print(blocks[inputBlockId].toJson());
    });
  }
}
