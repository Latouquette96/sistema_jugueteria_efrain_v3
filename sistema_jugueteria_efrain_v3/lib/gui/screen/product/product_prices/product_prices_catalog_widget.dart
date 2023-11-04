import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/new_product_prices_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_image_carousel_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_listview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_product_price.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase ProductPricesCatalogWidget: Widget de catálogo de precios de un producto.
class ProductPricesCatalogWidget extends ConsumerStatefulWidget {

  late final StateNotifierProvider<ElementStateProvider<Product>, Product?> _providerProduct;
  late final StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> _providerPriceDistributor;
  late final StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>? _providerStateManager;
  late final StateNotifierProvider<ElementStateProvider<PlutoRow>, PlutoRow?>? _providerPlutoRow;

  ///Constructor de ProductPricesCatalogWidget
  ///
  ///[providerProduct] es el provider del producto actual.
  ///[providerPriceDistributor] es el provider que almacena los pares <precio,distribuidora> del producto actual.
  ///[providerStateManager] el el provider del controlador del catálogo de productos.
  ///[providerPlutoRow] es el provider que almacena el PlutoRow para poder actualizarlo de ser necesario.
  ProductPricesCatalogWidget({
    super.key,
    required StateNotifierProvider<ElementStateProvider<Product>, Product?> providerProduct,
    required StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> providerPriceDistributor,
    StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>? providerStateManager,
    StateNotifierProvider<ElementStateProvider<PlutoRow>, PlutoRow?>? providerPlutoRow,
  }){
   _providerPlutoRow = providerPlutoRow;
   _providerStateManager = providerStateManager;
   _providerPriceDistributor = providerPriceDistributor;
   _providerProduct = providerProduct;
  }
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductPricesCatalogWidgetState();
  }

   StateNotifierProvider<ElementStateProvider<Product>, Product?> getProvider(){
    return _providerProduct;
  }
  
  StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> getProviderID(){
    return _providerPriceDistributor;
  }

  StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>? getProviderStateManager(){
    return _providerStateManager;
  }

  StateNotifierProvider<ElementStateProvider<PlutoRow>, PlutoRow?>? getProviderPlutoRow(){
    return _providerPlutoRow;
  }
}

class _ProductPricesCatalogWidgetState extends ConsumerState<ProductPricesCatalogWidget> {

  late final FormGroup _formNewPP, _formProductPrice;

  @override
  void initState() {
    super.initState();
    final product = ref.read(widget.getProvider());

    _formProductPrice = FormGroup({
      Product.getKeyPricePublic(): FormControl<double>(
        value: product?.getPricePublic() ?? 0
      )
    });

    //Inicializa el formulario para el nuevo precio de producto.
    _formNewPP = FormGroupProductPrices.buildFormGroupProductPrices(ref, widget.getProvider());
  }
  
  @override
  Widget build(BuildContext context) {
    final product = ref.watch(widget.getProvider());
    final distributorFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
      width: 375,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: StyleForm.getDecorationContainer(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            HeaderInformationWidget(
              titleHeader: "Producto: ${product!.getTitle()}",
              tooltipClose: "Cerrar.",
              onClose: (){
                ref.read(widget.getProvider().notifier).free();
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ProductImageCarouselWidget(providerProduct: widget.getProvider(), imagesDisplay: 2,),
                  ),
                  //Precio al público del producto.
                  _buildWidgetPricePublic(context, product),
                  //Construye el ListView
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ExpansionTileContainerWidget(
                      title: "Listado de precios del producto",
                      subtitle: "Contiene los distintos precios registrados para cada distribuidora. También se puede registrar el código interno del producto en dicha distribuidora, así como la página web donde se lo puede hallar.",
                      children: [
                        ProductPriceListViewWidget(
                          providerProduct: widget.getProvider(),
                          providerPriceDistributor: widget.getProviderID(),
                          widthTreeNode: 270,
                        )
                      ],
                    )
                  ),
                  //LISTTILE para crear un nuevo registro.
                  Visibility(
                    visible: distributorFree.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: ExpansionTileContainerWidget(
                          expanded: false,
                          title: "Registrar nuevo precio del producto",
                          subtitle: "Permite insertar un nuevo precio para el producto en cuestión.",
                          children: [NewProductPricesWidget(providerProduct: widget.getProvider(), formGroup: _formNewPP)]),
                    )
                  )
                ],
              )
            )      
          ]
      )
    );
  }  

  Widget _buildWidgetPricePublic(BuildContext context, Product product){
     return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: StyleForm.getDecorationFormControl(),
      child: ReactiveForm(
        formGroup: _formProductPrice,
        child: ListTile(
          //Title: Distribuidora.
          title: Text("Precio de producto al público", style: StyleForm.getTextStyleTitle()),
          //Subtitle
          subtitle: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: ReactiveTextField(
              style: StyleForm.getStyleTextField(),
              decoration: StyleForm.getDecorationTextField("Precio público"),
              formControlName: Product.getKeyPricePublic(),
              validationMessages: {
                ValidationMessage.required: (error) => "(Requerido) Precio al público es requerido."
              },
            ),
          ),
          trailing: IconButton(
            color: Colors.blueGrey,
            padding: EdgeInsets.zero,
            icon: Icon(MdiIcons.fromString("content-save")),
            onPressed: () async{
              //Escribe el nuevo valor al público del producto.
              ref.read(widget.getProvider())!.setPricePublic(double.parse(_formProductPrice.control(Product.getKeyPricePublic()).value.toString()));
              //Realiza la peticion de escritura en el servidor.
              ResponseAPI response = await ref.read(updatePricePublicWithAPIProvider.future);

              //Comprueba si resultó exitosa la operacion (cod. 200), en caso contrario, es error.
              if (context.mounted){
                ElegantNotificationCustom.showNotificationAPI(context, response);
              }

              if (response.isResponseSuccess()){
                if (widget.getProviderPlutoRow()!=null && widget.getProviderStateManager()!=null){
                  //Recupero la posición del registro del producto.
                  int index = ref.read(widget.getProviderStateManager()!)!.rows.indexOf(ref.read(widget.getProviderPlutoRow()!)!);
                  //Si está dentro del arreglo.
                  if (index>-1){
                    //Reemplaza el registro por el actualizado.
                    ref.read(widget.getProviderStateManager()!)!.refRows.setAll(index, [ref.read(widget.getProvider())!.buildPlutoRow()]);
                  }
                }

                ref.read(widget.getProvider().notifier);
                setState(() {});
              }
            },
          ),
        ),  
      )
    );
  }
}