import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class PickedReceipt {
  const PickedReceipt({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    required this.extension,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final String extension;
}

class ReceiptUploader extends StatefulWidget {
  const ReceiptUploader({super.key, required this.onChanged});

  final ValueChanged<PickedReceipt?> onChanged;

  @override
  State<ReceiptUploader> createState() => _ReceiptUploaderState();
}

class _ReceiptUploaderState extends State<ReceiptUploader> {
  String? _fileName;
  String? _error;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.first;
    final bytes = file.bytes;
    final name = file.name;
    final extension = (file.extension ?? '').toLowerCase();

    if (bytes == null) {
      setState(() {
        _error = 'No se pudo leer el archivo.';
      });
      widget.onChanged(null);
      return;
    }

    if (bytes.length > AppConstants.maxReceiptSizeBytes) {
      setState(() {
        _error = 'Archivo muy grande. Máximo 8MB.';
        _fileName = null;
      });
      widget.onChanged(null);
      return;
    }

    final mimeType = switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      _ => '',
    };

    if (!AppConstants.allowedMimeTypes.contains(mimeType)) {
      setState(() {
        _error = 'Formato no permitido. Usá JPG, PNG, WEBP o PDF.';
        _fileName = null;
      });
      widget.onChanged(null);
      return;
    }

    setState(() {
      _error = null;
      _fileName = name;
    });

    widget.onChanged(
      PickedReceipt(
        bytes: bytes,
        fileName: name,
        mimeType: mimeType,
        extension: extension,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.upload_file),
          label: const Text('Subir comprobante'),
        ),
        if (_fileName != null) ...[
          const SizedBox(height: 8),
          Text('Archivo: $_fileName'),
        ],
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}
