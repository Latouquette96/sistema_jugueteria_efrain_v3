import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/statistics/statistics_provider.dart';

class ScreenStatistics extends ConsumerStatefulWidget {
  const ScreenStatistics({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenStatisticsState();
  }
}

class _ScreenStatisticsState extends ConsumerState<ConsumerStatefulWidget>{



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
        body: Container(
          decoration: ContainerStyle.getContainerRoot(),
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                decoration: ContainerStyle.getContainerChild(),
                child: FutureBuilder<ResponseAPI>(
                    future: ref.read(statisticsEstimatedTotalProvider.future),
                    builder: (context, snap){
                      if (snap.hasData){

                        if (snap.data!.isResponseSuccess()){
                          return ListTile(
                            title: Text("Monto total estimado: \$ ${snap.data!.getValue()['total']}", style: StyleForm.getTextStyleTitle(),),
                            subtitle: Text("Stock total estimado: ${snap.data!.getValue()['stock']}", style: StyleForm.getTextStyleListTileSubtitle()),
                          );
                        }
                        else{
                          return ListTile(
                            title: Text("Monto total estimado: \$ -", style: StyleForm.getTextStyleTitle(),),
                            subtitle: Text("Stock total estimado: -", style: StyleForm.getTextStyleListTileSubtitle()),
                          );
                        }
                      }
                      else{
                        if (snap.hasError){
                          return ListTile(
                            title: Text("Monto total estimado: Error", style: StyleForm.getTextStyleTitle(),),
                            subtitle: Text("Stock total estimado: Error", style: StyleForm.getTextStyleListTileSubtitle()),
                          );
                        }
                        else{
                          return const SizedBox(
                            height: 200,
                            width: 200,
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    }
                ),
              ),
            ],
          )
        )
    );
  }

}