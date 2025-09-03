import 'package:flutter/foundation.dart' hide kIsWasm;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/edit_app/cubit/menuedit_cubit.dart';
import 'package:order_makan/pages/admin_panel/edit_app/tambahedit_dialog.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';

class MenuCard extends StatefulWidget {
  final Function() onTap;
  final bool editmode;
  final MenuItems menudata;
  const MenuCard(
      {super.key, required this.onTap, required this.menudata, bool? editmode})
      : editmode = editmode ?? false;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with TickerProviderStateMixin {
  late AnimationController ac;
  late Animation<double> ca;
  Tween<double> ani = Tween(begin: 0.0, end: 1.0);

  double opacity = 0.0;

  num? posminwidth = 0.0;

  final GlobalKey _keyRed = GlobalKey();

  @override
  void initState() {
    ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..addListener(
        () => debugPrint(
            (1000 * (math.sin(ac.value * math.pi * 2).abs())).toString()),
      );
    ca = CurvedAnimation(parent: ac, curve: Curves.easeOut).drive(ani);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setpos();
    });
    super.initState();
  }

  void setpos() {
    final renderBoxRed = _keyRed.currentContext
        ?.findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();
    final positionRed = renderBoxRed?.x;
    posminwidth = positionRed;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).width;
    return InkWell(
      onLongPress: () {
        if (widget.editmode) {
          showDialog(
            context: context,
            builder: (context) {
              return DeleteMenuDialog(
                menudata: widget.menudata,
              );
            },
          );
        } else {
          widget.onTap();
        }
      },
      onTap: widget.editmode
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    BlocProvider.of<MenueditCubit>(context).initiate(
                        MenueditState.initial().copyWith(
                            ingredients: widget.menudata.ingredientItems,
                            submenu: widget.menudata.submenues));
                    return TambahmenuDialog(
                        editmode: true, menudata: widget.menudata);
                  });
            }
          : () {
              if (!ac.isAnimating) {
                ac.forward().then(
                      (value) => ac.reset(),
                    );
              }
              // setState(() {
              //   opacity = 1.0;
              // });
              // debugPrint(widget.menudata.ingredientItems.toString());
              BlocProvider.of<UseStrukBloc>(context).add(AddOrderitems(
                  item: StrukItem.fromMenuItems(widget.menudata)));
            },
      child: Stack(
        children: [
          Card.filled(
            borderOnForeground: true,
            // surfaceTintColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor.withAlpha(50),
            // elevation: 2,
            child: Container(
              // width: 12,
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: Text(
                            widget.menudata.title.firstUpcase,
                            textScaler: TextScaler.linear(1.15),
                            // style: const TextStyle(fontSize: 14, height: 1.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                          // height: 94,
                          // width: 95,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: widget.menudata.imgDir.contains('assets') ||
                                  widget.menudata.imgDir.isEmpty
                              ? Image.asset(
                                  widget.menudata.imgDir.isEmpty
                                      ? 'assets/sate.jpg'
                                      : widget.menudata.imgDir,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.menudata.imgDir,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null);
                                  },
                                  height: 80,
                                  fit: BoxFit.cover,
                                )

                          // child: Center(child: Text('menu image')),
                          ),
                    ),
                  ),
                  Padding(padding: EdgeInsetsGeometry.all(2)),
                  Text(
                    'Rp  ${widget.menudata.price.toString().numberFormat()}',
                    textScaler: TextScaler.linear(1.1),
                  )
                ],
              ),
            ),
          ),
          MatrixTransition(
            key: _keyRed,
            animation: ca,
            onTransform: (animationValue) => Matrix4.identity()
              ..translate(
                  ((width * 0.75 - (posminwidth ?? 0)) * animationValue),
                  ((height / 6) * (math.sin(ac.value * math.pi * 1).abs()))
                  // ((animationValue + 0.1) * 100) / (animationValue + 0.1),
                  )
              ..scale(1 - (animationValue), 1 - (animationValue)),
            child: FadeTransition(
              opacity: ca,
              // opacity: ca.drive(Tween(begin: 1.0, end: 1.0)),
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyMenuCard extends StatefulWidget {
  const EmptyMenuCard({super.key});

  @override
  State<EmptyMenuCard> createState() => _EmptyMenuCardState();
}

class _EmptyMenuCardState extends State<EmptyMenuCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      surfaceTintColor: Colors.blue,
      // elevation: 2,
      child: InkWell(
        onTap: () {
          var ao = BlocProvider.of<TopbarBloc>(context).state.selected;

          showDialog(
              context: context,
              builder: (context) => TambahmenuDialog(
                    menudata:
                        MenuItems(title: '', imgDir: '', categories: [ao]),
                  ));
        },
        // onTap: () => BlocProvider.of<StrukBloc>(context)
        //     .add(AddOrderitems(item: menudata)),
        child: Container(
          width: 115,
          // margin: EdgeInsets.all(4),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Text(
                        'Tambah menu',
                        // textScaler: TextScaler.linear( 1.2,
                        style: TextStyle(fontSize: 14, height: 1.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 95,
                    // width: 95,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
                    // child: Image.asset(
                    //   'assets/sate.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                    // child: Center(child: Text('menu image')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteMenuDialog extends StatelessWidget {
  final MenuItems menudata;
  const DeleteMenuDialog({super.key, required this.menudata});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (previous, current) =>
          previous.datas.length != current.datas.length,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Delete this menu?'),
                  Text('Categories : ${menudata.categories}')
                ],
              ),
              SizedBox(
                height: 170,
                width: 240,
                child: Stack(
                  children: [
                    MenuCard(
                      onTap: () {},
                      menudata: menudata,
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MenuBloc>(context)
                            .add(DelMenu(menu: menudata));
                      },
                      child: const Text('Confirm')),
                  Padding(padding: EdgeInsetsGeometry.all(12)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
