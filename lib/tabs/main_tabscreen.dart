import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/login_controller.dart';

import '../common/common.dart';
import 'tab_item.dart';
import 'tab_nav.dart';

final currentTabProvider = StateProvider((ref) => TabItem.alarm);

class MainTabsScreen extends ConsumerStatefulWidget {
  final TabItem firstTab;
  static const routeName = 'main';
  static const routeUrl = '/main';

  const MainTabsScreen({
    this.firstTab = TabItem.match,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> with SingleTickerProviderStateMixin {
  final tabs = TabItem.values;
  late final List<GlobalKey<NavigatorState>> navigatorKeys = TabItem.values.map((e) => GlobalKey<NavigatorState>()).toList();

  TabItem get _currentTab => ref.watch(currentTabProvider);

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey => navigatorKeys[_currentIndex];

  @override
  void didUpdateWidget(covariant MainTabsScreen oldWidget) {
    if (oldWidget.firstTab != widget.firstTab) {
      delay(() {
        ref.read(currentTabProvider.notifier).state = widget.firstTab;
      }, 0.ms);
    }
    super.didUpdateWidget(oldWidget);
  }

  Logger logger = Logger();

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;

  ///앱의 최상단. app 이전과 main tabs 이후로 나뉜다.
  ///user는 main tabs에서 모든게 시작되기 때문에 main tabs 에서 stream builder 만든다.
  ///커플이 생기면 match tab 제거는 나중에 생각하자.

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getUserFutureProvider);
    // final user = ref.watch(getUserStreamProvider);
    final uid = ref.watch(uidProvider);

    return PopScope(
        canPop: isRootPage,
        onPopInvoked: _handleBackPressed,
        child: user.when(data: (user) {
          //여기서 이러지 마
          // if (user.couples!.isNotEmpty) {
          //   logger.d('user.couples!.isNotEmpty ${user.couples!.isNotEmpty}');
          //   ref.read(getUserByUidProvider(user.couples!.first)).whenData((value) {
          //     ref.read(friendUserModelProvider.notifier).state = value;
          //     logger.d("ref.read(friendUserModelProvider.notifier).state = value$value");
          //   });
          // }
          return Scaffold(
            extendBody: extendBody, //bottomNavigationBar 아래 영역 까지 그림
            // drawer: const MenuDrawer(),
            // backgroundColor: AppColors.myBackground,
            body: Container(
              color: context.appColors.seedColor.getMaterialColorValues[200],
              padding: EdgeInsets.only(bottom: extendBody ? 60 - bottomNavigationBarBorderRadius : 0),
              child: SafeArea(
                bottom: !extendBody,
                child: pages,
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(context),
          );
        }, error: (error, stackTrace) {
          // Handle the error here
          return Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          );
        }, loading: () {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/images/wakeupbear/wakeupbear512.png',
                  scale: 0.2,
                ),
              ),
            ),
          );
        }));
  }

  bool get isRootPage => _currentTab == TabItem.alarm && _currentTabNavigationKey.currentState?.canPop() == false;

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
                offstage: _currentTab != tab,
                child: TabNavigator(
                  navigatorKey: navigatorKeys[index],
                  tabItem: tab,
                ),
              ))
          .toList());

  void _handleBackPressed(bool didPop) {
    if (!didPop) {
      if (_currentTabNavigationKey.currentState?.canPop() == true) {
        context.pop(_currentTabNavigationKey.currentContext!);
        return;
      }

      if (_currentTab != TabItem.alarm) {
        _changeTab(tabs.indexOf(TabItem.alarm));
      }
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.seedColor.getMaterialColorValues[600],
          unselectedItemColor: context.appColors.iconButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
            context,
            isActivated: _currentIndex == index,
          ),
        )
        .toList();
  }

  void _changeTab(int index) {
    ref.read(currentTabProvider.notifier).state = tabs[index];
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData, IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    HapticFeedback.lightImpact();
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }
}
