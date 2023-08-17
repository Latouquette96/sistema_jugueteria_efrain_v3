import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/image/image_product_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';

///Clase ProductInformationWidget: Permite mostrar y actualizar la información de un producto.
class ProductInformationWidget extends ConsumerStatefulWidget {
  const ProductInformationWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductInformationWidgetState();
  }
}

class _ProductInformationWidgetState extends ConsumerState<ConsumerStatefulWidget> with ContainerParameters {

  late final FormGroup _form;

  static const String _keyTemplateSize = "pp_template_size";
  static final String _keySizeAux = "${Product.getKeySizes()}Aux";
  static final String _keyBrandAux = "${Product.getKeyBrand()}Aux";

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

  @override
  void initState() {
    super.initState();

    Pair<Category?, SubCategory?> pairCategory = FactoryCategory.getInstance().search(ref.read(productProvider)!=null ? ref.read(productProvider)!.getSubcategory() : 0);
    
    _form = FormGroup({
      Product.getKeyID(): FormControl<int>(
        value: ref.read(productProvider)?.getID(),
      ),
      Product.getKeyBarcode(): FormControl<String>(
        value: ref.read(productProvider)?.getBarcode(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsBarcode())]
      ),
      Product.getKeyInternalCode(): FormControl<String>(
        value: ref.read(productProvider)?.getInternalCode(),
      ),
      Product.getKeyTitle(): FormControl<String>(
        value: ref.read(productProvider)?.getTitle(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsTitle())]
      ),
      _keyBrandAux: FormControl<String>(
        value: ref.read(productProvider)?.getBrand()
      ),
      Product.getKeyBrand(): FormControl<String>(
        value: ref.read(productProvider)?.getBrand(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsBrand())]
      ),     
      Product.getKeyDescription(): FormControl<String>(
        value: ref.read(productProvider)?.getDescription(),
        validators: [Validators.required, Validators.maxLength(Product.getMaxCharsDescription())]
      ),
      Product.getKeySizes(): FormControl<List<String>>(
        value: ref.read(productProvider)?.getSizes(),
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
        value: ref.read(productProvider)?.getStock(),
        validators: [Validators.required, Validators.number, Validators.min<int>(-1)]
      ),
      Product.getKeyPricePublic(): FormControl<double>(
        value: ref.read(productProvider)?.getPricePublic(),
        validators: [Validators.required, Validators.number]
      ),
      Product.getKeyImages(): FormControl<List<ResourceLink>>(
        value: ref.read(productProvider)?.getLinkImages(),
        validators: [Validators.required]
      ),
      Product.getKeyMinimumAge(): FormControl<MinimumAge>(
        value: FactoryMinimumAge.getInstance().search(ref.read(productProvider)?.getMinimumAge() ?? 0),
        validators: [Validators.required]
      ),
      Product.getKeyDateCreated(): FormControl<String>(
        value: ref.read(productProvider)!.getDateCreate(),
        validators: [Validators.required]
      ),
      Product.getKeyDateUpdated(): FormControl<String>(
        value: ref.read(productProvider)!.getDateUpdate(),
        validators: [Validators.required]
      ),
      _keyTemplateSize: FormControl<String>(
        value: ""
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    //Recupera todos los enlaces
    List<ResourceLink> listLink = _form.control(Product.getKeyImages()).value;
    List<Widget> listImage = [];
    Product p = ref.watch(productProvider)!;
    bool isNewProduct = p.getID()==0;

    if (listLink.isNotEmpty){
      listImage = listLink.asMap().entries.map((e){
        return ImageProductWidget(
          product: isNewProduct ? null : p, 
          index: e.key, 
          isTemporal: isNewProduct,
          linkTemporal: isNewProduct ? e.value : null,
          onRemoved: (){
            (_form.control(Product.getKeyImages()).value as List<ResourceLink>).removeAt(e.key);
            setState(() {});
          }, 
          onSelected: (){}
        );
      }).toList();
    }
    
    return Container(
      width: 400,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: StyleForm.getDecorationPanel(),
      child: Column(
        children: [
          //Encabezado principal.
          HeaderInformationWidget(
              titleHeader: "Información Producto",
              tooltipClose: "Cerrar información del producto.",
              onClose: (){
                ref.read(productProvider.notifier).free();
              },
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              child: ReactiveForm(
                formGroup: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Categoria y subcategoria.
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReactiveDropdownField<Category>(
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
                          Visibility(
                            visible: _form.control(Product.getKeyCategory()).value.getCategoryID()!=0,
                            child: ReactiveDropdownField<SubCategory>(
                              formControlName: Product.getKeySubcategory(),
                              style: StyleForm.getStyleTextField(),
                              decoration: StyleForm.getDecorationTextField("Subcategoria"),
                              items: (_form.control(Product.getKeyCategory()).value as Category).getListSubcategory().map((e) => DropdownMenuItem<SubCategory>(
                                value: e,
                                child: Text(e.getSubCategoryName()),
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
                        ],
                      ),
                    ),
                    //Control: Imagen
                    Container(
                      height: listImage.isEmpty ? 100 : 300,
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Carousel de Imágenes del producto", style: StyleForm.getStyleTextTitle(),),
                          Visibility(
                            visible: listImage.isNotEmpty,
                            child: SizedBox(
                              height: 200,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listImage,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: StyleForm.getStyleElevatedButtom(),
                                onPressed: () async {
                                  ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
                                  
                                  if (cdata!=null){
                                    String textData = cdata.text!;
                                    if (textData.contains(',')){
                                      for (String textLink in textData.split(',')){
                                        if (textLink.isNotEmpty){
                                          _form.control(Product.getKeyImages()).value.add(ResourceLink(textLink));
                                        }
                                      }
                                    }
                                    else{
                                      _form.control(Product.getKeyImages()).value.add(ResourceLink(cdata.text!));
                                    }
                                    setState(() {});
                                  }
                                }, 
                                child: const Text("Insertar link")
                              ),
                            ],
                          )
                        ],
                      )
                    ),
                    //Codigo de barras.
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField(
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
                    ),                 //Código interno.
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField(
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
                    ),
                    //Titulo
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField(
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
                          ),
                    ),
                    //Marca/importador
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: Column(
                        children: [
                          ReactiveTypeAhead<String, String>(
                            formControlName: _keyBrandAux,
                            stringify: (_) => _,
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
                              decoration: StyleForm.getDecorationTextField("Marca/importador"),
                            ),
                            suggestionsCallback: (pattern) async {
                              return ref.watch(filterOfLoadedBrandsWithAPIProvider).where((element) => element.contains(pattern));
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                leading: Icon(MdiIcons.fromString("arrow-right-bold")),
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected:(suggestion) {
                              _form.control(Product.getKeyBrand()).value = suggestion;
                              setState(() {});
                              _form.focus(Product.getKeyBrand());
                            }, 
                          ),
                          const SizedBox(height: 10,),
                          ReactiveTextField(
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
                          ),
                        ],
                      )
                    ),
                    //Descripción
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      height: 200,
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField(
                            maxLines: 8,
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
                    ),
                    //Stock
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField<int>(
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
                    ),
                    //Precio Público
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveTextField<double>(
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
                    ), 
                    //Edad minima recomendada
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      decoration: StyleForm.getDecorationFormControl(),
                      child: ReactiveDropdownField<MinimumAge>(
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
                          ),
                    ),
                    //Medidas del producto
                    Container(
                      margin: getMarginInformationForms(),
                      padding: getPaddingInformationForms(),
                      height: (_form.control(Product.getKeySizes()).value as List<String>).length>3 
                        ? 400 
                        : 220.0 + 50.0*(_form.control(Product.getKeySizes()).value as List<String>).length,
                      decoration: StyleForm.getDecorationFormControl(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Medidas del producto", style: StyleForm.getStyleTextTitle(),),
                            Expanded(child: 
                              Container(
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReactiveDropdownField<String>(
                              isExpanded: true,
                              iconSize: 50,
                              icon: const Icon(Icons.arrow_drop_down, size: 25,),
                              formControlName: _keyTemplateSize,
                              style: StyleForm.getStyleDropdownField(),
                              decoration: StyleForm.getDecorationTextField("Selección de plantilla"),
                              items: _templateSize.map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Container(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  width: 300,
                                  child: Text(e),
                                ),
                              )).toList(),
                              onChanged: (control) {
                                _form.control(_keySizeAux).value = _form.control(_keyTemplateSize).value;
                                setState(() {});
                                _form.focus(_keySizeAux);
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
                              formControlName: _keySizeAux,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_){
                                List<String> list = _form.control(Product.getKeySizes()).value;
                                list.add(_form.control(_keySizeAux).value);
                                
                                _form.control(_keySizeAux).value = "";
                                _form.focus(_keySizeAux);

                                setState(() { });
                              },
                              validationMessages: {
                                ValidationMessage.email: (error) => '(Requerido) Ingrese una descrición para el producto.',
                              },
                            ),
                          ],
                        ),
                    ),
                    
                    const SizedBox(
                      height: 25,
                    )
                  ],
            )
          ))),
          //Boton Enviar
          Container(
            margin: getMarginInformationForms(),
            padding: getPaddingInformationForms(),
            decoration: StyleForm.getDecorationFormControl(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: ElevatedButton(
                  style: StyleForm.getStyleElevatedButtom(),
                  onPressed: (){
                    bool isError = false;
                    ref.read(productProvider)?.fromJSON(_form.value);
                    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
                    AsyncValue<Response> response = (ref.read(productProvider)!.getID()==0) 
                      ? ref.watch(newProductWithAPIProvider)
                      : ref.watch(updateProductWithAPIProvider);
                                    
                    //Realiza la peticion de modificacion y analiza la respuesta obtenida.
                    response.when(
                      data: (data){
                        isError = false;
                      }, 
                      error: (err, stack){
                        isError = true;
                      }, 
                      loading: (){null;}
                    );

                    //Si no ocurre error, entonces se procede a notificar del éxito de la operación y a cerrar el widget.
                    if (isError==false){
                      ElegantNotification.success(
                        title:  const Text("Información"),
                        description:  const Text("La información ha sido actualizada con éxito.")
                      ).show(context);

                      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
                      ref.read(productProvider.notifier).free();
                      setState(() {});
                    }
                    else{
                      //Caso contrario, mostrar notificación de error.
                      ElegantNotification.error(
                        title:  const Text("Error"),
                        description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                      ).show(context);
                    }
                  } ,
                  child: const Text('Guardar cambios'),
                )),
              ],
            )
          ),
        ],
      ),
    );
  }
}