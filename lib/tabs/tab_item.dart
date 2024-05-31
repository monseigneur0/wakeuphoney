import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_tabscreen.dart';
import 'package:wakeuphoney/tabs/feed/feed_tabscreen.dart';
import 'package:wakeuphoney/tabs/match/match_tabscreen.dart';
import 'package:wakeuphoney/tabs/profile/profile_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

enum TabItem {
  alarm(Icons.list, 'List', AlarmTabScreen()),
  wake(Icons.alarm, 'Alarm', WakeTabScreen()),
  // feed(Icons.toc, '피드', FeedTabScreen()),
  match(Icons.person, 'Friend', MatchTabScreen()),
  profile(Icons.settings, 'Settings', ProfileTabScreen());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  static TabItem find(String? name) {
    return values.asNameMap()[name] ?? TabItem.alarm;
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color: isActivated
              ? context.appColors.seedColor.getMaterialColorValues[600]
              : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
