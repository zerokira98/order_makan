import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
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
      var a = await _repo.getAntrian();
      emit(state.copywith(
          antrianStruks: a, msg: event.msg == null ? null : () => event.msg));
    });
    on<AddtoAntrian>((event, emit) {});
    on<OrderFinish>((event, emit) async {
      try {
        await _repo.finishAntrian(event.strukId);
        add(InitiateAntrian(msg: {
          "status": "success",
          "details": "Pesanan telah diselesaikan"
        }));
      } catch (e) {
        add(InitiateAntrian(
            msg: {"status": "failed", "details": "Error : $e"}));
        throw Exception(e);
      }
    });
    on<OrderFailure>((event, emit) {});
    on<Delete>((event, emit) async {
      try {
        if (event.data.strukId == null) throw Exception("id struk null");
        await _repo.deleteAntrian(event.data.strukId!, '');
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
