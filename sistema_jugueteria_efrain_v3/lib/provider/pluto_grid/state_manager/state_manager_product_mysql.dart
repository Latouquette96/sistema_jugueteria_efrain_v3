import 'dart:convert';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/factory/factory_category_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/category_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/subcategory_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/fourfold.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_generic_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/code_generated/generated_code_controller.dart';

///Clase StateManagerProductMySQL: Sirve para administrar (sin provider) el catalogo de elementos.
class StateManagerProductMySQL extends StateManagerMySQL<Fourfold<Product, Distributor, double, String>, Product>{
  //Atributos de clases
  static final StateManagerProductMySQL _instance = StateManagerProductMySQL._(path: "/mysql/products");

  ///Constructor de StateManagerProductMySQL.
  StateManagerProductMySQL._({required super.path});

  ///StateManagerProductMySQL: Devuelve la instancia.
  static StateManagerProductMySQL getInstance(){
    return _instance;
  }

  @override
  Future<ResponseAPI> initialize(String url) async {
    //Elimina la lista de elementos.
    getElements().clear();
    ResponseAPI toReturn;

    try{
      List<Distributor> distributors = StateManagerDistributor.getInstance().getElements();

      final content = await APICall.get(url: url, route: "/mysql/products");

      List<Fourfold<Product, Distributor, double, String>> list = [];
      if (content.isResponseSuccess()){
        List<Product> listProducts = StateManagerProduct.getInstanceProduct().getElements();

        //Para cada fila de los resultados obtenidos.
        for (Map<String, dynamic> row in content.getValue()){
          //Recupera las tres coluumnas principales de la consulta.
          Map<String, dynamic> mapProductRow = jsonDecode(row['product']);
          Map<String, dynamic> mapProductPriceRow = jsonDecode(row['price_product']);

          //Construye el producto de acuerdo al producto de MySQL.
          Product productRow = buildElement(mapProductRow);
          //Bandera para comprobar si se inserta el fourfold o no.
          bool insertFourfold = false;

          //Si no hay productos actualmente en la base de datos, entonces insertar directamente.
          if (listProducts.isEmpty){
            insertFourfold = true;
          }
          else{
            //Se obtiene el producto existente de la lista o devuelve null.
            Product? productExisting = _isExistingProduct(listProducts, productRow);
            insertFourfold = (productExisting!=null) ? _isProductModified(productExist: productExisting, productMySQL: productRow) : true;
            if (insertFourfold) productRow.setID((productExisting!=null) ? productExisting.getID() : 0);
          }

          //Si se debe insertar fourfold, entonces...
          if (insertFourfold){
            //Si está definido el producto
            if (productRow.getBarcode()!="-" && productRow.getTitle()!="-" && productRow.getDescription()!="-"){
              //Si no está duplicado en la lista a insertar.
              if (list.indexWhere((element){ return _equals(produc1: element.getValue1(), product2: productRow); }) ==-1){

                //Obtener la distribuidora del producto.
                Distributor distributorRow = distributors.firstWhere(
                        (element){
                      return element.getCUIT().replaceAll('-', '').compareTo(row['d_cuit'].toString().replaceAll('-', ''))==0;},
                    orElse: () => distributors.first
                );

                productRow.buildPlutoRow();

                //Fourfold es una tripla de valores: (producto, distribuidora, precio_base)
                list.add(Fourfold<Product, Distributor, double, String>(
                    v1: productRow,
                    v2: distributorRow,
                    v3: double.tryParse(mapProductPriceRow['p_pricebase'].toString()),
                    v4: mapProductPriceRow['p_internal_code']
                ));
              }

            }
          }
        }
      }

      //Actualiza el estado.
      loadElements(list);
      //Notifica al catalogo.
      if (getStateManager()!=null){
        getStateManager()!.insertRows(0, getElements().map((e) => e.getValue1().getPlutoRow()).toList());
      }

      toReturn = content;
    }
    catch(e){
      toReturn = ResponseAPI.getProblemOccurredMessage();
    }

    return toReturn;
  }

  ///ImportProductMySQLProvider: Dada una lista de productos, comprueba si un producto (de un determinado código) pertenece a la lista y retorna el elemento de la lista.
  ///
  ///[listProduct] Lista de productos.
  ///[productMySQL] Producto proveniente de MySQL.
  Product? _isExistingProduct(List<Product> listProduct, Product productMySQL){
    Product product = listProduct.firstWhere((element){
      return (
          (element.getBarcode()==productMySQL.getBarcode())
      );
    },
      orElse: (){
        return Product.clean();
      },);

    Product? toReturn = (product.getID()==0) ? null : product;
    return toReturn;
  }

  ///ImportProductMySQLProvider: Dado un producto existente y uno de mysql, comprueba si difieren en algún campo y devuelve True en caso afirmativo, de lo contrario, retorna False.
  ///
  ///[productExist] Producto existente.
  ///[productMySQL] Producto proveniente de MySQL.
  bool _isProductModified({required Product productExist, required Product productMySQL}){
    return (
        productExist.getBarcode()!=productMySQL.getBarcode() ||
            productExist.getTitle()!=productMySQL.getTitle() ||
            productExist.getBrand()!=productMySQL.getBrand() ||
            productExist.getDescription()!=productMySQL.getDescription() ||
            productExist.getStock()!=productMySQL.getStock() ||
            productExist.getPricePublic()!=productMySQL.getPricePublic() ||
            productExist.getMinimumAge()!=productMySQL.getMinimumAge() ||
            productExist.getSizes().toString()!=productMySQL.getSizes().toString() ||
            (productExist.getLinkImages().toList().map<String>((e) => e.getLink()).toList().toString())!=(productMySQL.getLinkImages().toList().map<String>((e) => e.getLink()).toList().toString())
    );
  }

  ///ImportProductMySQLProvider: Comprueba si dos productos tienen la misma información relevante.
  ///
  ///[produc1] Producto existente.
  ///[product2] Producto proveniente de MySQL.
  bool _equals({required Product produc1, required Product product2}){
    return (
        produc1.getBarcode()==product2.getBarcode() &&
            produc1.getTitle()==product2.getTitle() &&
            produc1.getBrand()==product2.getBrand() &&
            produc1.getPricePublic()==product2.getPricePublic()
    );
  }

  @override
  Future<ResponseAPI> import(String url, List<Fourfold<Product, Distributor, double, String>> imports) async {
    ResponseAPI toReturn;

    try{
      final List<Fourfold<Product, Distributor, double, String>> listImport = imports;
      int i=0;
      int errors = 0;

      int total = listImport.length;
      List<Fourfold<Product, Distributor, double, String>> listRemove = [];

      while(i<total){
        Fourfold<Product, Distributor, double, String> fourfold = listImport[i];

        //Realiza la petición POST para insertar el producto.
        final response = (fourfold.getValue1().getID()==0)
            ? await APICall.post(
          url: url,
          route: '/products',
          body: fourfold.getValue1().getJSON(),
        )
        : await APICall.put(
            url: url,
            route: '/products/${fourfold.getValue1().getID()}',
            body: fourfold.getValue1().getJSON(),
          );

        //Si la respuesta fue exitosa
        if (response.isResponseSuccess()){
          //Si ademas el producto en cuestion se trataba de un producto nuevo, entonces se carga su respectivo
          if (fourfold.getValue1().getID()==0){
            //Establece el id obtenido del producto insertado
            fourfold.getValue1().setID(response.getValue()['p_id']);

            //Comprueba si es un código generado.
            if (GeneratedCodeController.isGenerateCode(fourfold.getValue1().getBarcode())){
              GeneratedCodeController.reserveGeneratedCode(url, fourfold.getValue1(), fourfold.getValue1().getBarcode());
            }

            final productPrice = ProductPrice(
              id: 0,
              internalCode: fourfold.getValue4(),
              p: fourfold.getValue1().getID(),
              d: fourfold.getValue2()!.getID(),
              price: fourfold.getValue3() ?? 0,
              date: DatetimeCustom.parseStringDatetime(fourfold.getValue1().getDateUpdate())
            );

            //Envio la solicitud POST para cargar
            await APICall.post(
              url: url, route: '/products/prices_products',
              body: productPrice.getJSON(),
            );
          }

          listRemove.add(fourfold);
        }
        else{
          errors++;
        }
        i++;
      }

      //Elimina todas las filas de productos removidos.
      getStateManager()!.removeRows(listRemove.map((e) => e.getValue1().getPlutoRow()).toList());
      //Elimina de la lista de importacion los productos importados.
      listImport.removeWhere((element) => listRemove.contains(element));
      //Limpia la lista de eliminados
      listRemove.clear();

      toReturn = ResponseAPI.manual(
        status: (errors==0) ? 200 : 501,
        value: null,
        title: (errors==0) ? "Importación exitosa" : "Error 501",
        message: (errors==0)
        ? "La importación de productos del Sistema v2 fue realizada con éxito."
            : "Error: ${ (errors<listImport.length) ? "Se importaron ${listImport.length-errors} productos." : "No se importó ningún producto del Sistema v2."}"
        );
    }
    catch(e){
      toReturn = ResponseAPI.manual(
        status: 404,
        value: null,
        title: "Error 404",
        message: "Error: No se pudo llevar a cabo la importación de productos del Sistema v2."
      );
    }

    return toReturn;
  }

  @override
  Product buildElement(Map<String, dynamic> data) {
    try{
      //Buscar categoria y subcategoria
      FactoryCategory factoryCategory = FactoryCategory.getInstance();
      FactoryCategoryMySQL factoryCategoryMySQL = FactoryCategoryMySQL.getInstance();

      CategoryMySQL categoryMySQL = factoryCategoryMySQL.searchKeyForID(data['p_category']);
      SubCategoryMySQL subCategoryMySQL = categoryMySQL.getListSubCategoryMySQL().firstWhere(
            (element) => element.getID()==data['p_subcategory'],
        orElse: () => categoryMySQL.getListSubCategoryMySQL().first,
      );

      Category  cat = factoryCategory.searchKeyForID(categoryMySQL.getCategoryMySQLNewID());
      SubCategory subCategory = cat.getListSubcategory().firstWhere(
            (element) => element.getSubCategoryIDGoogle()==subCategoryMySQL.getNewID(),
        orElse: () =>cat.getListSubcategory().first,
      );

      //Crea un producto limpio.
      Product product = Product.clean();

      //Construcción de la lista de medidas.
      List<String> listSize = [];
      if (data['p_sizeproduct']!=null){
        listSize.add("Medida (producto): ${data['p_sizeproduct']}");
      }
      if (data['p_sizeblister']!=null){
        listSize.add("Medida (blister): ${data['p_sizeblister']}");
      }

      //Construcción del mapeo.
      Map<String, dynamic> map = {
        Product.getKeyID():           0, //Asume producto nuevo
        Product.getKeyBarcode():      data['p_codebar'],
        Product.getKeyTitle():        data['p_title'],
        Product.getKeyDescription():  data['p_description'],
        Product.getKeyBrand():        data['p_brand'] ?? "IMPORT.",
        Product.getKeyPricePublic():  double.parse(data['p_pricepublic'].toString()),
        Product.getKeyStock():        data['p_stock'],
        Product.getKeySubcategory():  ConvertCategory.getIDCategory(cat.getCategoryID(), subCategory.getSubCategoryID()),
        //Construye una cadena con todos los elementos de la lista separados por ','.
        Product.getKeyImages():       data['p_linkimage'],
        Product.getKeySizes():        listSize.join(','),
        Product.getKeyDateCreated():  data['p_datecreated'],
        Product.getKeyDateUpdated():  data['p_dateupdated'],
        Product.getKeyMinimumAge():   data['p_minimumage']
      };

      //Carga el mapeo en el producto y lo retorna.
      product.fromJSONServer(map);
      return product;
    }
    catch(e){
      return Product.clean();
    }
  }
}