import 'package:mysql1/mysql1.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_category.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_plutonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase ProductMySQL: Tiene la finalidad de representar un producto.
class ProductMySQL with MixinPlutonizable{
  //Atributos de instancia
  late String _pCodebar;
  late String? _pInternalCode;
  late String _pTitle;
  late String _pBrand;
  late String _pDescription;
  late List<String> _pSize;
  late int _pStock;
  late double _pPricePublic;
  late List<String> _pLinkImage;
  late int _pDateUpdate;
  late int _pDateCreate;
  late int _pMinimumAge;
  late int _pSubCategory;


  ///Constructor de ProductMySQL: Construye un producto de acuerdo a un ResultRow (MySQL)
  ProductMySQL.loadResultRow(ResultRow data){
    try{
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
      print("${data['p_category']}, ${data['p_subcategory']}");
      _pSubCategory = ConvertCategory.getIDCategory(data['p_category'], data['p_subcategory']);
      //Construcción de la lista de links de imagenes.
      String cadenaLink = data['p_linkimage'].toString().replaceAll("]", "");
      cadenaLink = cadenaLink.replaceAll("[", "");
      cadenaLink = cadenaLink.replaceAll(" ", "");
      _pLinkImage = cadenaLink.split(',');

      buildPlutoRow();
    }
    catch(e){
      print(e);
    }
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

  @override
  PlutoRow buildPlutoRow() {
    var categoryPair = FactoryCategory.getInstance().search(_pSubCategory);
    
    try{
      plutoRow = PlutoRow(
        type: PlutoRowType.normal(),
        checked: false,
        cells: {
          Product.getKeyBarcode(): PlutoCell(value: _pCodebar),
          Product.getKeyInternalCode(): PlutoCell(value: _pInternalCode),
          Product.getKeyTitle(): PlutoCell(value: _pTitle),
          Product.getKeyBrand(): PlutoCell(value: _pBrand),
          Product.getKeyCategory(): PlutoCell(value: "${categoryPair.getValue1()!.getCategoryName()} > ${categoryPair.getValue2()!.getSubCategoryName()}"),
          Product.getKeyStock(): PlutoCell(value: _pStock),
          Product.getKeyPricePublic(): PlutoCell(value: _pPricePublic),
       },
    );
    }
    catch(e){
      print(e);
    }
    return plutoRow!;
  }
}