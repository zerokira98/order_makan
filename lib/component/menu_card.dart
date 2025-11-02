import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:google_fonts/google_fonts.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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
  num? posminheight = 0.0;

  double top = 0.0;
  final GlobalKey _keyRed = GlobalKey();

  @override
  void initState() {
    ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    // ..addListener(
    //   () =>
    //    debugPrint(
    //       (1000 * (math.sin(ac.value * math.pi * 2).abs())).toString()),
    // );
    ca = CurvedAnimation(parent: ac, curve: Curves.easeOut).drive(ani);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Durations.short1, () {
        setState(() {
          top = 38.0;
        });
      });
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
    final positionBlue = renderBoxRed?.y;
    posminwidth = positionRed;
    posminheight = positionBlue;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
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
            elevation: 2,
            borderOnForeground: true,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 36,
                                child: FutureBuilder(
                                    future:
                                        SharedPreferences.getInstance().then(
                                      (value) => value.getBool('capitalize'),
                                    ),
                                    builder: (context, asyncSnapshot) {
                                      return Text(
                                        widget.menudata.title
                                            .split(' ')
                                            .map((word) =>
                                                (asyncSnapshot.data ?? false)
                                                    ? word.toUpperCase()
                                                    : word.firstUpcase)
                                            .join(' '),
                                        textScaler: TextScaler.linear(1.1),
                                        style: GoogleFonts.notoSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            wordSpacing: 0.0,
                                            letterSpacing: 0.0,
                                            height: 1.0),
                                        textAlign: TextAlign.left,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        curve: Curves.easeInOut,
                        duration: Durations.medium2,
                        top: top,
                        bottom: 0.0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: widget.menudata.imgDir
                                          .contains('assets') ||
                                      widget.menudata.imgDir.isEmpty
                                  ? Image.asset(
                                      widget.menudata.imgDir.isEmpty
                                          ? 'assets/sate.jpg'
                                          : widget.menudata.imgDir,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    )
                                  : Image(
                                      image: CachedNetworkImageProvider(
                                          widget.menudata.imgDir),
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
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            color: Colors.black45,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Rp  ${widget.menudata.price.toString().numberFormat()}',
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.white),
                            textScaler: TextScaler.linear(1.1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(padding: EdgeInsetsGeometry.all(2)),
                // Text(
                //   'Rp  ${widget.menudata.price.toString().numberFormat()}',
                //   textScaler: TextScaler.linear(1.1),
                // )
              ],
            ),
          ),
          MatrixTransition(
            key: _keyRed,
            animation: ca,
            onTransform: (animationValue) => Matrix4.identity()
              ..translateByDouble(
                  ((width * 0.75 - (posminwidth ?? 0)) * animationValue),
                  ((height / 3 - (posminheight ?? 0)) *
                      (math.sin(ac.value * math.pi * 1).abs())),
                  0,
                  0
                  // ((animationValue + 0.1) * 100) / (animationValue + 0.1),
                  )
              ..scaleAdjoint(1 - (animationValue)),
            child: FadeTransition(
              opacity: ca,
              // opacity: ca.drive(Tween(begin: 1.0, end: 1.0)),
              child: Container(
                color: Colors.black,
                padding:
                    EdgeInsets.all(8.0).add(EdgeInsetsGeometry.only(top: 18)),
                child: Container(
                  color: Colors.grey,
                ),
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
      elevation: 2,
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
                        textScaler: TextScaler.linear(1.2),
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
                        Icons.image_search_outlined,
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
