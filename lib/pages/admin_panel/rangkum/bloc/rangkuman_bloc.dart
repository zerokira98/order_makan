import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/strukrepo.dart';

part 'rangkuman_event.dart';
part 'rangkuman_state.dart';

class RangkumanBloc extends Bloc<RangkumanEvent, RangkumanState> {
  StrukRepository strukrepo;
  KasRepository kasrepo;
  RangkumanBloc(this.strukrepo, this.kasrepo) : super(RangkumanState.initial) {
    on<ChangeFilterRangkuman>((event, emit) async {
      var data = await strukrepo.readStrukwithFilter(event.filter);
      var pengeluaran = await kasrepo.getPengeluaran(
          start: event.filter.start!, end: event.filter.end!);
      emit(state.copyWith(
          struks: data,
          filter: event.filter,
          pengeluaranKas: pengeluaran.docs));
    });

    ///Default to current monthly
    on<InitiateRangkuman>((event, emit) async {
      var now = DateTime.now();
      var filter = StrukFilter(
        start: DateTime(now.year, now.month, 0),
        end: DateTime(now.year, now.month + 1, 0),
      );

      ///default monthly
      var data = await strukrepo.readStrukwithFilter(filter);
      var pengeluaran =
          await kasrepo.getPengeluaran(start: filter.start!, end: filter.end!);
      emit(RangkumanState(
          struks: data, filter: filter, pengeluaranKas: pengeluaran.docs));
    });
  }
}
