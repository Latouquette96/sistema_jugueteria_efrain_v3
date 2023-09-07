import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/toggle/toggle_notifier.dart';

///productDescriptionComplete es un proveedor que permite comprobar si se muestra o no la descripción completa.
final productDescriptionComplete = StateNotifierProvider<ToggleNotifier, bool>((ref) {
  return ToggleNotifier();
});

///productPriceVisible es un proveedor que permite comprobar si se muestra o no el precio del producto.
final productPriceVisible = StateNotifierProvider<ToggleNotifier, bool>((ref) {
  return ToggleNotifier();
});

///descriptionProductSharingProvider devuelve el texto para compartir de un listado de productos seleccionados.
final descriptionProductSharingProvider = Provider<String>((ref) {

  final showDescription = ref.watch(productDescriptionComplete);
  final hiddenPriceDescription = ref.watch(productPriceVisible);
  final listProduct = ref.watch(productSharingProvider);

  String toReturn = "";
  //Para cada uno de los productos seleccionados para compartir.
  for (Product p in listProduct){
    String text = "\u{1F381}${p.getTitle().toUpperCase()}\u{1F381}"; //Icono de regalo
    //Si el precio no es ocultado, se lo muestra.
    if (!hiddenPriceDescription){
      text = "$text\n\n💵 Precio contado/débito: \$${p.getPricePublic().toStringAsFixed(2)} 💵";
    }
    //Si se muestra la descripcion completa.
    if (showDescription){
      text = "$text\n\n\u{1F536}DESCRIPCIÓN\u{1F536}\n${p.getDescription()}\n\n";
      //Inserta las medidas.
      for (String size in p.getSizes()){
        text = "$text\u{1F536}$size\n";
      }
    }
    //Barra separadora.
    text = "$text\n\n=================================\n\n";
    //Texto a compartir.
    toReturn = "$toReturn$text";
  }

  toReturn = "$toReturn"
    "💳 ¡¡Aceptamos todas las tarjetas y las billeteras virtuales Cuenta DNI y Mercado Pago!! 💳\n\n"
    "🚚 Realizamos envíos dentro de Bahía Blanca con un recargo que varía de acuerdo a la zona. 🚚";
  return toReturn;
});

///productSharingProvider es un proveedor que almacena la lista de productos seleccionados para compartir.
final productSharingProvider = StateNotifierProvider<SelectedItemsProvider<Product>, List<Product>>((ref) => SelectedItemsProvider(ref, productCatalogProvider));