import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'karyawanauth_event.dart';
part 'karyawanauth_state.dart';

class KaryawanauthBloc extends Bloc<KaryawanauthEvent, KaryawanauthState> {
  KaryawanauthBloc() : super(KaryawanauthInitial()) {
    on<InitiateKaryawan>((event, emit) {});
  }
}
