import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/container/expansion_tile_container.dart';
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
    return SizedBox(
        width: 400,
        child: ReactiveForm(
            formGroup: _form,
            child: ExpansionTileContainerWidget(
                borderRadius: 0,
                title: "Informacion",
                descriptionShow: true,
                subtitle: "Muestra/oculta la información de los contenedores expandibles.",
                expanded: false,
                iconLeading: Icons.save,
                functionLeading: () async{
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
                },
                children: [
                  const SizedBox(height: 5,),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: ListTile(
                      title: const Text("Mostrar descripción en bloques expansibles"),
                      subtitle: Row(
                        children: [
                          FlutterSwitch(
                            activeColor: Colors.black.withOpacity(0.65),
                            activeTextColor: Colors.white,
                            inactiveTextColor: Colors.white,
                            width: 50,
                            height: 25,
                            toggleSize: 22.5,
                            borderRadius: 20,
                            value: _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value,
                            showOnOff: false,
                            onToggle: (bool val) async {
                              try{
                                setState(() {
                                  _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value = !_form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value;
                                });
                              }
                              // ignore: empty_catches
                              catch(e){}
                            },
                          ),
                          const SizedBox(width: 5,),
                          Expanded(child: Text(
                            _form.control(ConfigurationLocal.getKeyInfoExpansionTile()).value
                                ? "Información visible."
                                : "Información oculta.",
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          )),
                        ],
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }

}