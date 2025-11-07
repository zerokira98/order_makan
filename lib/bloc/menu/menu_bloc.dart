import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuItemRepository repo;
  TopbarBloc topbarbloc;
  MenuBloc(this.repo, this.topbarbloc) : super(const MenuState(datas: [])) {
    topbarbloc.stream.listen(
      (event) {
        add(ChangeTopbarCat(catName: event.selected));
      },
    );
    on<Init>((event, emit) async {
      Map<String, List<MenuItems>> groupbyletter = {};
      await repo.getAllMenus().then(
        (a) {
          for (var e in a) {
            groupbyletter[e.title[0]] = (groupbyletter[e.title[0]] ?? []) + [e];
          }
          groupbyletter.forEach(
            (key, value) => debugPrint(key + value.toString()),
          );

          emit(MenuState(datas: a).copywith(msg: () => event.msg));
        },
      );
    });
    on<ClearMsg>((event, emit) async {
      add(Init(msg: null));
    });
    on<AddMenu>((event, emit) async {
      try {
        await repo
            .addMenu(event.menu.copywith(title: event.menu.title.firstUpcase));
        add(Init());
      } catch (e) {
        emit(state.copywith(
          msg: () => {'error': e.toString()},
        ));
      }
      // if (a == -1) {
      //   // send Error
      // } else {
      //   var b = await repo.getAllMenus();
      //   emit(MenuState(datas: b));
      // }
    });
    on<DelMenu>((event, emit) async {
      try {
        await repo.deleteMenu(event.menu);
        add(Init(msg: {'sukses': 'delete sukses'}));
      } catch (e) {
        emit(state.copywith(
          msg: () => {'error': e.toString()},
        ));
        throw Exception(e);
      }
    });
    on<ChangeTopbarCat>((event, emit) async {
      var a = event.catName;
      if (a == '[ALL]') {
        var b = await repo.getAllMenus();
        emit(MenuState(datas: b));
      } else {
        var c = await repo.getMenusByCategory(a);
        emit(MenuState(datas: c));
      }
    });
    on<SearchQuery>((event, emit) async {
      var a = event.query;
      var cat = topbarbloc.state.selected;
      List<MenuItems> data;
      if (cat == '[ALL]') {
        data = await repo.getAllMenus();
      } else {
        data = await repo.getMenusByCategory(cat);
      }
      emit(MenuState(
          datas: data
              .map(
                (e) => e.title.toLowerCase().contains(a) ? e : null,
              )
              .nonNulls
              .toList()));
    });

    ///useless, no need to bloc?
    on<EditMenu>((event, emit) async {
      await repo.editMenu(event.editedmenu);
      add(Init());
      // if (a == 0) {
      //   ///throw no changes
      // } else {

      //   ///what to do xd
      //   //then, run the topbar bloc on ui button to [ALL]
      // }
    });
  }
}
