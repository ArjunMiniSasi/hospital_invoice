import 'package:flutter/material.dart';
import 'package:hospital_invoice/controller/pdf_controller.dart';
import 'package:provider/provider.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PdfController>(
      builder: (context, myType, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invoice PDF'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                // myType.createPDF();
              },
              child: const Text("Generate PDF"),
            ),
          ),
        );
      },
    );
  }
}
