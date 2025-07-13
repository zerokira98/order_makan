import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/repo/strukrepo.dart';

part 'antrian_event.dart';
part 'antrian_state.dart';

class AntrianBloc extends Bloc<AntrianEvent, AntrianState> {
  final StrukRepository _repo;

  late final StreamSubscription<int> subs;
  AntrianBloc(StrukRepository repo)
      : _repo = repo,
        super(const AntrianState(antrianStruks: [])) {
    on<InitiateAntrian>((event, emit) async {
      emit(state.copywith(isloading: true));
      var a = await _repo.getAntrian();
      emit(state.copywith(
          antrianStruks: a, msg: () => event.msg, isloading: false));
    });
    on<AddtoAntrian>((event, emit) {});
    on<OrderFinish>((event, emit) async {
      emit(state.copywith(isloading: true));
      await _repo.finishAntrian(event.strukId).then(
        (value) {
          add(InitiateAntrian(msg: {
            "status": "success",
            "details": "Pesanan telah diselesaikan"
          }));
        },
      ).onError((error, stackTrace) {
        debugPrint(error.toString());
        add(InitiateAntrian(
            msg: {"status": "failed", "details": "Error : $error"}));
      });
    });
    on<OrderFailure>((event, emit) {});
    // delete this method(?)
    on<Delete>((event, emit) async {
      try {
        emit(state.copywith(isloading: true));
        if (event.data.strukId == null) throw Exception("id struk null");
        await _repo.deleteAntrian(event.data.strukId!, event.reason);
        add(InitiateAntrian(msg: {
          "status": "success",
          "details": "Pesanan telah dihapus dari antrian"
        }));
      } catch (e) {
        add(InitiateAntrian(
            msg: {"status": "failed", "details": "Terjadi error $e"}));
      }
    });
    subs = repo.getStrukStreamCount().listen(
          (event) => add(InitiateAntrian()),
        );
  }
  @override
  Future<void> close() {
    subs.cancel();
    return super.close();
  }
}
