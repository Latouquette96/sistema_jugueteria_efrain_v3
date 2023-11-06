import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/drawer/drawer_header_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/directory_config_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/information_config_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/mixin_container.dart';

///Clase DrawerConfiguration: Widget que permite visualizar y cambiar las configuraciones del sistema.
class DrawerConfiguration extends ConsumerStatefulWidget{

  const DrawerConfiguration({super.key});

  @override
  ConsumerState<DrawerConfiguration> createState() {
    return _DrawerConfigurationState();
  }
}

class _DrawerConfigurationState extends ConsumerState<DrawerConfiguration> with ContainerParameters{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getWidgetHeader(context),
        Expanded(child: ListView(
          children: const [
            DirectoryConfigWidget(),
            SizedBox(height: 5,),
            InformationConfigWidget()
          ],
        ))
      ],
    );
  }

  ///DrawerConfiguration: Devuelve el widget de encabezado
  Widget _getWidgetHeader(BuildContext context){
    return DrawerHeaderCustom(
      title: "Configuraciones",
      description: "Permite configurar los directorios de descarga de las imagenes y archivos.",
      width: 500,
      height: 75,
    );
  }
}