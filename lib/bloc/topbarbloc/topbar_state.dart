part of 'topbar_bloc.dart';

class TopbarState extends Equatable {
  final String selected;
  final List<String> categories;
  const TopbarState({String? selected, required this.categories})
      : selected = selected ?? '[ALL]';

  @override
  List<Object?> get props => [selected, categories];
}
