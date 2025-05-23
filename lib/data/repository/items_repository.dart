import 'package:repairo_provider/data/models/items.dart';
import 'package:repairo_provider/data/web_services/Items_webservices.dart';

class ItemsRepository {
  final ItemsWebservices itemsWebservices;

  ItemsRepository({required this.itemsWebservices});

  Future<List<Items>> getAllItems() async {
    final items = await itemsWebservices.getItems();
    return items.map((item) => Items.fromjson(item)).toList();
  }
}
