import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';

class StrukitemeditDialog extends StatefulWidget {
  final StrukItem strukItem;
  final MenuItems menuItems;
  const StrukitemeditDialog(
      {super.key, required this.strukItem, required this.menuItems});

  @override
  State<StrukitemeditDialog> createState() => _StrukitemeditDialogState();
}

class _StrukitemeditDialogState extends State<StrukitemeditDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.strukItem.title,
              textScaler: TextScaler.linear(1.15),
            ),
            Padding(padding: EdgeInsetsGeometry.all(4)),
            BlocBuilder<UseStrukBloc, UseStrukState>(
              builder: (context, state) {
                if (widget.menuItems.submenues.isEmpty) {
                  return Text('No Submenu');
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.menuItems.submenues.length,
                    (index) {
                      var submenutitle =
                          widget.menuItems.submenues[index].title;
                      bool added = state.orderItems
                          .singleWhere(
                            (element) =>
                                element.cardId == widget.strukItem.cardId,
                          )
                          .submenues
                          .any(
                            (element) => element.title == submenutitle,
                          );
                      return InkWell(
                        onTap: () {
                          debugPrint(added.toString());
                          // debugPrint(state.orderItems
                          //     .singleWhere(
                          //       (element) =>
                          //           element.title == widget.strukItem.title,
                          //     )
                          //     .submenues);
                          // debugPrint(submenutitle);
                          if (added) {
                            BlocProvider.of<UseStrukBloc>(context).add(
                                DeleteSubmenu(widget.menuItems.submenues[index],
                                    widget.strukItem));
                          } else {
                            BlocProvider.of<UseStrukBloc>(context).add(
                                AddSubmenu(widget.menuItems.submenues[index],
                                    widget.strukItem));
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.all(8),
                          borderOnForeground: added,
                          surfaceTintColor: added ? Colors.grey.shade800 : null,
                          elevation: added ? 1 : 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(submenutitle),
                                Text(widget
                                    .menuItems.submenues[index].adjustHarga
                                    .numberFormat(currency: true)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
