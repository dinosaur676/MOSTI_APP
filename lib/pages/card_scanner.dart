import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:travel_hour/utils/MyPainter.dart';
import 'package:travel_hour/utils/scanner_utils.dart';

class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  final GlobalKey _stackKey = GlobalKey();
  dynamic _scanResult;
  static final openCVChannel = MethodChannel("com.example.mosti");
  CameraController? _camera;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.high
          : ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera!.initialize();

    setState(() {});

    await _camera!.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      Uint8List datas = ScannerUtils.concatenatePlanes(image.planes);
      print("원본 데이터 길이 : ${datas.length}");

      print("가로 : ${image.width}, 세로 : ${image.height}");

      await openCVChannel
          .invokeMethod("scanCardResult", <String, dynamic>{
        "data": datas,
        "width": image.height,
        "height": image.width,
      })
          .then((dynamic result) async {

        if(result["image"] != null) {
          print("image : ${result["image"].length}");
        }

        if(result["lineList"] != null) {
          print("lineList : ${result["lineList"]}");
        }

        setState(() {
          _scanResult = result;

          if(result["string"] != null) {
            print("result : ${result["string"]}");
          }
        });
        //print(await _textDetect());
      })
          .whenComplete(() => Future.delayed(
          Duration(milliseconds: 500), () => {_isDetecting = false}));
    });
  }
  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
          ),
        ),
      )
          : Stack(
        key: _stackKey,
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_camera!),
          ...drawLine().map((e) => CustomPaint(
            painter: e,
            child: Container(),
          )).toList(),
          drawImage(),
        ],
      ),
    );
  }

  Widget drawImage() {
    if (_scanResult == null) return Container();
    if (_scanResult["image"] == null) return Container();

    return Image.memory(_scanResult["image"]);
  }

  Size? getStackSize() {
    if (_stackKey.currentContext != null) {
      final RenderBox renderBox =
      _stackKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }

    return null;
  }

  List drawLine() {
    if (_scanResult == null) return [];
    if (_scanResult["lineList"] == null) return [];

    List lineList = _scanResult["lineList"];
    List output = [];

    for (int i = 0; i < lineList.length; ++i) {
      int next = (i + 1) % lineList.length;
      Offset start = changePoint(Offset(lineList[i][0], lineList[i][1]))!;
      Offset end = changePoint(Offset(lineList[next][0], lineList[next][1]))!;

      output.add(MyPainter(start: start, end: end));
    }

    return output;
  }

  Offset? changePoint(Offset p) {
    double width = 720.0;
    double height = 1280.0;
    Size? stackSize = getStackSize();

    if (stackSize == null) return null;

    double x = (p.dx / width) * stackSize.width;
    double y = (p.dy / height) * stackSize.height;

    return Offset(x, y);
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResult == null ||
        _camera == null ||
        !_camera!.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Vision Example'),
      ),
      body: _buildImage(),
    );
  }

  @override
  void dispose() {
    _camera!.dispose();

    super.dispose();
  }
}
