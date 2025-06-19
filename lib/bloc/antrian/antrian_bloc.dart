import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:order_makan/repo/strukrepo.dart';

part 'antrian_event.dart';
part 'antrian_state.dart';

class AntrianBloc extends Bloc<AntrianEvent, AntrianState> {
  final StrukRepository _repo;
  AntrianBloc(StrukRepository repo)
      : _repo = repo,
        super(const AntrianState(antrianStruks: [])) {
    on<InitiateAntrian>((event, emit) async {
      var a = await _repo.readAllStruk(descending: true, finished: false);

      // List ewe = a['orderItems'] as List;
      // print(b);
      emit(state.copywith(antrianStruks: a));
      // emit(AntrianState(antrianStruks: ));
    });
    on<AddtoAntrian>((event, emit) {});
    on<OrderFinish>((event, emit) {});
    on<OrderFailure>((event, emit) {});
  }
}
