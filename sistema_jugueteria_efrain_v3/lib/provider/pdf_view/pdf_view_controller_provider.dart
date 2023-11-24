import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/*
** Providers para almacenar el controlador gráfico del pdfView.
*/

///pdfViewControllerProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfViewControllerProvider = StateNotifierProvider<ElementStateProvider<PdfViewerController>, PdfViewerController?>((ref) => ElementStateProvider.initialize(PdfViewerController()));

final pdfExtractTextViewControllerProvider = StateNotifierProvider<ElementStateProvider<PdfViewerController>, PdfViewerController?>((ref) => ElementStateProvider.initialize(PdfViewerController()));

/*
** Clase para la busqueda de palabras en el controlador pdf.
*/

///Clase PdfTextSearchResultProvider: Proveedor de servicios para almacenar la busca de un elemento en un objeto pdf.
class PdfTextSearchResultProvider<E> extends StateNotifier<PdfTextSearchResult?> {
  //Atributos de instancia
  late final PdfTextSearchResult? Function(E element) _searchText;

  ///Constructor PdfTextSearchResultProvider
  PdfTextSearchResultProvider({
    required PdfTextSearchResult? Function(E element) searchText
  }): super(null){
    _searchText = searchText;
  }

  ///PdfTextSearchResultProvider: Limpiar el resultado.
  void free(){
    state = null;
  }

  ///PdfTextSearchResultProvider: Buscar el producto.
  void search(E e){
    state = _searchText.call(e);
  }

  ///PdfTextSearchResultProvider: Obtiene la próxima instancia del estado.
  void next(){
    state!.nextInstance();
  }
}

/*
** Providers para la busqueda de texto en el controlador de pdf.
*/

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfTextSearchResultProvider = StateNotifierProvider<PdfTextSearchResultProvider<Product>, PdfTextSearchResult?>((ref) {
  return PdfTextSearchResultProvider<Product>(
    searchText: (Product element) {
      PdfTextSearchResult? toReturn;
      //Si el controlador de pdf no es nulo.
      if (ref.read(pdfViewControllerProvider)!=null){
        PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider)!.searchText(element.getBarcode());
        //PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider).searchText(p.getBrand());
        textSearchResult.addListener(() {
          //Si se ha obtenido el resultado.
          if (textSearchResult.hasResult) {
            //Si se ha realizado la busqueda en el archivo completo.
            if (textSearchResult.isSearchCompleted) {
              //Actualizar el estado.
              toReturn = textSearchResult;
            }
          }

          //Mostrar el producto.
          ref.read(productPricesPDFByIDProvider.notifier).refresh();
          ref.read(productSearchPDFPriceProvider.notifier).load(element);
        });
      }
      return toReturn;
    },
  );
});

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final pdfExtractTextTextSearchResultProvider = StateNotifierProvider<PdfTextSearchResultProvider<Product>, PdfTextSearchResult?>((ref) {
  return PdfTextSearchResultProvider<Product>(
    searchText: (Product element) {
      PdfTextSearchResult? toReturn;
      //Si el controlador de pdf no es nulo.
      if (ref.read(pdfExtractTextViewControllerProvider)!=null){
        PdfTextSearchResult textSearchResult = ref.read(pdfExtractTextViewControllerProvider)!.searchText(element.getBarcode());
        //PdfTextSearchResult textSearchResult = ref.read(pdfViewControllerProvider).searchText(p.getBrand());
        textSearchResult.addListener(() {
          //Si se ha obtenido el resultado.
          if (textSearchResult.hasResult) {
            //Si se ha realizado la busqueda en el archivo completo.
            if (textSearchResult.isSearchCompleted) {
              //Actualizar el estado.
              toReturn = textSearchResult;
              //Si aparece el texto buscado, entonces mostrar el producto.
              if (textSearchResult.totalInstanceCount > 0) {
                ref.read(productPricesPDFByIDProvider.notifier).refresh();
                ref.read(productSearchPDFPriceProvider.notifier).load(element);
              }
            }
          }
        });
      }
      return toReturn;
    },
  );
});