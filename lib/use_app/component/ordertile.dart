import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/use_app/bloc/struk/struk_bloc.dart';
import 'package:order_makan/use_app/component/toptab.dart';
import 'dart:math' as math;

import '../bloc/menuitem/menuitems_model.dart';

class OrderTile extends StatefulWidget {
  final int index;
  final MenuItems data;
  const OrderTile({super.key, required this.index, required this.data});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile>
    with SingleTickerProviderStateMixin {
  // int count = 0;
  ///Use Color animation on highlight!
  late AnimationController ac;
  Tween ani = Tween(begin: 0.0, end: 1.0);
  late Animation ca;
  @override
  void initState() {
    ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    // ani = Tween(begin: 0.0, end: 1.0).animate(ac);
    ca = CurvedAnimation(parent: ac, curve: Curves.bounceInOut).drive(ani);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrukBloc, StrukState>(
      builder: (context, state) {
        return BlocListener<StrukBloc, StrukState>(
          listenWhen: (p, c) => c.error.code != 0,
          listener: (context, state) {
            if (state.error.msg == widget.data.title) {
              ac.forward().then((value) => ac.reverse());
            }
          },
          child: AnimatedBuilder(
            animation: ac,
            builder: (context, child) => Transform.translate(
              offset: Offset(math.sin((ac.value * math.pi)) * 2, 0),
              child: Container(
                color: Colors.red.withOpacity(ca.value),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('${widget.index + 1}. '),
                        Expanded(child: Text(widget.data.title.firstUpcase())),
                        GestureDetector(
                            onTap: () {
                              BlocProvider.of<StrukBloc>(context)
                                  .add(DecreaseCount(item: widget.data));
                              // if (count < 1) return;
                            },
                            child: const Icon(Icons.remove)),
                        Text('${state.orderItems[widget.index].count}'),
                        GestureDetector(
                            onTap: () {
                              BlocProvider.of<StrukBloc>(context)
                                  .add(IncreaseCount(item: widget.data));
                            },
                            child: const Icon(Icons.add)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              color: Colors.red,
                              // height: 12,
                              child: Text(state.orderItems[widget.index].price
                                  .toString()
                                  .numberFormat()),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.green,
                              height: 20,
                              child: Text(
                                (state.orderItems[widget.index].price *
                                        state.orderItems[widget.index].count)
                                    .toString()
                                    .numberFormat(),
                                textAlign: TextAlign.right,
                              ),
                            )),
                      ],
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
