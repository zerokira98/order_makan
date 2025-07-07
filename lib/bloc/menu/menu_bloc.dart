import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuItemRepository repo;
  MenuBloc(this.repo) : super(const MenuState(datas: [])) {
    on<Init>((event, emit) async {
      var a = await repo.getAllMenus();
      emit(MenuState(datas: a).copywith(msg: () => event.msg));
    });
    on<ClearMsg>((event, emit) async {
      add(Init());
    });
    on<AddMenu>((event, emit) async {
      var a = await repo
          .addMenu(event.menu.copywith(title: event.menu.title.firstUpcase));
      if (a == -1) {
        // send Error
      } else {
        var b = await repo.getAllMenus();
        emit(MenuState(datas: b));
      }
    });
    on<DelMenu>((event, emit) async {
      try {
        var a = await repo.deleteMenu(event.menu);
        add(Init());
        // if (a == 0) {
        //   // send Error:no data deletion
        // } else {
        //   var b = await repo.getAllMenus();
        //   emit(MenuState(datas: b));
        // }
      } catch (e) {
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

    ///useless, no need to bloc?
    on<EditMenu>((event, emit) async {
      var a = await repo.editMenu(event.editedmenu);
      if (a == 0) {
        ///throw no changes
      } else {
        add(Init());

        ///what to do xd
        //then, run the topbar bloc on ui button to [ALL]
      }
    });
  }
}
