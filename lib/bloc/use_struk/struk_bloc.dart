import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';
import 'package:order_makan/repo/strukrepo.dart';
import 'package:order_makan/repo/user_model.dart';

part 'struk_event.dart';

class UseStrukBloc extends Bloc<UseStrukEvent, UseStrukState> {
  StrukRepository repo;
  KaryawanAuthRepo auth;
  late final StreamSubscription<User> _userSubscription;
  UseStrukBloc(this.repo, this.auth)
      : super(UseStrukState.initial(karyawanId: auth.currentUser.id)) {
    on<InitiateStruk>((event, emit) {
      ///get karyawan id...

      emit(UseStrukState.initial(karyawanId: event.karyawanId));
    });
    on<AddSubmenu>((event, emit) {
      var cursubmenues = state.orderItems
          .singleWhere(
            (element) => element.title == event.item.title,
          )
          .submenues
          .toList();
      cursubmenues.add(event.submenu);
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) => e.title == event.item.title
              ? e.copywith(submenues: cursubmenues)
              : e)
          .toList();
      // debugPrint(event.item.title);
      emit(state.copywith(orderItems: newlist));
    });
    on<DeleteSubmenu>((event, emit) {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) => e.title == event.item.title
              ? e.copywith(
                  submenues: e.submenues
                      .map(
                        (e2) => e2.title == event.submenu.title ? null : e2,
                      )
                      .nonNulls
                      .toList())
              : e)
          .toList();
      emit(state.copywith(orderItems: newlist));
    });
    on<ClearErrMsg>((event, emit) {
      emit(state.copywith(error: StrukError.empty()));
    });
    on<IncreaseCount>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) =>
              e.title == event.item.title ? e.copywith(count: e.count + 1) : e)
          .toList();
      emit(state.copywith(orderItems: newlist));
    });
    on<ChangeCount>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) =>
              e.title == event.item.title ? e.copywith(count: event.count) : e)
          .toList();
      emit(state.copywith(orderItems: newlist));
    });
    on<DecreaseCount>((event, emit) async {
      if (state.orderItems
                  .singleWhere((e) => e.title == event.item.title)
                  .count -
              1 <=
          0) {
        List<StrukItem> newlist = List<StrukItem>.from(state.orderItems);
        newlist.removeWhere((element) =>
            element.title ==
            event.item.title); //Plz change to id after db created///maybe not
        emit(state.copywith(orderItems: newlist));
      } else {
        List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
            .map((e) => e.title == event.item.title
                ? e.copywith(count: e.count - 1)
                : e)
            .toList();
        emit(state.copywith(orderItems: newlist));
      }
    });
    on<AddOrderitems>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          // .map((e) => StrukItem(
          //     title: e.title, count: e.count, price: e.price, id: e.id))
          .toList();
      StrukError error = StrukError.empty();
      !(newlist.every((element) => element.title != event.item.title))
          ? error = StrukError.existed(event.item)
          : newlist.add(event.item.copywith(count: 1));
      emit(state.copywith(orderItems: newlist, error: error));

      ///Use Color animation on highlight!
    });
    on<ChangePembayaran>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(tipePembayaran: event.tipe));
    });
    on<ChangeMeja>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(nomorMeja: event.meja));
    });
    on<DateUpdate>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(ordertime: DateTime.now()));
    });
    on<SendtoDb>((event, emit) async {
      await repo.sendtoAntrian(state);
      add(InitiateStruk(karyawanId: state.karyawanId));
    });

    _userSubscription = auth.user.listen((event) {
      add(InitiateStruk(karyawanId: event.id));
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
