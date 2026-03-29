import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/calendar/views/calendar_view.dart';
import 'package:campers_closet/app/modules/closet/views/closet_view.dart';
import 'package:campers_closet/app/modules/home/views/home_view.dart';
import 'package:campers_closet/app/modules/navbar/widgets/navbar.dart';
import 'package:campers_closet/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navbar_controller.dart';
import 'package:exui/exui.dart';
import 'package:flutter_svg/svg.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController ctrl = Get.find<NavbarController>();

    final List<Widget> pages = [
      HomeView(),
      ClosetView(),
      CalendarView(),
      ProfileView(),
    ];

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          ctrl.handleBackPress();
        }
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: ctrl.selectedTab.value,
            children: List.generate(pages.length, (i) {
              return Navigator(
                key: ctrl.navKeys[i],
                onGenerateInitialRoutes: (_, _) => [
                  MaterialPageRoute(builder: (_) => pages[i]),
                ],
              );
            }),
          ),

          bottomNavigationBar: const NavBar(),

          floatingActionButton: SizedBox(
            width: 68,
            height: 68,
            child: FloatingActionButton(
              onPressed: ctrl.onScanPressed,
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: AppColors.buttonPrimaryColor,
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  AppLogos.scan,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ).paddingBottom(0),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
