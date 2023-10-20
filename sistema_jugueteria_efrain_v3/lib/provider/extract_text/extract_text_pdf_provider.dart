import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/extract_data/data_fragment.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
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
        List<String> listFragments = content.getValue().split("\n");

        //Para cada fragmento de texto de
        for (var fragment in listFragments) {

          //Se crea un objeto DataFragment con el fin de almacenar el texto fragment junto a los posibles productos a que se refiere.
          DataFragment dataFragment = DataFragment(fragment: fragment);

          //Para cada producto, se comprueba si es candidato.
          for (Product product in listProducts){

            //Para el código de barra, se comprueba si dicho codebar está incluido en el fragmento.
            if (product.getBarcode()!=null && fragment.contains(product.getBarcode()!)){
              dataFragment.insertMatchBarcode(product);
            }

            //Para el titulo del producto, si algún trozo del titulo está contenido en fragmento, se inserta el producto.
            if (_isContainsTItleInFragment(fragment, product)){
              dataFragment.insertMatchTitle(product);
            }
          }

          if (dataFragment.isWithoutProducts()==false){
            state.add(dataFragment);
          }
        }
      }

    }
    catch(e){
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los datos del servidor.");
      state = [];
    }

    return content;
  }

  ///DataFragement: Comprueba si alguna palabra del titulo del producto está contenido en el fragmento.
  bool _isContainsTItleInFragment(String fragment, Product product){
    String nameProduct = product.getTitle().replaceAll("-", "");
    nameProduct = nameProduct.replaceAll("\"", "");
    nameProduct = nameProduct.replaceAll(":", "");
    nameProduct = nameProduct.replaceAll(",", "");
    nameProduct = nameProduct.replaceAll(";", "");
    nameProduct = nameProduct.replaceAll(";", "");
    nameProduct = nameProduct.replaceAll("!", "");
    nameProduct = nameProduct.replaceAll("¡", "");
    nameProduct = nameProduct.replaceAll("?", "");
    nameProduct = nameProduct.replaceAll("¿", "");

    List<String> titleSplit = nameProduct.split(" ");
    titleSplit.removeWhere((element) => element.isEmpty || element=="" || element.length<=3);
    int matchs = 0;

    for (int i=0; i<titleSplit.length; i++){
      if (fragment.toUpperCase().contains(titleSplit[i].toUpperCase())){
        matchs++;
      }
    }

    return matchs>=2;
  }
}

final extractTextFromPDFProvider = StateNotifierProvider<TextFromPDFProvider, List<DataFragment>>((ref) => TextFromPDFProvider([], ref: ref));