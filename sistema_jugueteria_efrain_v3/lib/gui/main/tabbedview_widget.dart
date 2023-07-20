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
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.black87,
                  height: 30,
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.yellow,
                    dividerColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    tabs: tabs.map((e) => Tab(text: e.label,)).toList()
                  ),
                ),
                Expanded(child: TabBarView(
                  children: tabs.map((e) => Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.grey.shade600,
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