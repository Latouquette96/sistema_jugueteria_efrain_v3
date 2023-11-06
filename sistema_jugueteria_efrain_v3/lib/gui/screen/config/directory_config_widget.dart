import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
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
    return SizedBox(
        width: 400,
        child: ReactiveForm(
            formGroup: _form,
            child: ExpansionTileContainerWidget(
                borderRadius: 0,
                title: "Directorio descarga",
                descriptionShow: true,
                subtitle: "Permite definir los directorios donde se descargarán los distintos recursos (imágenes, documentos, etc).",
                expanded: false,
                iconLeading: Icons.save,
                functionLeading: () async{
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
                },
                children: [
                  SizedBox(
                    height: 75,
                    child: Row(
                      children: [
                        Expanded(
                            child: ReactiveTextField(
                                style: StyleTextField.getTextStyleNormal(),
                                decoration: StyleTextField.getDecoration("Imágenes descargadas"),
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
                  ),
                  SizedBox(
                    height: 75,
                    child: Row(
                      children: [
                        Expanded(
                            child: ReactiveTextField(
                                style: StyleTextField.getTextStyleNormal(),
                                decoration: StyleTextField.getDecoration("Catálogos de productos"),
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
                  ),
                  SizedBox(
                    height: 75,
                    child: Row(
                      children: [
                        Expanded(
                            child: ReactiveTextField(
                                style: StyleTextField.getTextStyleNormal(),
                                decoration: StyleTextField.getDecoration("Facturas descargadas"),
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
                  ),
                  SizedBox(
                    height: 75,
                    child: Row(
                      children: [
                        Expanded(
                            child: ReactiveTextField(
                                style: StyleTextField.getTextStyleNormal(),
                                decoration: StyleTextField.getDecoration("Archivos de ventas realizadas"),
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
                  ),
                ],
            )
        )
    );
  }

}