import 'dart:async';
import 'dart:io';

// import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfController extends ChangeNotifier {
  savePdfInDevice(var bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Output.pdf');
  }

  Future<void> createPDF(
    List<MedicineModel> medicineList,
    List<String> adviceList,
  ) async {
    //Creates a new PDF document
    PdfDocument document = PdfDocument();

//Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 10;

//Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = Rect.fromLTWH(0, 10, graphics.clientSize.width, 100);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont titleFont = PdfStandardFont(
      PdfFontFamily.timesRoman,
      16,
      style: PdfFontStyle.bold,
    );
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);
    PdfFont paraFont = PdfStandardFont(PdfFontFamily.timesRoman, 11);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(
        text: 'VAMS VETERINARY CONSULTANCY', font: subHeadingFont);

    String address =
        'Anayara P.O. Trivandram -695011\nPhone - 9895678145\nEmail - contactvetnaryara@gmail.com\nwebsite - www.vetnaryara.com';

    element.brush = PdfBrushes.white;
    PdfImage image = PdfBitmap.fromBase64String(
        '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');

//Draws the image to the PDF page
    page.graphics.drawImage(image, Rect.fromLTWH(10, bounds.top + 8, 0, 0));

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(100, bounds.top + 8, 0, 0))!;

    graphics.drawString(address, paraFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(100, bounds.top + 30, 0, 0));

//Use 'intl' package for date format.
    String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
      text: 'PRESCRIPTION',
      font: PdfStandardFont(
        PdfFontFamily.timesRoman,
        16,
        style: PdfFontStyle.bold,
      ),
    );
    //Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 1),
        Offset(0, result.bounds.bottom + 98),
        Offset(graphics.clientSize.width, result.bounds.bottom + 98));
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 1),
        Offset(0, result.bounds.bottom + 120),
        Offset(graphics.clientSize.width, result.bounds.bottom + 120));

    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH((graphics.clientSize.width / 2) - 60,
            result.bounds.bottom + 100, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

    element = PdfTextElement(
      text:
          'Name - Tanmoy karmakar\nAddress - Subhaspally,Siliguri,\nPin - 734001 ',
      font: timesRoman,
    );
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(text: 'GSTIN  :  QUA343434AN', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom, 0, 0))!;
// "Invoice No :  001\nMTL. NO : 000545\nRef Doctor : Dr. SURYAMARYA JOSEPH"
    element = PdfTextElement(
        text:
            "Invoice No :  001\nMTL. NO : 000545\nRef Doctor : Dr. SURYAMARYA JOSEPH",
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(graphics.clientSize.width / 2, 160, 0, 0))!;

//Draws a line at the bottom of the address
    // graphics.drawLine(
    //     PdfPen(PdfColor(126, 151, 173), width: 0.7),
    //     Offset(0, result.bounds.bottom + 3),
    //     Offset(graphics.clientSize.width, result.bounds.bottom + 3));

    //Creates a PDF grid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 6);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'SL NO';
    header.cells[1].value = 'NAME OF MEDICINE';
    header.cells[2].value = 'USAGE';
    header.cells[3].value = 'MORNING';
    header.cells[4].value = 'NOON';
    header.cells[5].value = 'EVENING';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
        style: PdfFontStyle.regular);

//Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

    for (var i = 0; i < medicineList.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = (i + 1).toString();
      row.cells[1].value = medicineList[i].productName;
      row.cells[2].value = medicineList[i].productType;
      row.cells[3].value = "YES";
      row.cells[4].value = '';
      row.cells[5].value = "YES";
    }

//Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    gridResult.page.graphics.drawString('ADVICE & FOLLOW UP', titleFont,
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + 30, 0, 0));

    // gridResult.page.graphics.drawString(
    //     'Thank you for your business', subHeadingFont,
    //     brush: PdfBrushes.black,
    //     bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + 60, 0, 0));

    PdfOrderedList advice = PdfOrderedList(
        items: PdfListItemCollection(<String>[...adviceList]),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 14,
            style: PdfFontStyle.regular),
        indent: 10,
        format: PdfStringFormat(lineSpacing: 5));

    advice.draw(
        page: page,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + 60,
            graphics.clientSize.width, graphics.clientSize.height - 100));

    List<int> bytes = document.save();
    if (Platform.isIOS || Platform.isAndroid) {
      savePdfInDevice(bytes);
    }
    document.dispose();
  }
}
