import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase FormGroupProduct: Modela la composicion de todos los controles de formulario de un producto.
class FormGroupProduct {
  //Atributos de clase.
  static const String _keyTemplateSize = "pp_template_size";
  static final String _keySizeAux = "${Product.getKeySizes()}Aux";
  static final String _keyBrandAux = "${Product.getKeyBrand()}Aux";
  //Atributos de clase: Plantilla de medidas.
  static const List<String> _templateSize = [
    "Medida (Blíster): # cm de alto x # cm de ancho x # cm de largo.",
    "Medida (Blíster): # cm de alto x # cm de ancho x # cm de profundidad.",
    "Medida (Caja): # cm de alto x # cm de ancho x # cm de largo.",
    "Medida (Caja): # cm de alto x # cm de ancho x # cm de profundidad.",
    "Medida (Producto): # cm de alto x # cm de ancho x # cm de largo.",
    "Medida (Producto): # cm de alto x # cm de ancho x # cm de profundidad.",
    "Medida (Producto): # cm de circunferencia.",
    "Medida (Producto): # cm de diametro."
  ];

  ///FormGroupProduct: Construye el FormGroup para un producto almacenado en un determinado provider de ProductProvider.
  static buildFormGroupProduct(WidgetRef ref, StateNotifierProvider<ElementStateProvider<Product>, Product?> provider){
    Pair<Category?, SubCategory?> pairCategory = FactoryCategory.getInstance().search(ref.read(provider)!=null ? ref.read(provider)!.getSubcategory() : 0);
    
    return FormGroup({
      Product.getKeyID(): FormControl<int>(
        value: ref.read(provider)?.getID(),
      ),
      Product.getKeyBarcode(): FormControl<String>(
        value: ref.read(provider)?.getBarcode(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsBarcode())]
      ),
      Product.getKeyInternalCode(): FormControl<String>(
        value: ref.read(provider)?.getInternalCode(),
      ),
      Product.getKeyTitle(): FormControl<String>(
        value: ref.read(provider)?.getTitle(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsTitle())]
      ),
      _keyBrandAux: FormControl<String>(
        value: ref.read(provider)?.getBrand()
      ),
      Product.getKeyBrand(): FormControl<String>(
        value: ref.read(provider)?.getBrand(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsBrand())]
      ),     
      Product.getKeyDescription(): FormControl<String>(
        value: ref.read(provider)?.getDescription(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsDescription())]
      ),
      Product.getKeySizes(): FormControl<List<String>>(
        value: ref.read(provider)?.getSizes(),
        validators: [Validators.required]
      ),
      _keySizeAux: FormControl<String>(
        value: "",
      ),
      Product.getKeyCategory(): FormControl<Category>(
        value: pairCategory.getValue1(),
        validators: [Validators.required]
      ),
      Product.getKeySubcategory(): FormControl<SubCategory>(
        value: pairCategory.getValue2(),
        validators: [Validators.required]
      ),
      Product.getKeyStock(): FormControl<int>(
        value: ref.read(provider)?.getStock(),
        validators: [Validators.required, Validators.number, Validators.min<int>(-1)]
      ),
      Product.getKeyPricePublic(): FormControl<double>(
        value: ref.read(provider)?.getPricePublic(),
        validators: [Validators.required, Validators.number]
      ),
      Product.getKeyImages(): FormControl<List<ResourceLink>>(
        value: ref.read(provider)?.getLinkImages(),
        validators: [Validators.required]
      ),
      Product.getKeyMinimumAge(): FormControl<MinimumAge>(
        value: FactoryMinimumAge.getInstance().search(ref.read(provider)?.getMinimumAge() ?? 0),
        validators: [Validators.required]
      ),
      Product.getKeyDateCreated(): FormControl<String>(
        value: ref.read(provider)!.getDateCreate(),
        validators: [Validators.required]
      ),
      Product.getKeyDateUpdated(): FormControl<String>(
        value: ref.read(provider)!.getDateUpdate(),
        validators: [Validators.required]
      ),
      _keyTemplateSize: FormControl<String>(
        value: ""
      )
    });
  }

  ///FormGroupProduct: Devuelve la lista de plantillas para medidas.
  static List<String> getTemplateSize(){
    return _templateSize;
  }

  ///FormGroupProduct_ Devuelve la clave para la lista de medidas.
  static String getKeyTemplateSize(){
    return _keyTemplateSize;
  }

  ///FormGroupProduct: Devuelve la clave para medida auxiliar.
  static String getKeySizeAux(){
    return _keySizeAux;
  }

  ///FormGroupProduct: Devuelve la clave para la marca auxiliar.
  static String getKeyBrandAux(){
    return _keyBrandAux;
  }
}