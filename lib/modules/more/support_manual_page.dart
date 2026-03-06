import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:thingsboard_app/constants/app_constants.dart';

class SupportManualPage extends StatelessWidget {
  const SupportManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('User Manual'),
        centerTitle: false,
      ),
      body: SfPdfViewer.network(
        ThingsboardAppConstants.supportManualPdfUrl,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load PDF: ${details.description}'),
            ),
          );
        },
      ),
    );
  }
}
