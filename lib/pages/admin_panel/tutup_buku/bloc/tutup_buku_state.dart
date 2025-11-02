part of 'tutup_buku_bloc.dart';

sealed class TutupBukuState extends Equatable {
  const TutupBukuState();
  
  @override
  List<Object> get props => [];
}

final class TutupBukuInitial extends TutupBukuState {}
