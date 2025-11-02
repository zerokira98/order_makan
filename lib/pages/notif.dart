import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/notif/notif_cubit.dart';
import 'package:order_makan/model/ingredient_model.dart';

class NotifCenter extends StatelessWidget {
  const NotifCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
      ),
      body: Row(
        children: [
          // Expanded(
          //   child: BlocBuilder<NotifCubit, NotifState>(
          //     builder: (context, state) {
          //       return Column(
          //         children: [
          //           Text('Stock'),
          //           for (var e in state.ingredients)
          //             ListTile(
          //               title: Text(e.title),
          //               subtitle: Text(e.count.toString() + e.satuan),
          //             ),
          //         ],
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: BlocBuilder<NotifCubit, NotifState>(
              builder: (context, state) {
                // var ingredients = state.notif.map((e) => IngredientItem(title: e.title, satuan: e.content, count: e.content),)
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Alert'),
                    for (var e in state.notif)
                      ListTile(
                        title: Text(e.title),
                        style: ListTileStyle.drawer,
                        subtitle: Text('in stock:${e.content}'),
                        tileColor: state.notif.any(
                          (element) => element.title == e.title,
                        )
                            ? Colors.red.shade200
                            : Colors.transparent,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
