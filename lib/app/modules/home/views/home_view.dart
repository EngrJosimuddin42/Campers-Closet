import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/home/widgets/active_list_card.dart';
import 'package:campers_closet/app/modules/home/widgets/event_card.dart';
import 'package:campers_closet/app/modules/home/widgets/my_closet_card.dart';
import 'package:campers_closet/app/modules/home/widgets/shop_now_banner.dart';
import 'package:campers_closet/app/modules/home/widgets/templae_card.dart';
import 'package:campers_closet/app/modules/notifications/views/notifications_view.dart';
import 'package:campers_closet/app/widgets/section_header.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeHeader(),
            SizedBox(height: 12.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _welcomeMessage(),
                    SizedBox(height: 22.h),
                    activeListCardCarousel(),
                    SizedBox(height: 22.h),
                    const MyClosetCard(),
                    SizedBox(height: 30.h),
                    _templateCard(),
                    SizedBox(height: 40.h),
                    const ShopNowBanner(),
                    SizedBox(height: 30.h),
                    _upcomingEvent(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ).paddingHorizontal(24.w).paddingTop(12.h),
      ),
    );
  }

  CarouselSlider activeListCardCarousel() {
    return CarouselSlider(
      items: [ActiveListCard(), ActiveListCard(), ActiveListCard()],
      options: CarouselOptions(
        height: 230.h,
        aspectRatio: 1,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.0,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Column _welcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good evening, Heather.',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Everything you need, packed and ready',
          style: GoogleFonts.sora(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Column _upcomingEvent() {
    return Column(
      children: [
        SectionHeader(
          title: 'Upcoming Events',
          actionText: 'View All',
          onActionTap: () {
            // navigate or handle click
          },
        ),
        SizedBox(height: 20.h),
        const EventCard(),
        SizedBox(height: 80.h),
      ],
    );
  }

  Column _templateCard() {
    return Column(
      children: [
        SectionHeader(
          title: 'Templates',
          onActionTap: () {
            // navigate or handle click
          },
        ),
        SizedBox(height: 20.h),
        const Row(
          children: [
            Expanded(
              child: TemplateCard(
                title: 'Summer Camp',
                itemCount: 15,
                imageUrl:
                    'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?w=500',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TemplateCard(
                title: 'Tour & Travel',
                itemCount: 15,
                imageUrl:
                    'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?w=500',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _homeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppLogos.homelogo, width: 52, height: 52),
            const SizedBox(width: 12),
            Text(
              'All Packed',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const Spacer(),
            Obx(() => GestureDetector(
              onTap: () {
                Get.to(() => const NotificationsView());
              },
              behavior: HitTestBehavior.translucent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    AppLogos.homenotification,
                    width: 24,
                    height: 24,
                  ),
                  if (controller.unreadNotificationCount.value > 0)
                    Positioned(
                      right: -2,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          controller.unreadNotificationCount.value.toString(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}
