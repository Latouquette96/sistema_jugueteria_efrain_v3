import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';
import 'package:flutter/services.dart' show rootBundle;

///Clase BuilderPDF: Clase que permite construir PDFs de productos.
class BuilderPDF {

  ///BuilderPDF: Construye el pdf de acuerdo a la lista de productos dada.
  static Future<void> buildPDF(List<Product> list) async {
    var dataRegular = await rootBundle.load("fonts/OpenSans-Regular.ttf");
    var dataBold = await rootBundle.load("fonts/OpenSans-SemiBold.ttf");
    var dataBoldItalic = await rootBundle.load("fonts/OpenSans-SemiBoldItalic.ttf");
    var fontRegular = pw.Font.ttf(dataRegular);
    var fontBold = pw.Font.ttf(dataBold);
    var fontBoldItalic = pw.Font.ttf(dataBoldItalic);
    var styleTitle = pw.TextStyle(font: fontBoldItalic, fontSize: 13, color: PdfColor.fromRYB(0, 0, 0.9));
    var styleLabel = pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColor.fromRYB(1.0, 1.0, 1.0));
    var styleInfo = pw.TextStyle(font: fontRegular, fontSize: 10, color: PdfColor.fromRYB(1.0, 1.0, 1.0));
    var styleHeader = pw.TextStyle(font: fontBoldItalic, fontSize: 12 ,color: PdfColors.black);

    List<Product> listPDF = list;
    List<pw.Partition> listProductPDF = [];

    //Obtiene la imagen de preparacion para los casos en que no se pueda descargar la imagen.
    var buffer = await rootBundle.load("images/img_preparacion.png");
    var imageMemory = pw.MemoryImage(buffer.buffer.asUint8List());
    var imageTemp = pw.Image(imageMemory);
    
    //Crea un objeto documento.
    final pdf = pw.Document();

    //Para cada uno de los productos.
    for (int i=0; i<listPDF.length; i++){
      Product e = listPDF[i];
      //Image a insertar.
      // ignore: prefer_typing_uninitialized_variables
      var image;
      //Busca el archivo (si es que existe) del producto.
      File fileImg = File("${ConfigurationLocal.getInstance().getValue(ConfigurationLocal.getKeyImagePath())!}\\${listPDF[i].getFileName(0)}");
      if (await fileImg.exists()){
        //Obtiene la imagen del sistema de archivos.
        image = pw.MemoryImage(await fileImg.readAsBytes());
      }
      else{
        try{
          image = pw.Image(await networkImage(listPDF[i].getLinkImages()[0].getLink()));
        }
        catch(d){
          image = imageTemp;
        }
      }
       
      var styleStock = pw.TextStyle(font: fontRegular, fontSize: 11, color: _getColorStock(e.getStock()));

      List<pw.Row> listRow = [];
      listRow.add(pw.Row(children: [pw.Text(e.getTitle().toUpperCase(), style: styleTitle)]));
      listRow.add(pw.Row(children: [pw.Text("Código de barras: ", style: styleLabel), pw.Text(e.getBarcode() ?? e.getInternalCode() ?? "-", style: styleInfo)]));
      listRow.add(pw.Row(children: [pw.Text("Precio público: ", style: styleLabel), pw.Text("\$${e.getPricePublic().toStringAsFixed(2)}", style: styleInfo)]));
      listRow.add(pw.Row(children: [pw.Text("Stock: ", style: styleLabel), pw.Text(_getLabelStock(e.getStock()), style: styleStock)]));        
      listRow.addAll(
        e.getSizes().map((e) {
          return pw.Row(children: [pw.Text(e, style: styleLabel)]);
        },)
      );

      listProductPDF.add(
        pw.Partition(
        width: PdfPageFormat.a4.width-PdfPageFormat.a4.marginRight,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(5),
          color: i%2==0 ? PdfColor.fromRYB(0, 0.25, 0) : PdfColor.fromRYB(0, 0.35, 0),
          width: PdfPageFormat.a4.width,
          height: 135,
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
            children: [
              pw.Container(
                width: 125,
                height: 125,
                margin: const pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: image
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: listRow
              )
            ]
          )
        )
      ));
    }
    
    //Crea multples páginas
    pw.Page page = pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.fromLTRB(12.7, 0, 12.7, 0),
        //Formato de pagina
        pageFormat: PdfPageFormat.a4,
        //Constructor
        build: (pw.Context context) => listProductPDF,
        header: (pw.Context context){
          return pw.Container(
            margin: const pw.EdgeInsets.fromLTRB(12.7, 25, 12.7, 25),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Jugueteria Efrain - Catálogo de Productos*", style: styleHeader),
                pw.Text("Fecha: ${DatetimeCustom.getDatetimeStringNow()}", style: styleHeader)
              ]
            )
          );
        },
        footer: (pw.Context context){
          return pw.Container(
            height: 60,
            child: pw.Text("*El precio de los productos es válido durante todo el día. "
                "Luego de dicho periodo de tiempo, se debe pedir un nuevo catalogo de precios.",
                style: styleInfo)
          );
        }
    );

    pdf.addPage(page);

    String date = DatetimeCustom.getDatetimeStringNow();
    String name = date.replaceAll("/", "");
    name = name.replaceAll(":", "");
    
    final file = File("${ConfigurationLocal.getInstance().getValue(ConfigurationLocal.getKeyCatalogPath())}/$name.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  ///BuilderPDF: Construye el pdf de la venta realizada recibiendo un listado de Triple, donde contiene:
  ///Value1: Producto, Value2: Cantidad, Value3: Descuento/recargo aplicado.
  static Future<void> buildPDFShop(List<Triple<Product, int, double>> list) async {
    //Construccion de estilos y tipografias.
    var dataBold = await rootBundle.load("fonts/OpenSans-SemiBold.ttf");
    var dataBoldItalic = await rootBundle.load("fonts/OpenSans-SemiBoldItalic.ttf");
    var fontBold = pw.Font.ttf(dataBold);
    var fontBoldItalic = pw.Font.ttf(dataBoldItalic);
    var styleTitle = pw.TextStyle(font: fontBoldItalic, fontSize: 12 ,color: PdfColor.fromRYB(0, 0, 0.9));
    var styleHeader = pw.TextStyle(font: fontBoldItalic, fontSize: 12 ,color: PdfColors.black);
    var styleLabel = pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColor.fromRYB(1.0, 1.0, 1.0));

    String date = DatetimeCustom.getDatetimeStringNow();
    List<Triple<Product, int, double>> listPDF = list;
    final pdf = pw.Document();

    //Inicializacion de variables
    int current = -1;
    double subtotal = 0;
    double descuento = 0;
    double recargo = 0;
    int cantProducts = 0;

    List<pw.Partition> listProductPDF = listPDF.map((e){
      //Control de iterador de filas (para colorear)
      current++;
      //Control de total y cantidad de productos.
      cantProducts = cantProducts + e.getValue2()!;
      subtotal = subtotal + (e.getValue1().getPricePublic()*e.getValue2()!);
      if (e.getValue3()!<0){
        descuento = descuento + (e.getValue3()!*e.getValue2()!);
      }
      else{
        if (e.getValue3()!>0){
          recargo = recargo + (e.getValue3()!*e.getValue2()!);
        }
      }

      return pw.Partition(
          width: PdfPageFormat.a4.width-PdfPageFormat.a4.marginRight,
          child: pw.Container(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 0, 0),
              color: (current%2==0) ? PdfColors.amber50 : PdfColors.amber100,
              width: PdfPageFormat.a4.width,
              height: 25,
              child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                  pw.Container(
                        width: 75,
                        child:pw.Text(e.getValue1().getBarcode() ?? e.getValue1().getInternalCode() ?? "-", style: styleLabel)
                    ),
                  pw.Container(
                        width: 225,
                        child:pw.Text(e.getValue1().getTitle().toUpperCase().substring(0, (e.getValue1().getTitle().length<30) ? e.getValue1().getTitle().length : 30), style: styleLabel)
                    ),
                  pw.Container(
                        width: 50,
                        child:pw.Text("(${e.getValue2().toString()} un)", style: styleLabel)
                    ),
                  pw.Container(
                        width: 125,
                        child:pw.Text("\$${e.getValue1().getPricePublic().toStringAsFixed(2)} (\$${e.getValue3()!.toStringAsFixed(2)} un)", style: styleLabel)
                    ),
                  pw.Container(
                        width: 125,
                        child:pw.Text("\$${(e.getValue1().getPricePublic()*e.getValue2()!).toStringAsFixed(2)} (\$${(e.getValue3()!*e.getValue2()!).toStringAsFixed(2)})", style: styleLabel)
                    ),
                  ]
              )
          )
      );
    }).toList();

    //Crea multples páginas
    pw.Page page = pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.fromLTRB(12.7, 0, 12.7, 0),
        //Formato de pagina
        pageFormat: PdfPageFormat.a4,
        //Constructor
        build: (pw.Context context) => listProductPDF,
        header: (pw.Context context){
          return pw.Container(
              margin: const pw.EdgeInsets.fromLTRB(12.7, 25, 12.7, 25),
              child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                   pw.Text("Jugueteria Efrain - Detalle de la venta", style: styleHeader),
                   pw.Text("Fecha: $date", style: styleHeader)
                  ]
              )
          );
        },
      footer: (pw.Context context){
          return pw.Column(
            children: [
            pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  margin: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                  width: PdfPageFormat.a4.width,
                  height: 20,
                  child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.max,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                       pw.Text("CANTIDAD DE PRODUCTOS: $cantProducts", style: styleLabel),
                      ]
                  )
              ),
            pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  margin: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                  width: PdfPageFormat.a4.width,
                  height: 40,
                  child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.max,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                       pw.Text("SUBTOTAL: \$${subtotal.toStringAsFixed(2)}", style: styleTitle),
                       pw.Text("DESCUENTO: \$${descuento.toStringAsFixed(2)}", style: styleTitle),
                       pw.Text("RECARGO: \$${recargo.toStringAsFixed(2)}", style: styleTitle),
                       pw.Text("TOTAL: \$${(subtotal+recargo+descuento).toStringAsFixed(2)}", style: styleTitle),
                      ]
                  )
              )
            ]
          );
      }
    );

    pdf.addPage(page);

    String name = date.replaceAll("/", "");
    name = name.replaceAll(":", "");

    final file = File("${ConfigurationLocal.getInstance().getValue(ConfigurationLocal.getKeyCatalogPath())}/JugueteriaEfrain-$name.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  ///BuilderPDF: Devuelve el texto de acuerdo al stock.
  static String _getLabelStock(int stock) {
    String toReturn;
    if (stock==-1){
      toReturn = "Fuera de stock";
    }
    else{
      if (stock==0){
        toReturn = "Disponible por pedido";
      }
      else{
        toReturn ="$stock (en stock)";
      }
    }
    return toReturn;
  }

  ///BuilderPDF: Devuelve el color de acuerdo al stock.
  static PdfColor _getColorStock(int stock){
    PdfColor toReturn;
    if (stock==-1){
      toReturn = PdfColor.fromRYB(1.0, 0, 0);
    }
    else{
      if (stock==0){
        toReturn = PdfColor.fromRYB(1, 1, 1);
      }
      else{
        toReturn = PdfColor.fromRYB(0, 1, 1);
      }
    }
    return toReturn;
  }
}