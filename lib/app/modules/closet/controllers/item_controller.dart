import 'package:campers_closet/app/modules/closet/demo_item_list.dart';
import 'package:campers_closet/app/modules/closet/models/packing_item.dart';
import 'package:get/get.dart';

class ItemsController extends GetxController {
  final RxList<PackingItem> allItems = <PackingItem>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = true.obs;
  final RxString selectedSubCategory = 'All'.obs;

  List<String> get subCategoryTabs {
    final items = selectedFilter.value == 'All'
        ? allItems
        : allItems.where((e) => e.category == selectedFilter.value).toList();

    final subs =
        items
            .map((e) => e.subCategory)
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return ['All', ...subs];
  }

  void setSubCategory(String sub) => selectedSubCategory.value = sub;

  // Also update filteredItems to respect subCategory:
  List<PackingItem> get filteredItems {
    var items = selectedFilter.value == 'All'
        ? allItems.toList()
        : allItems.where((e) => e.category == selectedFilter.value).toList();

    if (selectedSubCategory.value != 'All') {
      items = items
          .where((e) => e.subCategory == selectedSubCategory.value)
          .toList();
    }

    return items;
  }

  // Reset subcategory when main filter changes:
  void setFilter(String filter) {
    selectedFilter.value = filter;
    selectedSubCategory.value = 'All';
  }

  List<String> get filterTabs {
    final cats = allItems.map((e) => e.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  // List<PackingItem> get filteredItems {
  //   if (selectedFilter.value == 'All') return allItems;
  //   return allItems.where((e) => e.category == selectedFilter.value).toList();
  // }

  int countFor(String filter) {
    if (filter == 'All') return allItems.length;
    return allItems.where((e) => e.category == filter).length;
  }

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  Future<void> _loadItems() async {
    isLoading.value = true;
    // Simulate network delay — swap with http.get(yourApiUrl) later
    await Future.delayed(const Duration(milliseconds: 600));
    allItems.assignAll(
      demoItems.map((json) => PackingItem.fromJson(json)).toList(),
    );
    isLoading.value = false;
  }

  // void setFilter(String filter) => selectedFilter.value = filter;
}
