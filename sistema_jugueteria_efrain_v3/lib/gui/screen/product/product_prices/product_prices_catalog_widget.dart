import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

///Clase ProductPricesCatalogWidget: Widget de catálogo de precios de un producto.
class ProductPricesCatalogWidget extends ConsumerStatefulWidget {
  const ProductPricesCatalogWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductPricesCatalogWidgetState();
  }
}

class _ProductPricesCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {

  late final FormGroup _formNewPP;

  @override
  void initState() {
    super.initState();

    final product = ref.read(productSearchPriceProvider);

    //Inicializa el formulario para el nuevo precio de producto.
    _formNewPP = FormGroup({
      "${ProductPrice.getKeyDistributor()}Object": FormControl<Distributor>(
        value:  null,
      ),
      ProductPrice.getKeyDistributor() : FormControl<int>(
        value: 0
      ),
      ProductPrice.getKeyPriceBase(): FormControl<double>(
        value: 0.00
      ),
      ProductPrice.getKeyProduct(): FormControl<int>(
        value: product!.getID()
      ),
      ProductPrice.getKeyDateUpdate(): FormControl<int>(
        value: DatetimeCustom.getDatetimeIntegerNow()
      ),
      ProductPrice.getKeyID(): FormControl<int>(
        value: 0
      )
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productSearchPriceProvider);
    final distributorFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
      width: 400,
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
                ref.read(productSearchPriceProvider.notifier).free();
              },
            ),
            Expanded(
              child: Column(
                children: [
                  //Construye el ListView
                  _buildWidgetListView(context, product),
                  //LISTTILE para crear un nuevo registro.
                  Visibility(
                    visible: distributorFree.isNotEmpty,
                    child: _buildWidgetNewProductPrice(context) 
                  )
                ],
              )
            )      
          ]
      )
    );
  }  

  ///ProductPricesCatalogWidget: Contruye el widget listado de precios de producto.
  Widget _buildWidgetListView(BuildContext context, Product product){
    final pricesProduct = ref.watch(productPricesByIDProvider);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: StyleForm.getDecorationFormControl(),
        child: Column(
          children: [
            Text("Precios de producto por distribuidora", style: StyleForm.getTextStyleTitle()),
            Expanded(child: 
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                color: Colors.black26,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
                  children: pricesProduct.map((e){
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      margin: const EdgeInsets.fromLTRB(5, 2.5, 2.5, 2.5),
                      decoration: StyleForm.getDecorationListItem(),
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(e.getValue1().getName(), style: StyleForm.getTextStyleListTileTitle(),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: TextField(
                                    decoration: StyleForm.getDecorationTextField("Precio base (sin impuestos)"),
                                    controller: TextEditingController(text: e.getValue2()!.getPriceBase().toStringAsFixed(2)),
                                    onChanged: (String value){
                                      e.getValue2()!.setPriceBase(double.parse(value));
                                    },
                                    onSubmitted:(value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Text("• Precio compra (x${e.getValue1().getIVA().toStringAsFixed(2)}): \$${(e.getValue2()!.getPriceBase()*e.getValue1().getIVA()).toStringAsFixed(2)}", style: StyleForm.getTextStyleListTileSubtitle()),
                                Text("• Ultimo cambio: ${e.getValue2()!.getDateLastUpdated()}", style: StyleForm.getTextStyleListTileSubtitle())
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 30,
                            child: IconButton(
                              tooltip: "Guarda los cambios realizados.",
                              padding: EdgeInsets.zero,
                              icon: Icon(MdiIcons.fromString("content-save"), color: Colors.blueGrey,),
                              onPressed: () async{
                                ref.read(productPriceProvider.notifier).load(e.getValue2()!);
                                await ref.read(updateProductPriceWithAPIProvider.future);
                                setState(() {});
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              tooltip: "Elimina el precio del producto.",
                              padding: EdgeInsets.zero,
                              icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,),
                              onPressed: () async{
                                ref.read(productPriceRemoveProvider.notifier).load(e.getValue2()!);
                                await ref.read(removeProductPriceWithAPIProvider.future);
                                setState(() {});
                              },
                            ),
                          )
                        ]
                      ),
                    );
                  }).toList(),
                ),
              ),)
          ],
        )
      )
      
    );
  }

  ///ProductPricesCatalogWidget: Constuye el widget para la insersion de un nuevo precio de producto.
  Widget _buildWidgetNewProductPrice(BuildContext context){
    final distributorsFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: StyleForm.getDecorationFormControl(),
      child: ReactiveForm(
        formGroup: _formNewPP,
        child: ListTile(
          //Title: Distribuidora.
          title: Text("Ingresar nuevo precio de producto", style: StyleForm.getTextStyleTitle()),
          //Subtitle
          subtitle: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              children: [
                ReactiveDropdownField<Distributor>(
                  formControlName: "${ProductPrice.getKeyDistributor()}Object",
                  style: StyleForm.getStyleTextField(),
                  decoration: StyleForm.getDecorationTextField("Distribuidora"),
                  items: distributorsFree.map((e) => DropdownMenuItem<Distributor>(
                    value: e,
                    child: Text(e.getName()),
                  )).toList(),
                  onChanged: (control) {
                    _formNewPP.control(ProductPrice.getKeyDistributor()).value = control.value!.getID();
                    _formNewPP.focus(ProductPrice.getKeyPriceBase());
                  },
                  validationMessages: {
                    ValidationMessage.required: (error) => "(Requerido) Seleccione la distribuidora."
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ReactiveTextField(
                  style: StyleForm.getStyleTextField(),
                  decoration: StyleForm.getDecorationTextField("Precio base (sin impuestos)"),
                  formControlName: ProductPrice.getKeyPriceBase(),
                  validationMessages: {
                    ValidationMessage.required: (error) => "(Requerido) Ingrese el código de barras del producto."
                  },
                ),
                Container(
                  margin: EdgeInsets.zero,
                  height: 32,
                  child: Row(
                    children: [ 
                      Expanded(child: IconButton(
                        color: Colors.blueGrey,
                        padding: EdgeInsets.zero,
                        icon: Row(
                          children: [
                            Icon(MdiIcons.fromString("content-save")),
                            Text("\tGuardar registro", style: StyleForm.getTextStyleListTileSubtitle(),),
                          ],
                        ),
                        onPressed: () async{
                          ref.read(productPriceProvider.notifier).load(ProductPrice.fromJSON(_formNewPP.value));
                          final response = ref.read(newProductPriceWithAPIProvider);
                          bool error = response.when(
                            data: (data){ return false; }, 
                            error: (object, stack) { return true; }, 
                            loading: (){ return false; }
                          );
                          if (error==false){
                            ElegantNotification.success(
                              title:  const Text("Información"),
                              description:  const Text("La información ha sido actualizada con éxito.")
                            ).show(context);
                            ref.read(productPriceProvider.notifier).free(ref);
                            setState(() {});
                          }
                          else{
                            //Caso contrario, mostrar notificación de error.
                            ElegantNotification.error(
                              title:  const Text("Error"),
                              description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                            ).show(context);
                          }
                        },
                      )),
                      Expanded(child: IconButton(
                        color: Colors.redAccent,
                        padding: EdgeInsets.zero,
                        icon: Row(
                          children: [
                            Icon(MdiIcons.fromString("eraser")),
                            Text("\tLimpiar formulario", style: StyleForm.getTextStyleListTileSubtitle(),),
                          ],
                        ),
                        onPressed: (){
                          _clearForm();
                          setState(() {});
                        },
                      ),)
                    ],
                      ),
                )
              ],
            )
          ),
          
        ),  
      )
    );
  }

  ///ProductPricesCatalogWidget: Limpia el formulario de insersion de precio de producto.
  void _clearForm(){
    final distributorsFree = ref.read(distributorFreeProductPriceProvider);
    _formNewPP.control(ProductPrice.getKeyDistributor()).value = 0;
    _formNewPP.control(ProductPrice.getKeyPriceBase()).value = 0.00;
    _formNewPP.control("${ProductPrice.getKeyDistributor()}Object").value = distributorsFree.isEmpty ? null : distributorsFree.first;
  }
}