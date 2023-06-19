import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';

import 'package:order_makan/use_app/bloc/struk/struk_bloc.dart';
import 'package:order_makan/use_app/component/menu_card.dart';
import 'package:order_makan/use_app/component/ordertile.dart';
import 'package:order_makan/use_app/component/struk_panel.dart';
import 'package:order_makan/use_app/component/toptab.dart';

class EditMain extends StatelessWidget {
  const EditMain({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return BlocListener<TopbarBloc, TopbarState>(
      listenWhen: (p, c) => p.selected != c.selected,
      listener: (context, state) {
        BlocProvider.of<MenuBloc>(context)
            .add(ChangeCat(catName: state.selected ?? '[ALL]'));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit app'),
        ),
        body: Row(
          children: [
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
                  Expanded(child: BlocBuilder<MenuBloc, MenuState>(
                      builder: (context, state) {
                    return Wrap(
                      children: List.generate(
                          state.datas.length + 1,
                          (index) => (index < state.datas.length)
                              ? MenuCard(
                                  onTap: () {},
                                  menudata: state.datas[index],
                                  editmode: true,
                                )
                              : const EmptyMenuCard()),
                    );
                  })),
                  // Expanded(
                  //   child: BlocBuilder<MenuitemsBloc, MenuitemsState>(
                  //     builder: (context, state) {
                  //       if (state.menus.isEmpty) {
                  //         return const Center(child: Text('empty'));
                  //       }
                  //       return Wrap(
                  //         children: [
                  //           for (var i = 0; i < state.menus.length; i++)
                  //             MenuCard(
                  //               onTap: ontap,
                  //               menudata: state.menus[i],
                  //             )
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 24,
                          color: Colors.orange,
                          child: const Text('BottomBar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StrukPanel(),
          ],
        ),
      ),
    );
  }
}
