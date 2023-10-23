import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/extract_data/data_fragment.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase TextFromPDFProvider: Provider que permite almacenar el texto leido de un pdf.
class TextFromPDFProvider extends StateNotifier<List<DataFragment>> {
  late final StateNotifierProviderRef<TextFromPDFProvider, List<DataFragment>> _ref;
  late final String _path;

  ///Constructor TextFromPDFProvider.
  ///
  ///[ref] Referencia al provider que notifica el estado.
  TextFromPDFProvider(
      super.state,
      {
        required StateNotifierProviderRef<TextFromPDFProvider, List<DataFragment>> ref
      }
      ){
    _ref = ref;
    _path = "/services/extract_text_pdf";
  }


  ///TextFromPDFProvider: Realiza la extracción del texto del PDF indicado por parámetro y almacena el texto en el estado.
  Future<ResponseAPI> extractText(String pathPDF, List<Product> listProducts) async {
    //Obtiene la URL a la API.
    String url = _ref.read(urlAPIProvider);
    ResponseAPI content;

    //Si hay elementos, entonces se remueven todos.
    if (state.isNotEmpty){
      state.clear();
    }

    try{
      content = await APICall.get(url: url, route: "$_path/$pathPDF");

      if (content.isResponseSuccess()){
        //Convierte el contenido de la respuesta en una lista de fragmentos de texto.
        List<String> listText = content.getValue().split("\n");
        List<DataFragment> listFragments = listText.map((e){
          return DataFragment(fragment: e);
        }).toList();

        for (Product product in listProducts){
          List<ProductPrice> listProductPrice = [];

          ResponseAPI responseProductPrice = await APICall.get(url: url, route: "/products/prices_products/${product.getID()}");
          if (responseProductPrice.isResponseSuccess()){
            List<dynamic> map = responseProductPrice.getValue();
            listProductPrice = map.map((e){
              return ProductPrice.fromJSON(e);
            }).toList();
          }

          for (DataFragment fragment in listFragments){
            //Para el código de barra, se comprueba si dicho codebar está incluido en el fragmento.
            if (product.getBarcode()!=null && product.getBarcode()!="-" && fragment.isContains(product.getBarcode()!)){
              fragment.insertMatchBarcode(product);
            }

            if (listProductPrice.isNotEmpty){
              //Para algun código interno del producto
              if (_isContainsInternalCodeInFragment(fragment, listProductPrice)){
                fragment.insertMatchInternalCode(product);
              }
            }
          }
        }

        List<DataFragment> list = listFragments.where((element) => element.isWithoutProducts()==false).toList();
        state = [...list];
      }
    }
    catch(e){
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los datos del servidor.");
      state = [];
    }

    return content;
  }

  ///DataFragement: Comprueba si algun código interno está en el fragmento.
  bool _isContainsInternalCodeInFragment(DataFragment fragment, List<ProductPrice> productPrices){
    int matchs = 0;

    List<String> listSplit = fragment.getFragment().toUpperCase().split(" ");
    listSplit.removeWhere((element) => element.contains(",") || element.contains("*") || element.isEmpty || element=="");

    List<ProductPrice> listPrice = productPrices.where((element) => element.getInternalCode()!=null).toList();

    for (ProductPrice ic in listPrice){
      for (String str in listSplit){
        if (ic.getInternalCode()!.toUpperCase()!="" && str.contains(ic.getInternalCode()!.toUpperCase())){
          matchs++;
        }
      }
    }

    return matchs>=1;
  }
}

///extractTextFromPDFProvider es un provider que permite almacenar en su estado interno una lista de DataFragment con productos.
final extractTextFromPDFProvider = StateNotifierProvider<TextFromPDFProvider, List<DataFragment>>((ref) => TextFromPDFProvider([], ref: ref));