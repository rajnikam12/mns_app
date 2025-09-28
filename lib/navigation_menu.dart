import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mns_app/pages/announcements/announcement.dart';
import 'package:mns_app/pages/feedback_form/feedback_page.dart';
import 'package:mns_app/pages/home/home_page.dart';
import 'package:mns_app/pages/members_profile/members.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedIndex.value],
        bottomNavigationBar: CurvedNavigationBar(
          index: controller.selectedIndex.value,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          color: Theme.of(context).primaryColor,

          animationDuration: Duration(milliseconds: 300),

          items: <Widget>[
            Icon(Icons.home, color: Theme.of(context).scaffoldBackgroundColor),
            Icon(Icons.group, color: Theme.of(context).scaffoldBackgroundColor),
            Icon(Icons.mail, color: Theme.of(context).scaffoldBackgroundColor),
            Icon(
              Icons.person,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomePage(), // Home Screen
    MembersPage(),

    FormPage(),
    AnnouncementScreen(),
  ];
}
