import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:order_makan/model/strukitem_model.dart';

part 'struk_event.dart';

class StrukBloc extends Bloc<StrukEvent, StrukState> {
  StrukBloc() : super(StrukState.initial()) {
    on<InitiateStruk>((event, emit) {
      ///get karyawan id...

      emit(state.copywith(karyawanId: event.karyawanId));
    });
    on<IncreaseCount>((event, emit) async {
      List<StrukItem> newlist = List<StrukItem>.from(state.orderItems)
          .map((e) =>
              e.title == event.item.title ? e.copywith(count: e.count + 1) : e)
          .toList();
      // emit(StrukState(orderItems: newlist));
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
          .map((e) => StrukItem(title: e.title, count: e.count, price: e.price))
          .toList();
      StrukError error = StrukError.empty();
      !(newlist.every((element) => element.title != event.item.title))
          ? error = StrukError.existed(event.item)
          : newlist.add(event.item.copywith(count: 1));
      emit(state.copywith(orderItems: newlist, error: error));

      ///Use Color animation on highlight!
    });
  }
}
