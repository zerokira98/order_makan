import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

part 'topbar_event.dart';
part 'topbar_state.dart';

class TopbarBloc extends Bloc<TopbarEvent, TopbarState> {
  MenuItemRepository repo;
  TopbarBloc(this.repo)
      : super(TopbarState(categories: [], selected: '[ALL]')) {
    on<Init>((event, emit) async {
      var a = await repo.getCategories();
      var b = a.isNotEmpty ? a[0] : '';

      emit(TopbarState(categories: a, selected: b));
    });
    on<AddCat>((event, emit) async {
      var a = await repo.addCategory(event.name);
      if (a > 0) {
        // Navigator.pop(context);
        var b = await repo.getCategories();
        emit(TopbarState(categories: b));
      }
    });
    on<DelCat>((event, emit) async {
      var a = await repo.deleteCategory(event.name);
      if (a > 0) {
        var b = await repo.getCategories();
        emit(TopbarState(categories: b));
      }
    });
    on<ChangeSelection>(
      (event, emit) {
        emit(TopbarState(categories: state.categories, selected: event.name));
      },
    );
  }
}
