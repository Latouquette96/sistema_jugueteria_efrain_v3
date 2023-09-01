import 'package:mysql1/mysql1.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_category.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase ProductMySQL: Tiene la finalidad de representar un producto.
class ProductMySQL{
  late final String _pCodebar;
  late final String? _pInternalCode;
  late final String _pTitle;
  late final String _pBrand;
  late final String _pDescription;
  late final List<String> _pSize;
  late final int _pStock;
  late final double _pPricePublic;
  late final List<String> _pLinkImage;
  late final int _pDateUpdate;
  late final int _pDateCreate;
  late final int _pMinimumAge;
  late final int _pSubCategory;

  ///Constructor de ProductMySQL: Construye un producto de acuerdo a un ResultRow (MySQL)
  ProductMySQL.loadResultRow(ResultRow data){
    _pCodebar = data['p_codebar'];
    _pInternalCode = data['p_internal_code'];
    _pTitle = data['p_title'];
    _pBrand= data['p_brand'] ?? "IMPORT.";
    _pDescription = data['p_description'];

    //Construcción de la lista de medidas.
    List<String> listSize = []; 
    if (data['p_sizeproduct']!=null){
      listSize.add("Medida (producto): ${data['p_sizeproduct']}");
    }
    if (data['p_sizeblister']!=null){
      listSize.add("Medida (blister): ${data['p_sizeblister']}");
    }
    _pSize = listSize;

    _pStock = data['p_stock'];
    _pPricePublic = double.parse(data['p_pricepublic'].toString());
    //Control de casting
    _pDateUpdate = data['p_dateupdated'];
    _pDateCreate = data['p_datecreated'];

    _pMinimumAge = data['p_minimumage'];
    _pSubCategory = ConvertCategory.getIDCategory(data['p_category'], data['p_subcategory']);

    //Construcción de la lista de links de imagenes.
    String cadenaLink = data['p_linkimage'].toString().replaceAll("]", "");
    cadenaLink = cadenaLink.replaceAll("[", "");
    cadenaLink = cadenaLink.replaceAll(" ", "");
    _pLinkImage = [];
    _pLinkImage = cadenaLink.split(',');
  }

  ///ProductMySQL: Devuelve un mapeo (string, dynamic) del producto.
  Map<String, dynamic> getProductMapping(){
    Map<String, dynamic> map = {
      Product.getKeyBarcode(): _pCodebar,
      Product.getKeyTitle(): _pTitle,
      Product.getKeyBrand(): _pBrand,
      Product.getKeyInternalCode(): _pInternalCode,
      Product.getKeyDescription(): _pDescription,
      Product.getKeySizes(): _pSize.join(','),
      Product.getKeySubcategory(): _pSubCategory,
      Product.getKeyStock(): _pStock,
      Product.getKeyPricePublic(): _pPricePublic,
      Product.getKeyImages(): _pLinkImage.join(','),
      Product.getKeyMinimumAge(): _pMinimumAge,
      Product.getKeyDateUpdated(): _pDateUpdate,
      Product.getKeyDateCreated(): _pDateCreate,
    };

    return map;
  }
}