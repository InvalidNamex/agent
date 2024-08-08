import 'package:eit/models/api/api_invoice_details_model.dart';
import 'package:eit/models/api/api_po_master_model.dart';
import 'package:eit/models/api/save_invoice/api_invoice_master_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

double totalPrice({required List<InvDetailsModel> invoiceItems}) {
  double _total = 0;
  for (InvDetailsModel item in invoiceItems) {
    _total += item.price ?? 0;
  }
  return _total;
}

double totalDiscount({required List<InvDetailsModel> invoiceItems}) {
  double _total = 0;
  for (InvDetailsModel item in invoiceItems) {
    _total += item.discount ?? 0;
  }
  return _total;
}

double totalVat({required List<InvDetailsModel> invoiceItems}) {
  double _total = 0;
  for (InvDetailsModel item in invoiceItems) {
    _total += item.vatAmount ?? 0;
  }
  return _total;
}

Future<void> printPOpreview(
    {InvMasterModel? invMaster,
    PoMasterModel? poMaster,
    bool vatIncluded = false,
    required List<InvDetailsModel> invoiceItems,
    required bool isPO}) async {
  String date = invMaster != null
      ? invMaster.invDate != null
          ? DateFormat('dd/MM/yyyy').format(invMaster.invDate!)
          : '-'
      : poMaster?.transDate != null
          ? DateFormat('dd/MM/yyyy').format(poMaster!.transDate!)
          : '-';
  Future<pw.Font> getArabicFont() async {
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<pw.Document> generateDocument() async {
    bool isArabic = false;
    final prefs = await SharedPreferences.getInstance();

    const key = 'language';
    String? value = prefs.getString(key);
    if (value == 'ar') {
      isArabic = true;
    } else if (value == 'en') {
      isArabic = false;
    } else {
      Get.deviceLocale;
    }
    final doc = pw.Document();
    final arabicFont = await getArabicFont();

    // Original headers and column widths
    final headers = [
      'Price'.tr,
      'Quantity'.tr,
      'Item'.tr,
    ];

    final data = invoiceItems.map((item) {
      return [
        item.price?.toStringAsFixed(2) ?? '',
        item.qty?.toStringAsFixed(2) ?? '',
        item.itemName ?? '',
      ];
    }).toList();

    doc.addPage(pw.Page(
      textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      build: (context) {
        return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: double.infinity,
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(5),
                  color: PdfColors.black,
                  child: pw.Text(isPO ? 'Purchase Order'.tr : 'Invoice'.tr,
                      style: pw.TextStyle(
                          fontSize: 24,
                          font: arabicFont,
                          color: PdfColors.white)),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                '''${'Serial:'.tr} ${invMaster == null ? poMaster?.transID ?? '-' : invMaster.serial ?? '-'}''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                            pw.Text('''${'Date:'.tr} $date''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                            pw.Text(
                                '''${'Customer Name:'.tr} ${invMaster == null ? poMaster?.custName ?? '-' : invMaster.custName ?? '-'}''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                          ]),
                      pw.SizedBox(width: 5),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                '''${invMaster == null ? 'PO No:'.tr : 'Invoice No:'.tr} ${invMaster == null ? poMaster?.transID ?? '-' : invMaster.serial ?? '-'}''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                            pw.Text(
                                '''${'Pay Type: '.tr} ${invMaster == null ? poMaster?.isCash == 1 ? 'Cash'.tr : 'Debit'.tr : invMaster.paymentType == 0 ? 'Cash'.tr : 'Debit'.tr}''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                            pw.Text(
                                '''${'Customer Code: '.tr} ${invMaster == null ? poMaster?.custCode ?? '-' : invMaster.custCode ?? '-'}''',
                                style: pw.TextStyle(
                                    fontSize: 18, font: arabicFont)),
                          ]),
                    ]),
                pw.Directionality(
                    child: pw.TableHelper.fromTextArray(
                      context: context,
                      headers: headers,
                      data: data,
                      border: pw.TableBorder.all(),
                      headerStyle: pw.TextStyle(
                          font: arabicFont, fontWeight: pw.FontWeight.bold),
                      cellStyle: pw.TextStyle(font: arabicFont),
                      cellAlignment: pw.Alignment.center,
                      rowDecoration:
                          const pw.BoxDecoration(color: PdfColors.white),
                      oddRowDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey100),
                      headerDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(3),
                      },
                    ),
                    textDirection: pw.TextDirection.rtl),
                invMaster != null
                    ? pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.Text(
                              '''${'Discount:'.tr} ${invMaster.discBefore?.toStringAsFixed(2) ?? '0'}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Text(
                              '''${'Tax:'.tr} ${invMaster.vat?.toStringAsFixed(2) ?? '0'}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Text(
                              '''${'Net Total:'.tr} ${invMaster.invAmount?.toStringAsFixed(2) ?? '0'}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Divider(),
                        ],
                      )
                    : pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          pw.Text(
                              '''${'Discount:'.tr} ${totalDiscount(invoiceItems: invoiceItems).toStringAsFixed(2)}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Text(
                              '''${'Tax:'.tr} ${totalVat(invoiceItems: invoiceItems).toStringAsFixed(2)}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Text(
                              '''${'Net Total:'.tr} ${((totalPrice(invoiceItems: invoiceItems) - totalDiscount(invoiceItems: invoiceItems)) + totalVat(invoiceItems: invoiceItems)).toStringAsFixed(2)}''',
                              style:
                                  pw.TextStyle(fontSize: 18, font: arabicFont)),
                          pw.Divider(),
                        ],
                      ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                      '''${'Notes: '.tr} ${invMaster == null ? poMaster?.transNotes ?? '' : invMaster.invNote ?? ''}''',
                      style: pw.TextStyle(fontSize: 18, font: arabicFont),
                      maxLines: 2,
                      textDirection: isArabic
                          ? pw.TextDirection.rtl
                          : pw.TextDirection.ltr,
                      overflow: pw.TextOverflow.clip),
                ),
                vatIncluded
                    ? pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('vat included'.tr,
                            style: pw.TextStyle(fontSize: 18, font: arabicFont),
                            maxLines: 2,
                            textDirection: isArabic
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                            overflow: pw.TextOverflow.clip),
                      )
                    : pw.SizedBox(),
              ],
            ));
      },
    ));

    return doc;
  }

  final doc = await generateDocument();

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}
