import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:repairo_provider/data/models/items.dart';
import 'package:repairo_provider/data/repository/items_repository.dart';

part 'items_states.dart';

class ItemsCubit extends Cubit<ItemsStates> {
  final ItemsRepository itemsRepository;
  List<Items> items = [];

  ItemsCubit(this.itemsRepository) : super(ItemsInitial());

  List<Items> getAllItems() {
    itemsRepository.getAllItems().then((Items) {
      emit(ItemsLoaded(items: Items));
      items = Items;
    });
    return items;
  }

  void searchProducts(String query) {
    final filtered =
        items
            .where(
              (item) =>
                  item.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    emit(ItemsLoaded(items: filtered));
  }
}
