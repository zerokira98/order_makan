import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/use_app/bloc/struk/struk_bloc.dart';
// import 'package:order_makan/use_app/bloc/menuitems_bloc.dart';
import 'package:order_makan/use_app/component/ordertile.dart';
import 'package:order_makan/use_app/component/menu_card.dart';
import 'package:order_makan/use_app/component/struk_panel.dart';
import 'package:order_makan/use_app/component/toptab.dart';

class UseMain extends StatefulWidget {
  const UseMain({super.key});

  @override
  State<UseMain> createState() => _UseMainState();
}

class _UseMainState extends State<UseMain> {
  int listLength = 1;
  void ontap() {
    setState(() {
      listLength = listLength + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StrukBloc(),
        ),
      ],
      child: BlocListener<TopbarBloc, TopbarState>(
        listenWhen: (p, c) => p.selected != c.selected,
        listener: (context, state) {
          BlocProvider.of<MenuBloc>(context)
              .add(ChangeCat(catName: state.selected ?? '[ALL]'));
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Resto [NAME]'),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(child: TopTab()),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(2)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<MenuBloc, MenuState>(
                              builder: (context, state) {
                                // if (state.menus.isEmpty) {
                                //   return const Center(child: Text('empty'));
                                // }
                                return Expanded(
                                  child: Wrap(
                                    children: [
                                      for (var i = 0;
                                          i < state.datas.length;
                                          i++)
                                        MenuCard(
                                          onTap: ontap,
                                          menudata: state.datas[i],
                                        )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
              StrukPanel()
            ],
          ),
        ),
      ),
    );
  }
}
