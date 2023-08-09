import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/main/mainbar_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabbedview_provider.dart';

///TabbedViewWidget: Muestra el contenido de un tabbedview haciendo uso de tabs que se insertan dinámicamente.
class TabbedViewWidget extends ConsumerWidget {
  const TabbedViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     // Reconstruir el widget cuando cambia la lista de `todos`
    List<TabModel> tabs = ref.watch(tabProvider);

    return MaterialApp(
      home: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 30,
            title: MainBarWidget(key: GlobalKey()),
          ),
          body: Container(
            margin: const EdgeInsets.all(0),
            child: (tabs.isEmpty)
              ? Container(color: Colors.white,)
              : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    color: Colors.black87,
                    height: 40,
                    child: TabBar(
                      indicator: const BoxDecoration(color: Color.fromARGB(255, 83, 83, 84),),
                      indicatorColor: Colors.blue,
                      indicatorWeight: 5,
                      labelColor: Colors.yellow,
                      dividerColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      tabs: tabs.map((e) => Tab(icon: SizedBox(
                        width: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(e.iconData),
                            Text(e.label), 
                          ],
                        ),
                      ), iconMargin: const EdgeInsets.all(5),)).toList(),
                      tabAlignment: TabAlignment.center
                    ),
                  ),
                  Expanded(child: TabBarView(
                    children: tabs.map((e) => Container(
                      decoration: const BoxDecoration(color: Color.fromARGB(209, 83, 83, 84), border: BorderDirectional(
                        start: BorderSide(color: Color.fromARGB(255, 60, 60, 60), width: 3),
                        top: BorderSide(color: Color.fromARGB(209, 83, 83, 84), width: 3),
                        end: BorderSide(color: Color.fromARGB(255, 34, 34, 34), width: 3),
                        bottom: BorderSide(color: Color.fromARGB(255, 47, 47, 47), width: 3),
                      )),
                      padding: const EdgeInsets.all(10),
                      child: e.widget,
                    )).toList(),
                  ))
                ],
            ),
          )),
        ),
      );
  }
}