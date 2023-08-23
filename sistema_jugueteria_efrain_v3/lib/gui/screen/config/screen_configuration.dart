import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

class ScreenConfiguration extends ConsumerStatefulWidget {
  const ScreenConfiguration({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenConfigurationState();
  }
}

class _ScreenConfigurationState extends ConsumerState<ConsumerStatefulWidget>{

  late final FormGroup _form;
  late final ConfigurationLocal _config;

  @override
  void initState() {
    super.initState();
    //Obtiene la configuracion actual
    _config = ConfigurationLocal.getInstance();
    //Crea el mapeo de clave-control del formulario.
    Map<String, FormControl<String>> map = {};
    map.addEntries(_config.getKeys().map((e){
        return MapEntry(e, FormControl<String>(value: _config.getValue(e)));
      }));

    _form = FormGroup(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [SizedBox(width: 36,child: Icon(MdiIcons.fromString("cog"),),), const Expanded(child: Text("Configuraciones"))],
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        toolbarHeight: 40,
        titleTextStyle: const TextStyle(fontSize: 16),
      ),
      body: Container(
        width: 400,
        margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
          start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
          bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        )),
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
                      ... 
                      _config.getKeys().map((e){
                        return Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                style: StyleForm.getStyleTextField(),
                                decoration: StyleForm.getDecorationTextField(_config.getTitle(e)??""),
                                formControlName: e,
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
                                      _form.control(e).value = directory;
                                  });
                                  }
                                }
                                // ignore: empty_catches
                                catch(e){}
                              }, 
                              icon: Icon(MdiIcons.fromString("folder"))
                            )
                          ],
                        );
                      }),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: _form.valid ? Colors.blue : Colors.grey),
                            onPressed: () async{
                              if(_form.valid){
                                //Escribe los nuevos cambios realizados en la configuracion local.
                                await _config.setValueMap(_form.value as Map<String, String>);
                                setState(() {});
                              }
                            } ,
                            child: const Text('Guardar cambios'),
                          )),
                        ],
                      )
                    ]
                  ),
                )
              ),
              const SizedBox(
                height: 25,
              )
          ],
        )
      ))
    );
  }

}