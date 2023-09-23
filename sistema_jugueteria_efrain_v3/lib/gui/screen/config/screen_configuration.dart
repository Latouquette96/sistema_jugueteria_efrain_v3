import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/config/directory_config_widget.dart';

class ScreenConfiguration extends ConsumerStatefulWidget {
  const ScreenConfiguration({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenConfigurationState();
  }
}

class _ScreenConfigurationState extends ConsumerState<ConsumerStatefulWidget>{



  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.grey.shade700,
      body: const Row(
        children: [
          DirectoryConfigWidget()
        ],
      )
    );
  }

}