import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_elevated_button.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

///DirectoryConfigWidget: Widgwt para mostrar las configuraciones generales del sistema.
class DirectoryConfigWidget extends ConsumerStatefulWidget {
  const DirectoryConfigWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DirectoryConfigWidgetState();
  }

}

class _DirectoryConfigWidgetState extends ConsumerState<DirectoryConfigWidget>{

  late final FormGroup _form;

  @override
  void initState() {
    super.initState();

    _form = FormGroup({
      ConfigurationLocal.getKeyImagePath():   FormControl<String>(value: ref.read(configurationProvider).getValueImagePath()),
      ConfigurationLocal.getKeyCatalogPath(): FormControl<String>(value: ref.read(configurationProvider).getValueCatalogPath()),
      ConfigurationLocal.getKeyBillingPath(): FormControl<String>(value: ref.read(configurationProvider).getValueBillingPath()),
      ConfigurationLocal.getKeyShopPath():    FormControl<String>(value: ref.read(configurationProvider).getValueShopPath()),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
          start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        )),
        child: Column(
          children: [
            //Encabezado principal.
            const HeaderInformationWidget(
              titleHeader: "Configuración: Directorios",
            ),
            Expanded(
              child: ReactiveForm(
                  formGroup: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ReactiveTextField(
                                              style: StyleForm.getStyleTextField(),
                                              decoration: StyleForm.getDecorationTextField("Directorio de imágenes descargadas"),
                                              formControlName: ConfigurationLocal.getKeyImagePath(),
                                              textInputAction: TextInputAction.next
                                          )
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            try{
                                              //Desplegar para seleccionar directorio.
                                              String? directory = await getDirectoryPath();
                                              if (directory!=null){
                                                setState(() {
                                                  _form.control(ConfigurationLocal.getKeyImagePath()).value = directory;
                                                });
                                              }
                                            }
                                            // ignore: empty_catches
                                            catch(e){}
                                          },
                                          icon: Icon(MdiIcons.fromString("folder"))
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ReactiveTextField(
                                              style: StyleForm.getStyleTextField(),
                                              decoration: StyleForm.getDecorationTextField("Directorio de catálogos de productos generados"),
                                              formControlName: ConfigurationLocal.getKeyCatalogPath(),
                                              textInputAction: TextInputAction.next
                                          )
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            try{
                                              //Desplegar para seleccionar directorio.
                                              String? directory = await getDirectoryPath();
                                              if (directory!=null){
                                                setState(() {
                                                  _form.control(ConfigurationLocal.getKeyCatalogPath()).value = directory;
                                                });
                                              }
                                            }
                                            // ignore: empty_catches
                                            catch(e){}
                                          },
                                          icon: Icon(MdiIcons.fromString("folder"))
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ReactiveTextField(
                                              style: StyleForm.getStyleTextField(),
                                              decoration: StyleForm.getDecorationTextField("Directorio de facturas descargadas"),
                                              formControlName: ConfigurationLocal.getKeyBillingPath(),
                                              textInputAction: TextInputAction.next
                                          )
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            try{
                                              //Desplegar para seleccionar directorio.
                                              String? directory = await getDirectoryPath();
                                              if (directory!=null){
                                                setState(() {
                                                  _form.control(ConfigurationLocal.getKeyBillingPath()).value = directory;
                                                });
                                              }
                                            }
                                            // ignore: empty_catches
                                            catch(e){}
                                          },
                                          icon: Icon(MdiIcons.fromString("folder"))
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ReactiveTextField(
                                              style: StyleForm.getStyleTextField(),
                                              decoration: StyleForm.getDecorationTextField("Directorio de archivos de ventas realizadas"),
                                              formControlName: ConfigurationLocal.getKeyShopPath(),
                                              textInputAction: TextInputAction.next
                                          )
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            try{
                                              //Desplegar para seleccionar directorio.
                                              String? directory = await getDirectoryPath();
                                              if (directory!=null){
                                                setState(() {
                                                  _form.control(ConfigurationLocal.getKeyShopPath()).value = directory;
                                                });
                                              }
                                            }
                                            // ignore: empty_catches
                                            catch(e){}
                                          },
                                          icon: Icon(MdiIcons.fromString("folder"))
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: ElevatedButton(
                                        style: StyleElevatedButton.getStyleElevatedButtom(),
                                        onPressed: () async{
                                          if(_form.valid){
                                            await ref.read(configurationProvider).setValueImagePath(_form.control(ConfigurationLocal.getKeyImagePath()).value);
                                            await ref.read(configurationProvider).setValueBillingPath(_form.control(ConfigurationLocal.getKeyBillingPath()).value);
                                            await ref.read(configurationProvider).setValueCatalogPath(_form.control(ConfigurationLocal.getKeyCatalogPath()).value);
                                            await ref.read(configurationProvider).setValueShopPath(_form.control(ConfigurationLocal.getKeyShopPath()).value);
                                            setState(() {});

                                            if (mounted){
                                              ElegantNotification.success(
                                                  title: const Text("Información actualizada"),
                                                  description:  const Text("La configuracion del sistema fue actualizada con éxito.")
                                              ).show(context);
                                            }
                                          }
                                          else{
                                            if (mounted){
                                              ElegantNotification.error(
                                                  title: const Text("Error"),
                                                  description:  const Text("Error: Verifique que todos los campos estén completos.")
                                              ).show(context);
                                            }
                                          }
                                        } ,
                                        child: const Text('Guardar cambios'),
                                      )),
                                    ],
                                  ),
                                ]
                            ),
                          )
                      ),
                    ],
                  )
              ),
            )
          ],
        )
    );
  }

}