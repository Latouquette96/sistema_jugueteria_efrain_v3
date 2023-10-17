import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase TextFromPDFProvider: Provider que permite almacenar el texto leido de un pdf.
class TextFromPDFProvider extends StateNotifier<List<String>> {
  late final StateNotifierProviderRef<TextFromPDFProvider, List<String>> _ref;
  late final String _path;

  ///Constructor CatalogStateSimpleNotifier.
  ///
  ///[ref] Referencia al provider que notifica el estado.
  TextFromPDFProvider(
      super.state,
      {
        required StateNotifierProviderRef<TextFromPDFProvider, List<String>> ref
      }
      ){
    _ref = ref;
    _path = "/services/extract_text_pdf";
  }


  ///CatalogStateSimpleNotifier: Recarga los cambios en el catalogo.
  Future<ResponseAPI> extractText(String pathPDF) async {
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
        //Convierte los datos obtenidos en una lista de objetos json (mapeos).
        List<String> map = content.getValue().split("\n");
        print(map.length);

        //Para cada elemento del mapeo, se lo inserta en la lista.
        for (var e in map) {
          state.add(e);
        }
      }

    }
    catch(e){
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los datos del servidor.");
      state = [];
    }

    return content;
  }
}

final extractTextFromPDFProvider = StateNotifierProvider<TextFromPDFProvider, List<String>>((ref) => TextFromPDFProvider([], ref: ref));