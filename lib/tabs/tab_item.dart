import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_tabscreen.dart';
import 'package:wakeuphoney/tabs/feed/feed_tabscreen.dart';
import 'package:wakeuphoney/tabs/match/match_tabscreen.dart';
import 'package:wakeuphoney/tabs/profile/profile_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

enum TabItem {
  alarm(Icons.alarm, '알람', AlarmTabScreen()),
  wake(Icons.airline_seat_individual_suite_sharp, '깨우기', WakeTabScreen()),
  // feed(Icons.toc, '피드', FeedTabScreen()),
  profile(Icons.person, '프로필', ProfileTabScreen()),
  match(Icons.connecting_airports_sharp, '친구', MatchTabScreen());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon}) : inActiveIcon = inActiveIcon ?? activeIcon;

  static TabItem find(String? name) {
    return values.asNameMap()[name] ?? TabItem.alarm;
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color: isActivated ? context.appColors.seedColor.getMaterialColorValues[600] : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
