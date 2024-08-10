import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DoodleApp());
}

class DoodleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrawingProvider(),
      child: MaterialApp(
        home: DoodleScreen(),
      ),
    );
  }
}

class DoodleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doodle App'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Provider.of<DrawingProvider>(context, listen: false)
                  .clearDrawing();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                Provider.of<DrawingProvider>(context, listen: false)
                    .addPoint(details.localPosition);
              },
              onPanEnd: (details) {
                Provider.of<DrawingProvider>(context, listen: false)
                    .endStroke();
              },
              child: Consumer<DrawingProvider>(
                builder: (context, drawingProvider, child) {
                  return CustomPaint(
                    painter: DoodlePainter(drawingProvider.paths),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.brush, color: Colors.black),
                  onPressed: () {
                    Provider.of<DrawingProvider>(context, listen: false)
                        .changeColor(Colors.black);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.brush, color: Colors.red),
                  onPressed: () {
                    Provider.of<DrawingProvider>(context, listen: false)
                        .changeColor(Colors.red);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.brush, color: Colors.blue),
                  onPressed: () {
                    Provider.of<DrawingProvider>(context, listen: false)
                        .changeColor(Colors.blue);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.brush, color: Colors.green),
                  onPressed: () {
                    Provider.of<DrawingProvider>(context, listen: false)
                        .changeColor(Colors.green);
                  },
                ),
                Slider(
                  value: Provider.of<DrawingProvider>(context).penSize,
                  min: 1.0,
                  max: 20.0,
                  onChanged: (value) {
                    Provider.of<DrawingProvider>(context, listen: false)
                        .changePenSize(value);
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/eraser.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  onPressed: () {
                    if (Provider.of<DrawingProvider>(context, listen: false)
                        .isEraserActive) {
                      Provider.of<DrawingProvider>(context, listen: false)
                          .deactivateEraser();
                    } else {
                      Provider.of<DrawingProvider>(context, listen: false)
                          .activateEraser();
                    }
                  },
                  color: Provider.of<DrawingProvider>(context).isEraserActive
                      ? Colors.grey
                      : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoodlePainter extends CustomPainter {
  final List<Map<String, dynamic>> paths;

  DoodlePainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (var pathData in paths) {
      final paint = Paint()
        ..color = pathData['color']
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = pathData['penSize']
        ..style = PaintingStyle.stroke;

      canvas.drawPath(pathData['path'], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _paths = [];
  Path? _currentPath;
  Color _selectedColor = Colors.black;
  double _penSize = 5.0;
  bool _isEraserActive = false;

  List<Map<String, dynamic>> get paths => _paths;
  Color get selectedColor => _selectedColor;
  double get penSize => _penSize;
  bool get isEraserActive => _isEraserActive;

  void addPoint(Offset point) {
    if (_currentPath == null) {
      _currentPath = Path()..moveTo(point.dx, point.dy);
      _paths.add({
        'path': _currentPath!,
        'color': _isEraserActive ? Colors.white : _selectedColor,
        'penSize': _penSize,
      });
    } else {
      _currentPath!.lineTo(point.dx, point.dy);
    }
    notifyListeners();
  }

  void endStroke() {
    _currentPath = null;
  }

  void clearDrawing() {
    _paths.clear();
    notifyListeners();
  }

  void changeColor(Color color) {
    _selectedColor = color;
    _isEraserActive = false;
    notifyListeners();
  }

  void changePenSize(double size) {
    _penSize = size;
    notifyListeners();
  }

  void activateEraser() {
    _isEraserActive = true;
    notifyListeners();
  }

  void deactivateEraser() {
    _isEraserActive = false;
    notifyListeners();
  }
}
