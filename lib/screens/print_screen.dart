import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/invoice_item_model.dart';

void printScreen({required List<InvoiceItemModel> invoiceItems}) async {
  Future<pw.Font> getArabicFont() async {
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<pw.Document> generateDocument() async {
    final doc = pw.Document();
    // Reversed headers order to start with 'Total' and end with 'Item'
    final headers = [
      'Total'.tr,
      'Tax'.tr,
      'Discount'.tr,
      'Price'.tr,
      'Quantity'.tr,
      'Item'.tr,
    ];
    final arabicFont = await getArabicFont();

    // Reversed data order to match the headers
    final data = invoiceItems.map((item) {
      return [
        item.total?.toStringAsFixed(2) ?? '',
        item.tax?.toStringAsFixed(2) ?? '',
        item.discount?.toStringAsFixed(2) ?? '',
        item.price?.toStringAsFixed(2) ?? '',
        item.quantity?.toString() ?? '',
        item.itemName ?? '',
      ];
    }).toList();

    doc.addPage(pw.Page(
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return pw.Column(
          children: [
            pw.Text('Invoice'.tr,
                style: pw.TextStyle(fontSize: 24, font: arabicFont)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: headers,
              data: data,
              border: pw.TableBorder.all(), // Apply border to the table
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, font: arabicFont),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: pw.TextStyle(font: arabicFont),
              cellHeight: 30,
              // Set custom widths for specific columns
              columnWidths: {
                0: pw.FlexColumnWidth(2), // Total
                1: pw.FlexColumnWidth(1.5), // Tax
                2: pw.FlexColumnWidth(1.5), // Discount
                3: pw.FlexColumnWidth(1), // Price
                4: pw.FlexColumnWidth(1.5), // Quantity
                5: pw.FlexColumnWidth(2), // Item
              },
              cellAlignments: {
                0: pw.Alignment.centerRight,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
              },
            ),
          ],
        );
      },
    ));

    return doc;
  }

  final doc = await generateDocument();

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}
