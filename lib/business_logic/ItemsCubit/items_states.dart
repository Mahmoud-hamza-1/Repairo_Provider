part of 'items_cubit.dart';

@immutable
sealed class ItemsStates {}

final class ItemsInitial extends ItemsStates {}

final class ItemsFailed extends ItemsStates {}

final class ItemsLoaded extends ItemsStates {
  final List<Items> items;

  ItemsLoaded({required this.items});
}
