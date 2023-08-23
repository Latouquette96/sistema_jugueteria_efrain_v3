import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Clase PDFViewControllerProvider: Proveedor de servicios para almacenar el estado de un producto.
class PDFViewControllerProvider extends StateNotifier<PdfViewerController> {
  PDFViewControllerProvider(): super(PdfViewerController());

  ///PDFViewControllerProvider: Refrezca el controlador.
  void initialize(){
    state = PdfViewerController();
  }

  void disposeController(){
    state.dispose();
  }
}

///pdfViewControllerProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfViewControllerProvider = StateNotifierProvider<PDFViewControllerProvider, PdfViewerController>((ref) => PDFViewControllerProvider());


///Clase PdfTextSearchResultProvider: Proveedor de servicios para almacenar el estado de un producto.
class PdfTextSearchResultProvider extends StateNotifier<PdfTextSearchResult?> {
  //Atributos de instancia
  final StateNotifierProviderRef<PdfTextSearchResultProvider, PdfTextSearchResult?> ref;

  PdfTextSearchResultProvider(this.ref): super(null);

  ///PdfTextSearchResultProvider: Limpiar el resultado.
  void free(){
    state = null;
  }

  ///PdfTextSearchResultProvider: Buscar el producto.
  void search(Product p){
      //state = ref.read(pdfViewControllerProvider).searchText(p.getBarcode() ?? p.getInternalCode() ?? "");
      PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider).searchText(p.getBrand());
      textSearchResult.addListener(() {
        //Si se ha obtenido el resultado.
        if (textSearchResult.hasResult){
          //Si se ha realizado la busqueda en todo el archivo.
          if (textSearchResult.isSearchCompleted){
            //Actualizar el estado.
            state = textSearchResult;
            //Si aparece el texto buscado, entonces mostrar el producto.
            if (textSearchResult.totalInstanceCount>0){
              ref.read(productSearchPDFPriceProvider.notifier).load(p);
            }
          }
        }
      });
  }
  
  void next(){
    state!.nextInstance();
  }
}

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfTextSearchResultProvider = StateNotifierProvider<PdfTextSearchResultProvider, PdfTextSearchResult?>((ref) => PdfTextSearchResultProvider(ref));

