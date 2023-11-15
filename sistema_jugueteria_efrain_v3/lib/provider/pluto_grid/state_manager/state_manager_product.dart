import 'package:sistema_jugueteria_efrain_v3/controller/services/export_to_drive.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_generic.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/code_generated/generated_code_controller.dart';

///Clase StateManagerProduct: Sirve para administrar (sin provider) el catalogo de elementos.
class StateManagerProduct extends StateManager<Product>{
  //Atributos de clases
  static final StateManagerProduct _instanceProduct = StateManagerProduct._(path: "/products");
  static final StateManagerProduct _instancePDF = StateManagerProduct._(path: "/products");
  static final StateManagerProduct _instancePDFAdvanced = StateManagerProduct._(path: "/products");

  ///Constructor de StateManagerProduct.
  StateManagerProduct._({required super.path});

  ///StateManagerProduct: Devuelve la instancia.
  static StateManagerProduct getInstanceProduct(){
    return _instanceProduct;
  }

  static StateManagerProduct getInstanceProductPDF(){
    return _instancePDF;
  }

  static StateManagerProduct getInstanceProductPDFAdvanced(){
    return _instancePDFAdvanced;
  }

  @override
  Future<ResponseAPI> initialize(String url) async {
    //Elimina la lista de elementos.
    loadElements([]);
    //Respuesta a retornar.
    ResponseAPI response;

    try{
      //Obtiene la respuesta a la solicitud http.
      response = await APICall.get(url: url, route: getPath());
      
      if (response.isResponseSuccess()){
        List<Product> elements = buildElement(response.getValue());
        loadElements(elements);

        //Notifica al catalogo.
        if (getStateManager()!=null){
          getStateManager()!.insertRows(0, getElements().map((e) => e.getPlutoRow()).toList());
        }
      }
    }
    catch(e){
      response = ResponseAPI.manual(
          status: 404, 
          value: null, 
          title: "Error 404", 
          message: "Error: No se pudo recuperar los datos del servidor."
      );
    }

    return response;
  }

  @override
  Future<ResponseAPI> insert(String url, Product element) async {
    //Realiza la petición POST para insertar el producto.
    ResponseAPI responseAPI = await APICall.post(
        url: url,
        route: '/products',
        body: element.getJSON()
    );

    if (responseAPI.isResponseSuccess()){
      List<dynamic> json = responseAPI.getValue();
      element.setID(json[0]['p_id']);

      //Refrezca las marcas cargadas.
      //await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
      //Actualiza el catalogo de Google Drive
      ExportToDrive.getInstance().updateSheets(element);
      //Inserta el nuevo producto

      //Si hay un código que fue generado.
      if (GeneratedCodeController.getInstance().getGenerateCode()!=null){
        if (GeneratedCodeController.isGenerateCode(element.getBarcode())){
          await GeneratedCodeController.getInstance().reserveCode(url, element);
        }
      }

      //Inserta el nuevo registro por el actualizado.
      getStateManager()!.insertRows(0, [element.getPlutoRow()]);
      insertElement(element);
    }

    return responseAPI;
  }

  @override
  Future<ResponseAPI> remove(String url, Product element) async {
    final product = element;

    //Realiza la petición POST para insertar el producto.
    ResponseAPI responseAPI = await APICall.delete(
      url: url,
      route: '/products/${product.getID()}',
    );

    if (responseAPI.isResponseSuccess()){
      //Elimino del archivo de Google Drive
      //await ExportToDrive.getInstance().removeSheets(element);
      product.setBarcode("-1");

      //Refrezca las marcas cargadas.
      //await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();

      //Remueve el producto de la lista
      getStateManager()!.removeRows([product.getPlutoRow()]);
      removeElement(product);
    }

    return responseAPI;
  }

  @override
  Future<ResponseAPI> update(String url, Product element) async {
    //Realiza la petición POST para insertar el producto.
    ResponseAPI responseAPI = await APICall.put(
        url: url,
        route: '/products/${element.getID()}',
        body: element.getJSON()
    );

    if (responseAPI.isResponseSuccess()){

      //Si hay un código que fue generado.
      if (GeneratedCodeController.getInstance().getGenerateCode()!=null){
        if (GeneratedCodeController.isGenerateCode(element.getBarcode())){
          await GeneratedCodeController.getInstance().reserveCode(url, element);
        }
      }

      getStateManager()!.setShowLoading(true);

      Future.delayed(const Duration(milliseconds: 500), () {
        element.updatePlutoRow();
        getStateManager()!.setShowLoading(false);
      });

      //Actualiza el catalogo de Google Drive
      //await ExportToDrive.getInstance().updateSheets(element);
      //Refrezca las marcas cargadas.
      //await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    }

    return responseAPI;
  }

  @override
  List<Product> buildElement(List<dynamic> list) {
    return list.map((e) => Product.fromJSON(e)).toList();
  }
}