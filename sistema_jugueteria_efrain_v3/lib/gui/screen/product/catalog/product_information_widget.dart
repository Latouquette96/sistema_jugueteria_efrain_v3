import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_elevated_button.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_product.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_product_price.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';
import 'package:url_launcher/url_launcher.dart';

///Clase ProductInformationWidget: Permite mostrar y actualizar la información de un producto.
class ProductInformationWidget extends ConsumerStatefulWidget {
  const ProductInformationWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductInformationWidgetState();
  }
}

class _ProductInformationWidgetState extends ConsumerState<ConsumerStatefulWidget> with ContainerParameters, SingleTickerProviderStateMixin {

  //Atributos de instancia.
  late final FormGroup _form, _formNewPP;
  final TreeController _controller = TreeController(allNodesExpanded: false);
  late bool _brandManual;
  
  final Widget _separadorHeight = const SizedBox(height: 5,);
  final Widget _separadorHeightBlock = const SizedBox(height: 15,);
  final Widget _separadorWidth = const SizedBox(width: 5,);

  @override
  void initState() {
    super.initState();
    //Inicializa el formgroup.
    _form = FormGroupProduct.buildFormGroupProduct(ref, productProvider);
    //Inicializa el formulario para el nuevo precio de producto.
    _formNewPP = FormGroupProductPrices.buildFormGroupProductPrices(ref, productProvider);
    _brandManual = false;
  }

  
  @override
  Widget build(BuildContext context) {
    Product product = ref.watch(productProvider)!;
    final distributorFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        decoration: ContainerStyle.getContainerRoot(),
        child: Column(
          children: [
            HeaderInformationWidget(
              titleHeader: "Información Producto",
              tooltipClose: "Cerrar información del producto.",
              onClose: (){
                ref.read(productProvider.notifier).free();
              },
              onSave: () async{
                bool isNew = ref.read(productProvider)!.getID()==0;
                if (isNew) {await _insert(context);}
                else  {await _update(context);}
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ReactiveForm(
                    formGroup: _form,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWidgetImages(context, product),
                              _separadorHeight,
                              _buildWidgetDescription(context, product),
                              _separadorHeight,
                              _buildWidgetMinimumAge(context, product),
                              _separadorHeight,
                              _buildWidgetSize(context, product)
                            ],
                          ),
                        ),
                        _separadorWidth,
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildWidgetCategory(context, product),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _separadorHeight,
                                        _buildWidgetTitle(context, product),
                                        _separadorHeight,
                                        _buildWidgetProductCode(context, product),
                                        _separadorHeight,
                                        _buildWidgetBrand(context, product),
                                      ],
                                    )),
                                    _separadorWidth,
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _separadorHeight,
                                            _buildWidgetPricePublic(context, product),
                                            _separadorHeight,
                                            _buildReactiveFormProductPrices(context, product, distributorFree)
                                          ],
                                        )
                                    )
                                  ],
                                )
                              ],
                            )
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }

  //-----------------------------CONSTRUIR GUI---------------------------------

  ///ProductPriceWidget: Construye el Widget de Imagenes.
  Widget _buildWidgetImages(BuildContext context, Product product){
    //Recupera todos los enlaces
    bool isNewProduct = product.getID()==0;
    int index = -1;

    return ExpansionTileContainerWidget(
      title: "Imágenes del producto",
      subtitle: "[Obligatorio] Administre las imagenes del producto (debe haber al menos una imagen). ",
      children: [
        Visibility(
          visible: (_form.control(Product.getKeyImages()).value as List<ResourceLink>).isNotEmpty,
          child: Container(
            margin: const EdgeInsets.all(5),
            height: 200,
            width: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (_form.control(Product.getKeyImages()).value as List<ResourceLink>).map((e){
                index++;
                return ImageCustom(
                  fileName: product.getFileName(index),
                  resourceLink: e,
                  isReplaceable: true,
                  isDownloaded: !isNewProduct,
                  onRemoved: (){
                    (_form.control(Product.getKeyImages()).value as List<ResourceLink>).removeAt(index);
                    setState((){});
                  }
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: StyleElevatedButton.getStyleElevatedButtom(),
                  onPressed: () async {
                    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);

                    if (cdata!=null){
                      String textData = cdata.text!;
                      if (textData.contains(',')){
                        for (String textLink in textData.split(',')){
                          if (textLink.isNotEmpty){
                            (_form.control(Product.getKeyImages()).value as List<ResourceLink>).add(ResourceLink(textLink));
                          }
                        }
                      }
                      else{
                        (_form.control(Product.getKeyImages()).value as List<ResourceLink>).add(ResourceLink(cdata.text!));
                      }
                      if (mounted){
                        setState(() {});
                      }
                    }
                  },
                  child: const Text("Insertar link")
              ),
            ],
          ),
        )
      ],
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetSize(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Medidas del producto",
        subtitle: "[Opcional] Brindar medidas del producto es útil para poder tenerlas a mano para cualquier ocasión.",
        children: [
          Container(
              height: 200,
              color: Colors.black26,
              padding: const EdgeInsets.all(5),
              child: ListView(
                children: (_form.control(Product.getKeySizes()).value as List<String>).map((e){
                  return Container(
                      decoration: StyleForm.getDecorationListTileItem(),
                      child: ListTile(
                        titleTextStyle: StyleForm.getStyleDropdownField(),
                        title: Text(e),
                        trailing: IconButton(
                          tooltip: "Remover",
                          color: Colors.black,
                          onPressed: (){
                            (_form.control(Product.getKeySizes()).value as List<String>).remove(e);
                            setState(() { });
                          },
                          icon: Icon(MdiIcons.fromString("delete")),
                        ),
                      )
                  );
                }).toList(),
              )
          ),
          const SizedBox(
            height: 10,
          ),
          ReactiveDropdownField<String>(
            isExpanded: true,
            iconSize: 50,
            icon: const Icon(Icons.arrow_drop_down, size: 25,),
            formControlName: FormGroupProduct.getKeyTemplateSize(),
            style: StyleForm.getStyleDropdownField(),
            decoration: StyleForm.getDecorationTextField("Selección de plantilla"),
            items: FormGroupProduct.getTemplateSize().map((e) => DropdownMenuItem<String>(
              value: e,
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: 300,
                child: Text(e),
              ),
            )).toList(),
            onChanged: (control) {
              _form.control(FormGroupProduct.getKeySizeAux()).value = _form.control(FormGroupProduct.getKeyTemplateSize()).value;
              setState(() {});
              _form.focus(FormGroupProduct.getKeySizeAux());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) Seleccione la categoria del producto."
            },
          ),
          const SizedBox(height: 10,),
          ReactiveTextField(
            maxLines: 5,
            minLines: 1,
            style: StyleForm.getStyleTextArea(),
            decoration: StyleForm.getDecorationTextField("Insertar medida"),
            formControlName: FormGroupProduct.getKeySizeAux(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              List<String> list = _form.control(Product.getKeySizes()).value;
              list.add(_form.control(FormGroupProduct.getKeySizeAux()).value);

              _form.control(FormGroupProduct.getKeySizeAux()).value = "";
              _form.focus(FormGroupProduct.getKeySizeAux());

              setState(() { });
            },
            validationMessages: {
              ValidationMessage.email: (error) => '(Requerido) Ingrese una descrición para el producto.',
            },
          ),
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetCategory(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        isRow: true,
        title: "Categoria del producto",
        subtitle: "[Obligatorio] Clasifique el producto de acuerdo a una categoria y subcategoría. Esto es necesario para filtrar resultados.",
        children: [
          SizedBox(
            width: 250,
            child: ReactiveDropdownField<Category>(
              formControlName: Product.getKeyCategory(),
              style: StyleForm.getStyleTextField(),
              decoration: StyleForm.getDecorationTextField("Categoria"),
              items: FactoryCategory.getInstance().getList().map((e) => DropdownMenuItem<Category>(
                value: e,
                child: Text(e.getCategoryName()),
              )).toList(),
              onChanged: (control) {
                setState(() {});
                _form.focus(Product.getKeySubcategory());
              },
              validationMessages: {
                ValidationMessage.required: (error) => "(Requerido) Seleccione la categoria del producto."
              },
            ),
          ),
          _separadorWidth,
          Expanded(child: Visibility(
            visible: _form.control(Product.getKeyCategory()).value.getCategoryID()!=0,
            child: ReactiveDropdownField<SubCategory>(
              formControlName: Product.getKeySubcategory(),
              style: StyleForm.getStyleTextField(),
              decoration: StyleForm.getDecorationTextField("Subcategoria"),
              items: (_form.control(Product.getKeyCategory()).value as Category).getListSubcategory().map((e) => DropdownMenuItem<SubCategory>(
                value: e,
                child: Text(e.getSubCategoryName(),),
              )).toList(),
              onChanged: (control) {
                setState(() {});
                _form.unfocus();
              },
              validationMessages: {
                ValidationMessage.required: (error) => "(Requerido) Seleccione la categoria del producto."
              },
            ),
          ))
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetTitle(BuildContext context, Product product){

    return ExpansionTileContainerWidget(
        title: "Titulo del producto",
        subtitle: "[Obligatorio] El título es el nombre por el cual se identifica al producto."
            " Si bien no es necesario, lo ideal es que tenga un nombre no repetido con otros productos.",
        children: [
          ReactiveTextField(
            maxLength: Product.getMaxCharsTitle(),
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Título del producto."),
            formControlName: Product.getKeyTitle(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyBrand());
            },
            validationMessages: {
              ValidationMessage.email: (error) => '(Requerido) Ingrese el título del producto.',
            },
          )
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetBrand(BuildContext context, Product product){

    return ExpansionTileContainerWidget(
        title: "Marca/importador del producto",
        subtitle: "[Obligatorio] Seleccione una marca en 'buscar marca/importador' o ingrese manualmente la marca/importador del producto.",
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _brandManual ? Colors.blueGrey.shade300 : Colors.grey),
                      onPressed: (){
                        setState(() {
                          _brandManual = !_brandManual;
                        });
                      },
                      child: Text(_brandManual ? "Modo: Nueva marca/importador" : "Modo: Busqueda de marca/importador")
                    ),
                  )
                ]
            ),
          ),
          _separadorHeightBlock,
          Visibility(
              visible: !_brandManual,
              child: ReactiveDropdownField<String>(
                formControlName: FormGroupProduct.getKeyBrandAux(),
                style: StyleForm.getStyleTextField(),
                decoration: StyleForm.getDecorationTextField("Buscar marca/importador"),
                items: ref.watch(filterOfLoadedBrandsWithAPIProvider).map((e) => DropdownMenuItem<String>(
                  value: e,
                child: Text(e),
                  )).toList(),
                onChanged: (control) {
                  _form.control(Product.getKeyBrand()).value = control.value;
                  setState(() {});
                  _form.focus(Product.getKeyBrand());
                  },
                validationMessages: {
                  ValidationMessage.required: (error) => "(Requerido) Seleccione la marca del producto."
                },
              ),
          ),
          Visibility(
              visible: _brandManual,
              child: ReactiveTextField(
                maxLines: 1,
                maxLength: Product.getMaxCharsBrand(),
                style: StyleForm.getStyleTextArea(),
                decoration: StyleForm.getDecorationTextArea("Marca/importadora"),
                formControlName: Product.getKeyBrand(),
                textInputAction: TextInputAction.newline,
                onChanged: (_){
                  setState(() {});
                },
                validationMessages: {
                  ValidationMessage.email: (error) => '(Requerido) Ingrese una marca/importadora para el producto.',
                },
              )
          ),
        ]
    );
  }
  
  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetPricePublic(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Stock & precio al público",
        subtitle: "[Obligatorio] Se debe establecer el stock, que es la cantidad de productos disponible, y a su vez, el precio al cual se vende el producto al público.",
        children: [
          ReactiveTextField<double>(
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Precio público"),
            formControlName: Product.getKeyPricePublic(),
            textInputAction: TextInputAction.none,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyMinimumAge());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) El precio al público del producto.",
              ValidationMessage.number: (error) => "(Error) Inserte un número mayor o igual a 0.",
            },
          ),
          _separadorHeightBlock,
          ReactiveTextField<int>(
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Stock"),
            formControlName: Product.getKeyStock(),
            textInputAction: TextInputAction.none,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyPricePublic());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) Inserte el stock actual del producto (-1 si 'fuera de stock').",
              ValidationMessage.number: (error) => "(Error) Inserte un número mayor o igual a 0.",
            },
          ),
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetDescription(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Descripción del producto",
        subtitle: "[Obligatorio] Debe ingresar una descripción del producto que permita detallar como es, de qué material está compuesto, como se utiliza, cuantas piezas trae el producto, etc.",
        children: [
          SizedBox(
            height: 300,
            child: ReactiveTextField(
              maxLines: 15,
              maxLength: Product.getMaxCharsDescription(),
              style: StyleForm.getStyleTextArea(),
              decoration: StyleForm.getDecorationTextArea("Descripción"),
              formControlName: Product.getKeyDescription(),
              textInputAction: TextInputAction.newline,
              onChanged: (_){
                setState(() {});
              },
              validationMessages: {
                ValidationMessage.email: (error) => '(Requerido) Ingrese una descrición para el producto.',
              },
            ),
          )
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetMinimumAge(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Edad mínima recomendada",
        subtitle: "[Obligatorio] La edad mínima recomendada es útil para brindar una mejor atención a un cliente que requiera productos de una determinada franja de edad.",
        children: [
          ReactiveDropdownField<MinimumAge>(
            formControlName: Product.getKeyMinimumAge(),
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Edad mínima recomendada"),
            items: FactoryMinimumAge.getInstance().getList().map((e) => DropdownMenuItem<MinimumAge>(
              value: e,
              child: Text(e.getMinimumAgeValue()),
            )).toList(),
            onChanged: (control) {
              setState(() {});
              _form.focus(Product.getKeySizes());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) Seleccione una edad mínima."
            },
          )
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetProductCode(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Código de barra e interno del producto",
        subtitle: "[Obligatorio] El código de barra o el código interno debe ser definido ya que permite la búsqueda del producto de manera rápida y sin errores.",
        children: [
          ReactiveTextField(
            maxLength: Product.getMaxCharsBarcode(),
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Código de barras"),
            formControlName: Product.getKeyBarcode(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyInternalCode());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) Ingrese el código de barras del producto."
            },
          ),
          _separadorHeight,
          ReactiveTextField(
            maxLength: 50,
            style: StyleForm.getStyleTextField(),
            decoration: StyleForm.getDecorationTextField("Código interno"),
            formControlName: Product.getKeyInternalCode(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyTitle());
            },
          ),
        ]
    );
  }

  //--------------------CONSTRUIR GUI (PRECIOS DE PRODUCTOS)-------------------

  ///ProductPriceWidget: Construye un formulario reactivo de precios de producto.
  Widget _buildReactiveFormProductPrices(BuildContext context, Product product, List<Distributor> distributorFree){
    //Precios del producto
    return ReactiveForm(
        formGroup: _formNewPP,
        child: ExpansionTileContainerWidget(
          title: "Precios en distribuidoras",
          subtitle: "Permite definir los distintos precios del producto en distintas distribuidoras.\n\n"
              "${ ref.read(productProvider)!.getID()==0
                ? "Importante: Solo puede ser ingresados precio de distribuidoras sobre productos previamente guardados, "
                  "por tal motivo, debe presionar sobre el botón de guardado y luego se"
                  "habilitará el ingreso de precios."
                : "Importante: Los precios son actualizados de manera inmediata, por tal motivo, solo alcanza con presionar el boton 'insertar' (caso de nuevo precio)"
                  " o el icono de guardar para un precio existente."
          }",
          children: [
            //Construye el ListView
            Visibility(
              visible: ref.read(productProvider)!.getID()!=0,
              child: _buildWidgetListView(context, product)
            ),
            //LISTTILE para crear un nuevo registro.
            Visibility(
                visible: distributorFree.isNotEmpty && ref.read(productProvider)!.getID()!=0,
                child: _buildWidgetNewProductPrice(context)
            )
          ],
        )
    );
  }

  ///ProductPriceWidget: Construye el widget listado de precios de producto.
  Widget _buildWidgetListView(BuildContext context, Product product){
    var pricesProduct = ref.watch(productPricesByIDProvider);

    return Container(
        height: 300,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(0),
        decoration: StyleForm.getDecorationFormControl(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Precios de producto por distribuidora", style: StyleForm.getTextStyleTitle()),
            Expanded(
                child: SingleChildScrollView(
                  child: TreeView(
                    indent: 10,
                    treeController: _controller,
                    //Lo nodos serán cada uno de los elementos 'e' que son pares de <Distribuidora, PrecioProducto>
                    nodes: pricesProduct.map((e){
                      //Nodo del elemento 'e'
                      return TreeNode(
                          content: Container(
                            decoration: StyleForm.getDecorationControlImage(),
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                            width: 250,
                            child: Row(
                              children: [
                                Expanded(child: Text(e.getValue1().getName(), style: StyleForm.getTextStyleListTileTitle(), overflow: TextOverflow.ellipsis,)),
                                IconButton(
                                  tooltip: "Guarda los cambios realizados.",
                                  padding: EdgeInsets.zero,
                                  icon: Icon(MdiIcons.fromString("content-save"), color: Colors.blueGrey,),
                                  onPressed: () async{
                                    ref.read(productPriceProvider.notifier).load(e.getValue2()!);
                                    await ref.read(updateProductPriceWithAPIProvider.future);
                                    await ref.read(productPricesByIDProvider.notifier).refresh();
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
                                    await ref.read(productPricesByIDProvider.notifier).refresh();
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
                                  color: Colors.lightBlue.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  height: 60,
                                  width: 235,
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
                                  color: Colors.lightBlue.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  height: 40,
                                  width: 235,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text("• Precio compra (x${e.getValue1().getIVA().toStringAsFixed(2)}): \$${(e.getValue2()!.getPriceBase()*e.getValue1().getIVA()).toStringAsFixed(2)}", style: StyleForm.getTextStyleListTileSubtitle()),
                                )
                            ),
                            TreeNode(
                                content: Container(
                                  color: Colors.lightBlue.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  height: 60,
                                  width: 235,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(child: TextField(
                                        decoration: StyleForm.getDecorationTextField("Sitio web del producto"),
                                        controller: TextEditingController(text: e.getValue2()!.getWebsite()),
                                        onChanged: (String value){
                                          e.getValue2()!.setWebsite(value);
                                        },
                                        onSubmitted:(value) {
                                          setState(() {});
                                        },
                                      )),
                                      IconButton(
                                          onPressed: () async {
                                            Uri url = Uri.parse(e.getValue2()?.getWebsite() ?? "");
                                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                              throw Exception('Could not launch $url');
                                            }
                                          },
                                          icon: Icon(MdiIcons.fromString("web"), color: Colors.blue)
                                      )
                                    ],
                                  ),
                                )
                            ),
                            TreeNode(
                                content: Container(
                                  color: Colors.lightBlue.shade50,
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  height: 60,
                                  width: 235,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text("• Ultimo cambio: ${e.getValue2()!.getDateLastUpdated()}", style: StyleForm.getTextStyleListTileSubtitle()),
                                )
                            )
                          ]
                      );
                    }).toList(),
                  ),
                )
            ),
          ],
        )
    );
  }

  ///ProductPriceWidget: Constuye el widget para la insersion de un nuevo precio de producto.
  Widget _buildWidgetNewProductPrice(BuildContext context){
    final distributorsFree = ref.watch(distributorFreeProductPriceProvider);

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        decoration: StyleForm.getDecorationFormControl(),
        height: 200,
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
                                Text("\tGuardar", style: StyleForm.getTextStyleListTileSubtitle(),),
                              ],
                            ),
                            onPressed: () async{
                              ref.read(productPriceProvider.notifier).load(ProductPrice.fromJSON(_formNewPP.value));
                              final response = await ref.read(newProductPriceWithAPIProvider.future);

                              if (mounted){
                                if (response==ResponseStatusCode.statusCodeOK){
                                  ElegantNotification.success(
                                      title:  const Text("Información"),
                                      description:  const Text("La información ha sido actualizada con éxito.")
                                  ).show(context);
                                  ref.read(productPriceProvider.notifier).free();
                                  await ref.read(productPricesByIDProvider.notifier).refresh();
                                  setState(() {});
                                }
                                else{
                                  //Caso contrario, mostrar notificación de error.
                                  ElegantNotification.error(
                                      title:  const Text("Error"),
                                      description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                                  ).show(context);
                                }
                              }
                            },
                          )),
                          Expanded(child: IconButton(
                            color: Colors.redAccent,
                            padding: EdgeInsets.zero,
                            icon: Row(
                              children: [
                                Icon(MdiIcons.fromString("eraser")),
                                Expanded(child: Text("\tLimpiar", style: StyleForm.getTextStyleListTileSubtitle(),)),
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


  //------------------OPERACIONES DE GUI---------------------------------

  ///ProductPriceWidget: Limpia el formulario de insersion de precio de producto.
  void _clearForm(){
    final distributorsFree = ref.read(distributorFreeProductPriceProvider);
    _formNewPP.control(ProductPrice.getKeyDistributor()).value = 0;
    _formNewPP.control(ProductPrice.getKeyPriceBase()).value = 0.00;
    _formNewPP.control("${ProductPrice.getKeyDistributor()}Object").value = distributorsFree.isEmpty ? null : distributorsFree.first;
  }

  //------------OPERACIONES----------------------------

  ///ProductInformationWidget: Realiza la inserción del producto.
  Future<void> _insert(BuildContext context) async{
    //Carga los datos del formulario en el producto.
    ref.read(productProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseStatusCode response = await ref.read(newProductWithAPIProvider.future);

    if (response==ResponseStatusCode.statusCodeOK){
      //Inserta el nuevo registro por el actualizado.
      ref.read(stateManagerProductProvider.notifier).insert(productProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      //Notifica con exito en la operacion
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      //Libera el producto del proveedor.
      ref.read(productProvider.notifier).free();
      setState(() {});
    }
    else{
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }

  ///ProductInformationWidget: Actualiza el producto.
  Future<void> _update(BuildContext context) async{
    //Carga los datos del formulario en el producto.
    ref.read(productProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseStatusCode response = await ref.watch(updateProductWithAPIProvider.future);

    if (response==ResponseStatusCode.statusCodeOK){
      ref.read(stateManagerProductProvider.notifier).update(productProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      //Libera el producto del proveedor.
      ref.read(productProvider.notifier).free();
      setState(() {});
    }
    else{ 
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }
}
