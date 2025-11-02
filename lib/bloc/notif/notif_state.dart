part of 'notif_cubit.dart';

class NotifState extends Equatable {
  final List<NotifModel> notif;
  const NotifState({
    required this.notif,
  });
  static NotifState get initial => NotifState(
        notif: [],
      );

  @override
  List<Object> get props => [
        notif,
      ];
}
