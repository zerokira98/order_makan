import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'topbar_event.dart';
part 'topbar_state.dart';

class TopbarBloc extends Bloc<TopbarEvent, TopbarState> {
  MenuItemRepository repo;
  TopbarBloc(this.repo)
      : super(const TopbarState(categories: [], selected: '[ALL]')) {
    on<Init>((event, emit) async {
      emit(const TopbarState(categories: [], selected: ''));
      var a = await repo.getCategories();
      // var b = a.isNotEmpty ? a[0] : '';
      emit(TopbarState(categories: a, selected: '[ALL]'));
    });
    on<AddCat>((event, emit) async {
      try {
        await repo.addCategory(event.name);
        add(Init());
      } catch (e) {
        throw Exception(e);
      }
      // if (a > 0) {
      //   // Navigator.pop(context);
      //   var b = await repo.getCategories();
      //   emit(TopbarState(categories: b, selected: '[ALL]'));
      // }
    });
    on<DelCat>((event, emit) async {
      try {
        await repo.deleteCategory(event.name);
        add(Init());
      } catch (e) {
        throw Exception(e);
      }
    });
    on<ChangeSelection>(
      (event, emit) {
        emit(TopbarState(categories: state.categories, selected: event.name));
      },
    );
  }
}
