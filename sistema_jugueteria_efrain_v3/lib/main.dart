import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/factory/factory_category_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/services/export_to_drive.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/main/tabbedview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FactoryCategoryMySQL.getInstance().builder();
  await FactoryCategory.getInstance().builder();
  await FactoryMinimumAge.getInstance().builder();
  await ConfigurationLocal.getInstance().initialize();
  await ExportToDrive.getInstance().initialize();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Juguetería Efraín',
      home: TabbedViewWidget(),
    );
  }
}