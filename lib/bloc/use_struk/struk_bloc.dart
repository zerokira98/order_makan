import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';
import 'package:order_makan/repo/repo.dart';

part 'struk_event.dart';

class UseStrukBloc extends Bloc<UseStrukEvent, UseStrukState> {
  StrukRepository repo;
  KaryawanAuthRepo auth;
  late final StreamSubscription<User> _userSubscription;
  UseStrukBloc(this.repo, this.auth)
      : super(UseStrukState.initial(karyawanId: auth.currentUser.id)) {
    on<InitiateStruk>((event, emit) {
      ///get karyawan id...
      if (event.success ?? false) {
        emit(UseStrukState.initial(karyawanId: event.karyawanId)
            .copywith(error: StrukError.success()));
      } else {
        emit(UseStrukState.initial(karyawanId: event.karyawanId));
      }
    });
    on<AddSubmenu>((event, emit) {
      var cursubmenues = state.orderItems
          .singleWhere(
            (element) => element.cardId == event.item.cardId,
          )
          .submenues
          .toList();
      cursubmenues.add(event.submenu);
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) => e.cardId == event.item.cardId
              ? e.copywith(submenues: cursubmenues)
              : e)
          .toList();
      // debugPrint(event.item.title);
      emit(state.copywith(orderItems: newlist));
    });
    on<DeleteSubmenu>((event, emit) {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) => e.cardId == event.item.cardId
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
          .map((e) => e.cardId == event.item.cardId
              ? e.copywith(count: e.count + 1)
              : e)
          .toList();
      emit(state.copywith(orderItems: newlist));
    });
    on<ChangeCount>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) => e.cardId == event.item.cardId
              ? e.copywith(count: event.count)
              : e)
          .toList();
      emit(state.copywith(orderItems: newlist));
    });
    on<DecreaseCount>((event, emit) async {
      if (state.orderItems
                  .singleWhere((e) => e.cardId == event.item.cardId)
                  .count -
              1 <=
          0) {
        List<StrukItem> newlist = List<StrukItem>.from(state.orderItems);
        newlist.removeWhere((element) =>
            element.cardId ==
            event.item.cardId); //Plz change to id after db created///maybe not
        emit(state.copywith(orderItems: newlist));
      } else {
        List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
            .map((e) => e.cardId == event.item.cardId
                ? e.copywith(count: e.count - 1)
                : e)
            .toList();
        emit(state.copywith(orderItems: newlist));
      }
    });
    on<AddOrderitems>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems).toList();
      StrukError error = StrukError.empty();
      int increment = newlist.isEmpty ? 0 : newlist.last.cardId;
      newlist.add(event.item.copywith(count: 1, cardId: increment + 1));

      ///old logic, dont delete.
      // !(newlist.every((element) => element.title != event.item.title))
      //     ? error = StrukError.existed(event.item)
      //     : newlist.add(event.item.copywith(count: 1));
      ///-----------=====---------
      emit(state.copywith(orderItems: newlist, error: error));

      ///Use Color animation on highlight!
    });
    on<ChangePembayaran>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(tipePembayaran: event.tipe));
    });
    on<ChangeDibayar>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(dibayar: event.dibayar));
    });
    // on<ChangeAntrian>((event, emit) async {
    //   // await repo.sendtoAntrian(state);
    //   emit(state.copywith(nomorAntrian: event.antrian));
    // });
    on<DateUpdate>((event, emit) async {
      // await repo.sendtoAntrian(state);
      emit(state.copywith(ordertime: DateTime.now()));
    });
    on<SendtoAntrianDB>((event, emit) async {
      // var now = DateTime.now();
      // var todayscount = await repo
      //     .readStrukwithFilter(StrukFilter(
      //         start: DateTime(now.year, now.month, now.day),
      //         end: DateTime(now.year, now.month, now.day)
      //             .add(Duration(days: 1))))
      //     .then(
      //       (value) => value.length,
      //     );
      repo.increaseTodaysAntrianCount().then(
        (antriancount) {
          repo.sendtoAntrian(state.copywith(nomorAntrian: antriancount)).then(
            (value) {
              BackendApi.sendNotifOrderCreated(value.id);
            },
          );

          add(InitiateStruk(karyawanId: state.karyawanId, success: true));
        },
      );
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
