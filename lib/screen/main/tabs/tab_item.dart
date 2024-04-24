import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

import 'match/match_tabscreen.dart';

enum TabItem {
  home(Icons.alarm, '알람', MatchTabScreen()),
  wake(Icons.mail, '깨우기', MatchTabScreen()),
  feed(Icons.toc, '피드', MatchTabScreen()),
  match(Icons.connecting_airports_sharp, '연결', MatchTabScreen()),
  profile(Icons.person, '프로필', MatchTabScreen());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

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
