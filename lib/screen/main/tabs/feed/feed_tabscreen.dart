import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tab_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tab_repository.dart';
import 'package:wakeuphoney/screen/main/tabs/match/user_widget.dart';

class FeedTabScreen extends StatefulHookConsumerWidget {
  static const routeName = 'feed';
  static const routeUrl = '/feed';
  const FeedTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends ConsumerState<FeedTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NormalButton(
          text: '연결하기',
          onPressed: () {
            //로그인 버튼 눌렀을때 처리
            showToast('연결하기');
          },
        ),
        if (kDebugMode)
          Column(
            children: [
              height40,
              ElevatedButton(
                  onPressed: () {
                    ref.read(matchTabRepositoryProvider).deleteAllMatch();
                  },
                  child: 'delete all match'.text.make()),
              ElevatedButton(
                  onPressed: () {
                    ref.read(matchTabControllerProvider.notifier).breakUp();
                  },
                  child: 'break up'.text.make()),
              const UserLoggedInWidget(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //로그인 버튼 눌렀을때 처리
                          showToast('홈가기');
                          context.go('/main/home');
                        },
                        child: '홈가기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //로그인 버튼 눌렀을때 처리
                          showToast('wake가기');
                          context.go('/main/wake');
                        },
                        child: 'wake가기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //로그인 버튼 눌렀을때 처리
                          showToast('홈가기');
                          context.go('/main/feed');
                        },
                        child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //로그인 버튼 눌렀을때 처리
                          showToast('홈가기');
                          context.go('/main/feed');
                        },
                        child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //로그인 버튼 눌렀을때 처리
                          showToast('홈가기');
                          context.go('/main/feed');
                        },
                        child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
