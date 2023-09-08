import 'package:flutter/material.dart';
import 'package:front/feature/home.dart';
import 'package:front/feature/recommend.dart';
import 'package:front/feature/settings.dart';
import 'package:front/icons/custom_icon_icons.dart';

class MainScreen extends StatelessWidget {
  final List<TabModel> tabItem = [
    TabModel(title: "홈", icon: CustomIcon.home, child: HomeScreen()),
    TabModel(title: "추천", icon: CustomIcon.star, child: RecommendScreen()),
    TabModel(title: "설정", icon: CustomIcon.settings, child: SettingScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
        length: tabItem.length,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: _buildTabBar(context),
          ),
          body: _buildTabBarView,
        ));
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
        color: Colors.black,
        child: TabBar(
          tabs: List.generate(
              tabItem.length,
              (index) => Tab(
                    text: tabItem[index].title,
                    icon: Icon(tabItem[index].icon),
                  )),
        ));
  }

  TabBarView get _buildTabBarView =>
      TabBarView(children: tabItem.map((e) => e.child).toList());
}

class TabModel {
  final String title;
  final IconData icon;
  final Widget child;

  TabModel({required this.title, required this.icon, required this.child});
}
