import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'dart:math' as math;

import 'package:order_makan/pages/use_app/struk_panel/strukitemedit_dialog.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

class OrderTile extends StatefulWidget {
  final int index;
  // final MenuItems menudata;
  const OrderTile({
    super.key,
    required this.index,
    // required this.menudata,
    // required this.data
  });

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile>
    with SingleTickerProviderStateMixin {
  late AnimationController ac;
  Tween<double> ani = Tween(begin: 0.0, end: 1.0);
  late Animation ca;
  @override
  void initState() {
    ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    ca = CurvedAnimation(parent: ac, curve: Curves.bounceInOut).drive(ani);

    super.initState();
  }

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UseStrukBloc, UseStrukState>(
      builder: (context, state) {
        return BlocListener<UseStrukBloc, UseStrukState>(
          listenWhen: (p, c) => c.error.code != 0,
          listener: (context, state) {
            if (state.error.msg == state.orderItems[widget.index].title) {
              ac.forward().then((value) => ac.reverse());
              BlocProvider.of<UseStrukBloc>(context).add(ClearErrMsg());
            }
          },
          child: AnimatedBuilder(
            animation: ac,
            builder: (context, child) => Transform.translate(
              offset: Offset(math.sin((ac.value * math.pi)) * 2.0, 0.0),
              child: Container(
                color: Colors.red.withValues(alpha: ca.value),
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('${widget.index + 1}. '),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                var menuitem = await RepositoryProvider.of<
                                        MenuItemRepository>(context)
                                    .getMenus(
                                        title: state
                                            .orderItems[widget.index].title);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StrukitemeditDialog(
                                        strukItem:
                                            state.orderItems[widget.index],
                                        menuItems: menuitem);
                                  },
                                );
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                              // var tc = TextEditingController(
                              //     text:
                              //         state.orderItems[widget.index].catatan);

                              // return AlertDialog(
                              //   // actions: [
                              //   //   ElevatedButton(
                              //   //       onPressed: () {}, child: Text("Save"))
                              //   // ],
                              //   title: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text("Catatan"),
                              //       ElevatedButton(
                              //           onPressed: () {
                              //             BlocProvider.of<UseStrukBloc>(
                              //                     context)
                              //                 .add(ChangeCatatan(
                              //                     tc.text,
                              //                     state.orderItems[
                              //                         widget.index]));
                              //             Navigator.pop(context);
                              //           },
                              //           child: Text("Save"))
                              //     ],
                              //   ),
                              //   content: TextField(
                              //     controller: tc,
                              //     minLines: 2,
                              //     maxLines: 2,
                              //     decoration:
                              //         InputDecoration(label: Text('Catatan')),
                              //   ),
                              // );
                            },
                            child: Text(state
                                .orderItems[widget.index].title.firstUpcase),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              BlocProvider.of<UseStrukBloc>(context).add(
                                  DecreaseCount(
                                      item: state.orderItems[widget.index]));
                              // if (count < 1) return;
                            },
                            child: const Icon(Icons.remove)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      final FocusNode focusNode = FocusNode();
                                      focusNode.requestFocus();
                                      return Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: SizedBox(
                                            width: 100,
                                            child: TextFormField(
                                              // controller: tct,

                                              validator: numberValidator,
                                              initialValue: state
                                                  .orderItems[widget.index]
                                                  .count
                                                  .toString(),

                                              onFieldSubmitted: (value) {
                                                debugPrint(value);
                                                BlocProvider.of<UseStrukBloc>(
                                                        context)
                                                    .add(ChangeCount(
                                                        item: state.orderItems[
                                                            widget.index],
                                                        count:
                                                            int.parse(value)));
                                                Navigator.pop(context);
                                              },
                                              focusNode: focusNode,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  label: Text('Jumlah item')),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                debugPrint('tapped');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${state.orderItems[widget.index].count}'),
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              BlocProvider.of<UseStrukBloc>(context).add(
                                  IncreaseCount(
                                      item: state.orderItems[widget.index]));
                            },
                            child: const Icon(Icons.add)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 4,
                            child: (state
                                    .orderItems[widget.index].submenues.isEmpty
                                ? SizedBox()
                                : Text('Custom'))),
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              // color: Colors.green,
                              height: 20.0,
                              child: Text(
                                (state.orderItems[widget.index].price *
                                        state.orderItems[widget.index].count)
                                    .toString()
                                    .numberFormat(),
                                textAlign: TextAlign.right,
                              ),
                            )),
                      ],
                    ),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          state.orderItems[widget.index].submenues.length,
                          (index) {
                            var submenudata =
                                state.orderItems[widget.index].submenues[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(submenudata.title),
                                Text((submenudata.adjustHarga *
                                        state.orderItems[widget.index].count)
                                    .numberFormat()),
                              ],
                            );
                          },
                        )
                        //  [
                        //   Text(
                        //       '"${state.orderItems[widget.index].catatan ?? ''}"'),
                        // ],
                        )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
