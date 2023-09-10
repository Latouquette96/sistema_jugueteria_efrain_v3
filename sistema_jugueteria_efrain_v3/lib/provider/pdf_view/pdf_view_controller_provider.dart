import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///pdfViewControllerProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfViewControllerProvider = StateNotifierProvider<ElementStateProvider<PdfViewerController>, PdfViewerController?>((ref) => ElementStateProvider.initialize(PdfViewerController()));

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
    if ( ref.read(pdfViewControllerProvider)!=null) {
      PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider)!.searchText(p.getBarcode() ?? p.getInternalCode() ?? "");
      //PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider).searchText(p.getBrand());
      textSearchResult.addListener(() {
        //Si se ha obtenido el resultado.
        if (textSearchResult.hasResult) {
          //Si se ha realizado la busqueda en el archivo completo.
          if (textSearchResult.isSearchCompleted) {
            //Actualizar el estado.
            state = textSearchResult;
            //Si aparece el texto buscado, entonces mostrar el producto.
            if (textSearchResult.totalInstanceCount > 0) {
              ref.read(productPricesPDFByIDProvider.notifier).refresh();
              ref.read(productSearchPDFPriceProvider.notifier).load(p);
            }
          }
        }
      });
    }
  }

  ///PdfTextSearchResultProvider: Obtiene la próxima instancia del estado.
  void next(){
    state!.nextInstance();
  }
}

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfTextSearchResultProvider = StateNotifierProvider<PdfTextSearchResultProvider, PdfTextSearchResult?>((ref) => PdfTextSearchResultProvider(ref));

