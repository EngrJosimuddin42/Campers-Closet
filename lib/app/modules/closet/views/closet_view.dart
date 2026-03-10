import 'package:campers_closet/app/modules/closet/controllers/item_controller.dart';
import 'package:campers_closet/app/modules/closet/widgets/closet_header.dart';
import 'package:campers_closet/app/modules/closet/widgets/filter_tab.dart';
import 'package:campers_closet/app/modules/closet/widgets/item_grid.dart';
import 'package:campers_closet/app/modules/closet/widgets/select_category.dart';
import 'package:campers_closet/app/modules/closet/widgets/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/closet_controller.dart';

class ClosetView extends StatelessWidget {
  const ClosetView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabCtrl = Get.find<ClosetController>();
    final itemsCtrl = Get.find<ItemsController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ClosetHeader(),
            TopNav(),
            Expanded(
              child: Obx(() {
                switch (tabCtrl.selectedTab.value) {
                  case 1:
                    return const Text('Templates');
                  case 2:
                    return const Text('My Lists');
                  default:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        FilterBar(ctrl: itemsCtrl),
                        SizedBox(height: 14),
                        SelectCategory(),
                        Expanded(child: ItemsGrid(ctrl: itemsCtrl)),
                      ],
                    );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
