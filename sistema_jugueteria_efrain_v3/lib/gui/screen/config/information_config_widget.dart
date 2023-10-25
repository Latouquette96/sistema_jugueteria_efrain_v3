import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_elevated_button.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

///InformationConfigWidget: Widgwt para mostrar las configuraciones generales del sistema.
class InformationConfigWidget extends ConsumerStatefulWidget {
  const InformationConfigWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _InformationConfigWidgetState();
  }

}

class _InformationConfigWidgetState extends ConsumerState<InformationConfigWidget>{

  late final FormGroup _form;

  @override
  void initState() {
    super.initState();

    _form = FormGroup({
      ConfigurationLocal.getKeyInfoExpansionTile(): FormControl<bool>(value: ref.read(configurationProvider).isShowInfoExpansionTile()),
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
              titleHeader: "Configuración: Información (visibilidad)",
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
                                          child: Container(
                                            decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
                                                start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 1),
                                                top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 1),
                                                end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 1),
                                                bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 1),
                                              ),
                                            borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                              _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value
                                                  ? "Información de ayuda mostrada en los bloques expansivos"
                                                  : "Información de ayuda oculta en los bloques expansivos",
                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                            ),
                                          )
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            try{
                                              setState(() {
                                                _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value = !_form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value;
                                              });
                                            }
                                            // ignore: empty_catches
                                            catch(e){}
                                          },
                                          icon: Icon(
                                            _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value
                                                ? MdiIcons.fromString("check-circle")
                                                : MdiIcons.fromString("check-circle-outline"),
                                            color: _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value
                                                ? Colors.yellow
                                                : Colors.grey,
                                          )
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
                                            await ref.read(configurationProvider).setInfoExpansionTile(_form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value);
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