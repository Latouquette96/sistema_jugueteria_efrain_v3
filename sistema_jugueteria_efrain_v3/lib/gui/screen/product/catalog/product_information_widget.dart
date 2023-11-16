import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/new_product_prices_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/product/product_prices/product_prices_listview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_dropdown.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_expansion_tile.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_area.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_product.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_product_price.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/code_generated/generated_code_controller.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

///Clase ProductInformationWidget: Permite mostrar y actualizar la información de un producto.
class ProductInformationWidget extends ConsumerStatefulWidget {

  //Atributos de instancia
  final Function() onClose;

  const ProductInformationWidget({super.key, required this.onClose});
  
  @override
  ConsumerState<ProductInformationWidget> createState() {
    return _ProductInformationWidgetState();
  }
}

class _ProductInformationWidgetState extends ConsumerState<ProductInformationWidget> with ContainerParameters, SingleTickerProviderStateMixin {

  //Atributos de instancia.
  late final FormGroup _form, _formNewPP;
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
        decoration: StyleContainer.getContainerRoot(),
        child: Column(
          children: [
            HeaderInformationWidget(
              titleHeader: (ref.watch(productProvider)!.getID()==0) ? "Registro: Nuevo producto" : "Registro: ${ref.watch(productProvider)!.getTitle()} - ${ref.watch(productProvider)!.getBrand()}",
              tooltipClose: "Cerrar información del producto.",
              onClose: (){
                widget.onClose.call();
              },
              onSave: () async{
                bool isNew = ref.read(productProvider)!.getID()==0;
                if (isNew) {await _insert(context);}
                else  {await _update(context);}
                widget.onClose.call();
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWidgetImages(context, product),
                              _separadorHeight,
                              _buildWidgetDescription(context, product),
                            ],
                          ),
                        ),
                        _separadorWidth,
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWidgetCategory(context, product),
                            _separadorHeight,
                            _buildWidgetProductCode(context, product),
                            _separadorHeight,
                            _buildWidgetTitleBrand(context, product),
                          ],
                        )),
                        _separadorWidth,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWidgetPricePublic(context, product),
                              _separadorHeight,
                              _buildWidgetMinimumAge(context, product),
                              _separadorHeight,
                              _buildWidgetSize(context, product),
                            ],
                          ),
                        ),
                        _separadorWidth,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildReactiveFormProductPrices(context, distributorFree)
                            ],
                          ),
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
      trailing: Row(
        children: [
          IconButton(
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
              tooltip: "Inserta el link de la imagen almacenada en el portapapeles.",
              icon: const Icon(Icons.paste, color: Colors.black54)
          ),
          Expanded(child: Center(child: Text("Imágenes", style: StyleExpansionTile.getStyleTitleExpansionTile(),),)),
        ],
      ),
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
        Text("Imagenes cargadas: ${ref.watch(productProvider)!.getLinkImages().length}", style: StyleTextField.getTextStyleNormal())
      ],
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetSize(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Medidas del producto",
        subtitle: "[Opcional] Brindar medidas del producto es útil para poder tenerlas a mano para cualquier ocasión.",
        children: [
          ExpansionTileContainerWidget(
              title: "Listado de medidas",
              subtitle: "Aquí se puede observar todas las medidas del producto y eliminar las que no se desean con el botón adjunto en cada medida.",
              childrenLevel: 1,
              descriptionShow: true,
              children: [
                Container(
                    height: 200,
                    color: Colors.brown.shade100,
                    padding: const EdgeInsets.all(0),
                    child: ListView(
                      children: (_form.control(Product.getKeySizes()).value as List<String>).map((e){
                        return Container(
                            decoration: StyleListTile.getDecorationContainer(),
                            child: ListTile(
                              titleTextStyle: StyleDropdown.getTextStyle(),
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
                )
              ]
          ),
          _separadorHeightBlock,
          ExpansionTileContainerWidget(
              title: "Ingresar nueva medida",
              subtitle: "Puede utilizar una plantilla para ingresar una nueva medida, o simplemente escriba la medida en el cuadro de texto.",
              descriptionShow: true,
              expanded: false,
              childrenLevel: 1,
              children: [
                ReactiveDropdownField<String>(
                  isExpanded: true,
                  iconSize: 50,
                  icon: const Icon(Icons.arrow_drop_down, size: 25,),
                  formControlName: FormGroupProduct.getKeyTemplateSize(),
                  style: StyleDropdown.getTextStyle(),
                  decoration: StyleTextField.getDecoration("Selección de plantilla"),
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
                  style: StyleTextArea.getTextStyle(),
                  decoration: StyleTextField.getDecoration("Insertar medida"),
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
          )

        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetCategory(BuildContext context, Product product){
    return ExpansionTileContainerWidget(
        title: "Categoria y subcategoria",
        subtitle: "[Obligatorio] Clasifique el producto de acuerdo a una categoria y subcategoría. Esto es necesario para filtrar resultados.",
        children: [
          ReactiveDropdownField<Category>(
            formControlName: Product.getKeyCategory(),
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Categoria"),
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
          _separadorHeightBlock,
          Visibility(
            visible: _form.control(Product.getKeyCategory()).value.getCategoryID()!=0,
            child: ReactiveDropdownField<SubCategory>(
              formControlName: Product.getKeySubcategory(),
              style: StyleTextField.getTextStyleNormal(),
              decoration: StyleTextField.getDecoration("Subcategoria"),
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
          )
        ]
    );
  }

  ///ProductPriceWidget: Construye el Widget de .
  Widget _buildWidgetTitleBrand(BuildContext context, Product product){

    return ExpansionTileContainerWidget(
        title: "Titulo y marca/importador",
        subtitle: "[Obligatorio] El título es el nombre por el cual se identifica al producto, mientras que la marca (o importadora) identifica "
            "a que marca reconocida (o importadora) lo comercializa (por defecto es IMPORT.).\n",
        children: [
          ReactiveTextField(
            maxLength: Product.getMaxCharsTitle(),
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Título del producto."),
            formControlName: Product.getKeyTitle(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyBrand());
            },
            validationMessages: {
              ValidationMessage.email: (error) => '(Requerido) Ingrese el título del producto.',
            },
          ),
          _separadorHeightBlock,
          SizedBox(
            height: 65,
            child: Row(
                children: [
                  Visibility(
                    visible: !_brandManual,
                    child: Expanded(child: ReactiveDropdownField<String>(
                      formControlName: FormGroupProduct.getKeyBrandAux(),
                      style: StyleTextField.getTextStyleNormal(),
                      decoration: StyleTextField.getDecoration("Buscar marca/importador"),
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
                    )),
                  ),
                  Visibility(
                      visible: _brandManual,
                      child: Expanded(child: ReactiveTextField(
                        maxLines: 1,
                        maxLength: Product.getMaxCharsBrand(),
                        style: StyleTextField.getTextStyleNormal(),
                        decoration: StyleTextField.getDecoration("Marca/importadora"),
                        formControlName: Product.getKeyBrand(),
                        textInputAction: TextInputAction.newline,
                        onChanged: (_){
                          setState(() {});
                        },
                        validationMessages: {
                          ValidationMessage.email: (error) => '(Requerido) Ingrese una marca/importadora para el producto.',
                        },
                      ))
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown.shade200
                    ),
                    margin: EdgeInsets.fromLTRB(5, 0, 0, _brandManual ? 15 : 5),
                    height: _brandManual ? 40 : 50,
                    child: IconButton(
                        icon: Icon(
                          _brandManual ? MdiIcons.fromString("text-box-edit") : MdiIcons.fromString("form-dropdown"),
                          color: Colors.black,
                        ),
                        onPressed: (){
                          setState(() {
                            _brandManual = !_brandManual;
                          });
                        },
                        tooltip: _brandManual ? "Modo actual: Ingreso de marca/importadora" : "Modo actual: Buscador de marca/importador"
                    ),
                  ),
                ]
            ),
          )
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
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Precio público"),
            formControlName: Product.getKeyPricePublic(),
            textInputAction: TextInputAction.none,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyStock());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) El precio al público del producto.",
              ValidationMessage.number: (error) => "(Error) Inserte un número mayor o igual a 0.",
            },
          ),
          _separadorHeightBlock,
          ReactiveTextField<int>(
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Stock"),
            formControlName: Product.getKeyStock(),
            textInputAction: TextInputAction.none,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyMinimumAge());
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
              style: StyleTextArea.getTextStyle(),
              decoration: StyleTextArea.getDecoration("Descripción"),
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
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Edad mínima recomendada"),
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
        title: "Código de barra",
        subtitle: "[Obligatorio] El código de barra debe ser definido ya que permite la búsqueda del producto de manera rápida y sin errores.",
        isRow: true,
        children: [
          Expanded(child: ReactiveTextField(
            maxLength: Product.getMaxCharsBarcode(),
            style: StyleTextField.getTextStyleNormal(),
            decoration: StyleTextField.getDecoration("Código de barras"),
            formControlName: Product.getKeyBarcode(),
            textInputAction: TextInputAction.next,
            onSubmitted: (_){
              setState(() {});
              _form.focus(Product.getKeyTitle());
            },
            validationMessages: {
              ValidationMessage.required: (error) => "(Requerido) Ingrese el código de barras del producto."
            },
          )),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.brown.shade200
            ),
            margin: const EdgeInsets.fromLTRB(5, 0, 0, 25),
            child: IconButton(
                tooltip: "Genera un código de barras.",
                onPressed: () async {
                  String url = ref.read(urlAPIProvider);
                  String code = await GeneratedCodeController.getInstance().generateCode(url, product);
                  _form.control(Product.getKeyBarcode()).value = code;
                },
                icon: Icon(MdiIcons.fromString("barcode"))
            ),
          )
        ],
    );
  }

  //--------------------CONSTRUIR GUI (PRECIOS DE PRODUCTOS)-------------------

  ///ProductPriceWidget: Construye un formulario reactivo de precios de producto.
  Widget _buildReactiveFormProductPrices(BuildContext context, List<Distributor> distributorFree){
    //Precios del producto
    return ReactiveForm(
        formGroup: _formNewPP,
        child: Column(
          children: [
            ExpansionTileContainerWidget(
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
                ExpansionTileContainerWidget(
                    title: "Lista de precios cargados",
                    subtitle: "Aquí se puede observar todos los precios cargados para el producto. Cada precio está agrupado por distribuidora.",
                    childrenLevel: 1,
                    descriptionShow: true,
                    expanded: true,
                    children: [
                      ProductPriceListViewWidget(
                        providerProduct: productProvider,
                        providerPriceDistributor: productPricesByIDProvider,
                      ),
                    ]
                ),
                //Construye el titulo
                _separadorHeightBlock,
                Visibility(
                    visible: distributorFree.isNotEmpty && ref.read(productProvider)!.getID()!=0,
                    child: NewProductPricesWidget(
                      providerProduct: productProvider,
                      formGroup: _formNewPP,
                      childrenLevel: 1,
                      descriptionShow: true,
                    )
                )
              ],
            ),
          ],
        )
    );
  }

  //------------OPERACIONES----------------------------

  ///ProductInformationWidget: Realiza la inserción del producto.
  Future<void> _insert(BuildContext context) async{
    String url = ref.read(urlAPIProvider);
    //Carga los datos del formulario en el producto.
    ref.read(productProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseAPI response = await StateManagerProduct.getInstanceProduct().insert(url, ref.read(productProvider)!);

    if (response.isResponseSuccess()){
      //Notifica con exito en la operacion
      if (context.mounted) ElegantNotificationCustom.showNotificationAPI(context, response);
    }
    else{
      if (context.mounted) ElegantNotificationCustom.showNotificationAPI(context, response);
    }
  }

  ///ProductInformationWidget: Actualiza el producto.
  Future<void> _update(BuildContext context) async{
    String url = ref.read(urlAPIProvider);
    //Carga los datos del formulario en el producto.
    ref.read(productProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseAPI response = await StateManagerProduct.getInstanceProduct().update(url, ref.read(productProvider)!);

    if (response.isResponseSuccess()){
      if (context.mounted) ElegantNotificationCustom.showNotificationAPI(context, response);
    }
    else{
      if (context.mounted) ElegantNotificationCustom.showNotificationAPI(context, response);
    }
  }
}
