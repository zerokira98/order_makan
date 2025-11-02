import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tutup_buku_event.dart';
part 'tutup_buku_state.dart';

class TutupBukuBloc extends Bloc<TutupBukuEvent, TutupBukuState> {
  TutupBukuBloc() : super(TutupBukuInitial()) {
    on<TutupBukuEvent>((event, emit) {});
  }
}
