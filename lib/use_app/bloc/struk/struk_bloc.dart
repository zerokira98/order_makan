import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../menuitem/menuitems_model.dart';

part 'struk_event.dart';
part 'struk_state.dart';

class StrukBloc extends Bloc<StrukEvent, StrukState> {
  Future errorHandle = Future(() => null);
  StrukBloc() : super(StrukState.initial()) {
    on<IncreaseCount>((event, emit) async {
      List<MenuItems> newlist = List<MenuItems>.from(state.orderItems)
          .map((e) =>
              e.title == event.item.title ? e.countchange(e.count + 1) : e)
          .toList();
      emit(StrukState(orderItems: newlist));
    });
    on<DecreaseCount>((event, emit) async {
      if (state.orderItems
              .singleWhere((e) => e.title == event.item.title)
              .count <=
          0) {
        List<MenuItems> newlist = List<MenuItems>.from(state.orderItems);
        newlist.removeWhere((element) =>
            element.title ==
            event.item.title); //Plz change to id after db created///maybe not
        emit(StrukState(orderItems: newlist));
      } else {
        List<MenuItems> newlist = List<MenuItems>.from(state.orderItems)
            .map((e) =>
                e.title == event.item.title ? e.countchange(e.count - 1) : e)
            .toList();
        emit(StrukState(orderItems: newlist));
      }
    });
    on<AddOrderitems>((event, emit) async {
      List<MenuItems> newlist = List<MenuItems>.from(state.orderItems);
      StrukError error = StrukError.empty();
      !(newlist.every((element) => element.title != event.item.title))
          ? error = StrukError.existed(event.item)
          : newlist.add(event.item.countchange(1));
      emit(StrukState(orderItems: newlist, error: error));

      ///Use Color animation on highlight!
    });
  }
}
