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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.strukItem.title,
              textScaler: TextScaler.linear(1.15),
            ),
            Text(
              'Submenu',
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
                        child: AnimatedContainer(
                          duration: Durations.short4,
                          transform: Matrix4.identity()
                            ..translate(0.0, added ? 2.0 : 0.0),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(12),
                              color: added
                                  ? Colors.green.shade800
                                  : Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                    // blurRadius: added ? 0 : 1,
                                    spreadRadius: added ? 0 : 1,
                                    color: Colors.black54,
                                    offset: added ? Offset(0, 0) : Offset(2, 2))
                              ]),
                          // borderOnForeground: added,
                          // elevation: added ? 1 : 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  submenutitle,
                                  style: added
                                      ? Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white)
                                      : Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  widget.menuItems.submenues[index].adjustHarga
                                      .numberFormat(currency: true),
                                  style: added
                                      ? Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white)
                                      : Theme.of(context).textTheme.titleSmall,
                                ),
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
