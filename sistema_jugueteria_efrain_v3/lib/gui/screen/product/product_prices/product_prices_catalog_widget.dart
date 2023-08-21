import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';

///Clase ProductPricesCatalogWidget: Widget de catálogo de precios de un producto.
class ProductPricesCatalogWidget extends ConsumerStatefulWidget {
  const ProductPricesCatalogWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductPricesCatalogWidgetState();
  }
}

class _ProductPricesCatalogWidgetState extends ConsumerState<ConsumerStatefulWidget> {

  late final FormGroup _formNewPP, _formProductPrice;
  final TreeController _controller = TreeController(allNodesExpanded: false);

  @override
  void initState() {
    super.initState();

    final product = ref.read(productSearchPriceProvider);

    _formProductPrice = FormGroup({
      Product.getKeyPricePublic(): FormControl<double>(
        value: product?.getPricePublic() ?? 0
      )
    });

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
                  //Precio al público del producto.
                  _buildWidgetPricePublic(context, product),
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
              ref.read(productSearchPriceProvider)!.setPricePublic(double.parse(_formProductPrice.control(Product.getKeyPricePublic()).value.toString()));
              //Realiza la peticion de escritura en el servidor.
              final response = await ref.read(updatePricePublicWithAPIProvider.future);
              //Comprueba si resultó exitosa la operacion (cod. 200), en caso contrario, es error.
              bool error = response.statusCode!=200;
              if (error==false){
                if (context.mounted){
                  ElegantNotification.success(
                    title:  const Text("Información"),
                    description:  const Text("La información ha sido actualizada con éxito.")
                  ).show(context);
                }
                
                //Recupero la posición del registro del producto.
                int index = ref.read(stateManagerProductProvider)!.rows.indexOf(ref.read(plutoRowProvider)!);
                //Si está dentro del arreglo.
                if (index>-1){
                  //Reemplaza el registro por el actualizado.
                  ref.read(stateManagerProductProvider)!.refRows.setAll(index, [ref.read(productSearchPriceProvider)!.buildPlutoRow()]);
                }

                ref.read(productSearchPriceProvider.notifier);
                setState(() {});
              }
              else{
                //Caso contrario, mostrar notificación de error.
                if (context.mounted){
                  ElegantNotification.error(
                    title:  const Text("Error"),
                    description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                  ).show(context);
                }
              }
            },
          ),
        ),  
      )
    );
  }

  ///ProductPricesCatalogWidget: Contruye el widget listado de precios de producto.
  Widget _buildWidgetListView(BuildContext context, Product product){
    var pricesProduct = ref.watch(productPricesByIDProvider);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        width: 400,
        decoration: StyleForm.getDecorationFormControl(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Precios de producto por distribuidora", style: StyleForm.getTextStyleTitle()),
            Expanded(
              child: Container(
                color: Colors.blueGrey.shade100,
                child: SingleChildScrollView(
                  child: TreeView(
                    indent: 20,
                    treeController: _controller,
                    //Lo nodos serán cada uno de los elementos 'e' que son pares de <Distribuidora, PrecioProducto>
                    nodes: pricesProduct.map((e){
                      //Nodo del elemento 'e'
                      return TreeNode(
                        content: Container(
                          decoration: StyleForm.getDecorationControlImage(),
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 225,
                                child: Text(e.getValue1().getName(), style: StyleForm.getTextStyleListTileTitle(), overflow: TextOverflow.ellipsis,),
                              ),
                              IconButton(
                                  tooltip: "Guarda los cambios realizados.",
                                  padding: EdgeInsets.zero,
                                  icon: Icon(MdiIcons.fromString("content-save"), color: Colors.blueGrey,),
                                  onPressed: () async{
                                    ref.read(productPriceProvider.notifier).load(e.getValue2()!);
                                    await ref.read(updateProductPriceWithAPIProvider.future);
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  tooltip: "Elimina el precio del producto.",
                                  padding: EdgeInsets.zero,
                                  icon: Icon(MdiIcons.fromString("delete"), color: Colors.redAccent,),
                                  onPressed: () async{
                                    ref.read(productPriceRemoveProvider.notifier).load(e.getValue2()!);
                                    await ref.read(removeProductPriceWithAPIProvider.future);
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        ),
                        children: [
                          //Nodo de precio.
                          TreeNode(
                            content: Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              height: 60,
                              width: 290,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                            )
                          ),
                          TreeNode(
                            content: Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              height: 40,
                              width: 290,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text("• Precio compra (x${e.getValue1().getIVA().toStringAsFixed(2)}): \$${(e.getValue2()!.getPriceBase()*e.getValue1().getIVA()).toStringAsFixed(2)}", style: StyleForm.getTextStyleListTileSubtitle()),
                            )
                          ),
                          TreeNode(
                            content: Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              height: 40,
                              width: 290,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text("• Ultimo cambio: ${e.getValue2()!.getDateLastUpdated()}", style: StyleForm.getTextStyleListTileSubtitle()),
                            )
                          )
                        ]
                      );
                    }).toList(),
                  ),
                ),
              )
            ),
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
                          final response = await ref.read(newProductPriceWithAPIProvider.future);
                          bool error = response.statusCode!=201;
                          if (error==false){
                            // ignore: use_build_context_synchronously
                            ElegantNotification.success(
                              title:  const Text("Información"),
                              description:  const Text("La información ha sido actualizada con éxito.")
                            ).show(context);
                            ref.read(productPriceProvider.notifier).free(ref);
                            setState(() {});
                          }
                          else{
                            //Caso contrario, mostrar notificación de error.
                            // ignore: use_build_context_synchronously
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