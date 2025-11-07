import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';

import 'package:order_makan/component/menu_card.dart';
import 'package:order_makan/component/toptab.dart';
import 'package:order_makan/pages/admin_panel/admin_drawer.dart';

class EditMain extends StatelessWidget {
  const EditMain({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Edit app'),
      // ),
      body: Row(
        children: [
          Expanded(flex: 3, child: AdminDrawer()),
          Padding(padding: EdgeInsetsGeometry.all(2)),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                        child: TopTab(
                      edit: true,
                    )),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(2)),
                Expanded(child:
                    BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
                  return GridView.count(
                    childAspectRatio: 0.98,
                    crossAxisCount: 4,
                    children: <Widget>[
                      for (var i = 0; i < state.datas.length; i++)
                        MenuCard(
                          key: Key(state.datas[i].hashCode.toString()),
                          onTap: () {},
                          editmode: true,
                          menudata: state.datas[i],
                        ),
                      EmptyMenuCard()
                    ],
                  );
                })),
              ],
            ),
          ),
          // const Expanded(
          //     flex: 3,
          //     child: Center(
          //       child: Text('struk edit not available'),
          //     ))
        ],
      ),
    );
  }
}
