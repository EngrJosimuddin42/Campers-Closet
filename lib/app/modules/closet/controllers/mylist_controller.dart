import 'package:get/get.dart';

enum ListStatus { active, completed, past }

class PackingListModel {
  final String id;
  final String title;
  final String location;
  final String category; 
  final DateTime startDate;
  final DateTime endDate;
  final int totalItems;
  final int packedItems;
  final ListStatus status;

  const PackingListModel({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.totalItems,
    required this.packedItems,
    required this.status,
  });

  double get progress => totalItems == 0 ? 0 : packedItems / totalItems;
  bool get isCompleted => status == ListStatus.completed;
}

class MylistController extends GetxController {
  final RxList<PackingListModel> allLists = <PackingListModel>[].obs;
  final RxBool isLoading = true.obs;

  List<PackingListModel> get activeLists =>
      allLists.where((l) => l.status == ListStatus.active).toList();
  List<PackingListModel> get completedLists =>
      allLists.where((l) => l.status == ListStatus.completed).toList();
  List<PackingListModel> get pastLists =>
      allLists.where((l) => l.status == ListStatus.past).toList();

  @override
  void onInit() {
    super.onInit();
    _loadLists();
  }

  Future<void> _loadLists() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    allLists.assignAll([
      PackingListModel(
        id: '1',
        title: 'Summer Camp 2026',
        location: 'Lake Winnebago, WI',
        category: 'CAMP',
        startDate: DateTime(2026, 7, 15),
        endDate: DateTime(2026, 7, 29),
        totalItems: 7,
        packedItems: 3,
        status: ListStatus.active,
      ),
      PackingListModel(
        id: '2',
        title: 'Ski Weekend 2025',
        location: 'Aspen, BD',
        category: 'TRAVEL',
        startDate: DateTime(2025, 7, 15),
        endDate: DateTime(2025, 7, 29),
        totalItems: 7,
        packedItems: 7,
        status: ListStatus.completed,
      ),
      PackingListModel(
        id: '3',
        title: 'Beach Trip 2024',
        location: 'Miami, FL',
        category: 'TRAVEL',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 7),
        totalItems: 10,
        packedItems: 10,
        status: ListStatus.past,
      ),
    ]);
    isLoading.value = false;
  }

  void createNew() {
    // TODO: open create list bottom sheet
  }
}
