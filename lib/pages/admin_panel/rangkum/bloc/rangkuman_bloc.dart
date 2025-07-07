import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/repo/strukrepo.dart';

part 'rangkuman_event.dart';
part 'rangkuman_state.dart';

class RangkumanBloc extends Bloc<RangkumanEvent, RangkumanState> {
  StrukRepository repo;
  RangkumanBloc(this.repo) : super(RangkumanState.initial) {
    on<ChangeFilterRangkuman>((event, emit) async {
      var data = await repo.readStrukwithFilter(event.filter);
      emit(state.copyWith(struks: data, filter: event.filter));
    });
    on<InitiateRangkuman>((event, emit) async {
      var now = DateTime.now();
      var filter = StrukFilter(
        start: DateTime(now.year, now.month, 0),
        end: DateTime(now.year, now.month + 1, 0),
      );

      ///default monthly
      var data = await repo.readStrukwithFilter(filter);
      emit(RangkumanState(struks: data, filter: filter));
    });
  }
}
