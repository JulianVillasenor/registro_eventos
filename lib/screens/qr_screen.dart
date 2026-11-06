
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final MobileScannerController _controller = MobileScannerController();

  bool _procesando = false;

  void _procesarQR(BarcodeCapture capture) {
    if (_procesando) return;

    if (capture.barcodes.isEmpty) return;

    final String? contenido = capture.barcodes.first.rawValue;

    if (contenido == null || contenido.isEmpty) return;

    setState(() {
      _procesando = true;
    });

    _controller.stop();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Código QR detectado'),
        content: SelectableText(contenido),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(contenido);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _procesarQR,
      ),
    );
  }
}
