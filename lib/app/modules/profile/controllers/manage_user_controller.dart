// manage_users_controller.dart
import 'package:get/get.dart';

class AccountModel {
  final String name;
  final String role;
  final String avatarUrl;

  const AccountModel({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}

class ManageUsersController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final accounts = const [
    AccountModel(
      name: 'Heather',
      role: 'Parent',
      avatarUrl: 'https://i.pravatar.cc/300?img=47',
    ),
    AccountModel(
      name: 'Leo',
      role: 'kid',
      avatarUrl: 'https://i.pravatar.cc/300?img=11',
    ),
    AccountModel(
      name: 'Ava',
      role: 'kid',
      avatarUrl: 'https://i.pravatar.cc/300?img=23',
    ),
  ];

  void selectAccount(int index) => selectedIndex.value = index;

  void addChildAccount() {
    // handle add child logic
  }
}
