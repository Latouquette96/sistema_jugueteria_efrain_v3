import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/factory/factory_category_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/category_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/subcategory_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/category_model.dart';

///Clase ConvertFromMySQL
class ConvertFromMySQL {

  ///ConvertFromMySQL: Devuelve el producto almacenado en el mapeo.
  static Product getProductFromMySQL(Map<String, dynamic> data){
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
      Product.getKeyInternalCode(): data['p_internal_code'],
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

  ///ConvertFromMySQL: Devuelve la distribuidora almacenada en el mapeo.
  static Distributor getDitributorFromMySQL(Map<String, dynamic> data){
    try{
      //Crea un producto limpio.
      Distributor distributor = Distributor();
      //Construcción del mapeo.
      Map<String, dynamic> map = {
        Distributor.getKeyID():       data['d_id'],
        Distributor.getKeyName():     data['d_name'],
        Distributor.getKeyAddress():  data['d_direction'],
        Distributor.getKeyCUIT():     data['d_cuit'],
        Distributor.getKeyIVA():      1.00,
        Distributor.getKeyCel():      data['d_phone'],
        Distributor.getKeyEmail():    data['d_email'],
        Distributor.getKeyWebsite():  null,
      };

      //Carga el mapeo en el producto y lo retorna.
      distributor.fromJSON(map);
      return distributor;
    }
    catch(e){
      return Distributor();
    }
  }
}