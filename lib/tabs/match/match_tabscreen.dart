import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/tabs/friend/friend_tabscreen.dart';
import 'package:wakeuphoney/tabs/match/match_model.dart';
import 'package:wakeuphoney/tabs/match/match_tab_controller.dart';

//  test123@wakeupgom.com
//  tezPib-5qovxu-bydruk
// when no couple.

class MatchTabScreen extends ConsumerStatefulWidget {
  static const routeName = 'matchtabs';
  static const routeUrl = '/matchtabs';
  const MatchTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchTabScreenState();
}

class _MatchTabScreenState extends ConsumerState<MatchTabScreen> {
  late final match;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // match = ref.read(matchNumberProvider);
    });
  }

  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    final userStream = ref.watch(getUserStreamProvider);
    final inviteCodeController = TextEditingController();

    // final matchNumber = ref.watch(matchNumberProvider);

    /// match model 로딩하고 생성해서 보여주기.
    /// match model을 가져오고
    /// uid 는 stateprovider로 관리
    /// user model에서 couple이 없으면 match
    ///
    return Scaffold(
      body: userStream.when(
        data: (user) {
          return user.couples!.isNotEmpty
              ? const FriendTabScreen()
              : Tap(
                  onTap: () => AppKeyboardUtil.hide(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/login/cloud.png'),
                        Image.asset('assets/images/login/linkcouple.png'),
                        "Enter each other's invitation codes to connect!"
                            .tr()
                            .text
                            .color(AppColors.primary600)
                            .size(20)
                            .medium
                            .align(TextAlign.center)
                            .make(),
                        height30,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ref.watch(futureMatchNumberProvider).when(
                                  data: (match) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyInviteCode(match),
                                        height20,
                                        "friend's invitation code".tr().text.fontWeight(FontWeight.w600).make(),
                                        height5,
                                        TextFieldWithDelete(
                                          textInputAction: TextInputAction.next,
                                          controller: inviteCodeController,
                                          keyboardType: TextInputType.number,
                                          deleteRightPadding: 5,
                                          texthint: "Please enter the invitation code".tr(),
                                          onChanged: (value) {
                                            logger.d(inviteCodeController.text);
                                            if (inviteCodeController.text == match.vertifynumber.toString()) {
                                              logger.d('same code error');
                                              context.showSnackbar("Please enter the invitation code".tr());
                                              return 'Invitation code matched.'
                                                  .tr()
                                                  .text
                                                  .make(); // Return error message
                                            }
                                            if (value.length == 6) {
                                              ref
                                                  .read(matchTabControllerProvider.notifier)
                                                  .checkMatchProcess(inviteCodeController.text);
                                            }
                                          },
                                          // onEditingComplete: () {
                                          //   logger.d('onEditingComplete checkMatchProcess');

                                          //   ref
                                          //       .read(matchTabControllerProvider.notifier)
                                          //       .checkMatchProcess(inviteCodeController.text);
                                          // },
                                        ).pOnly(top: 5),
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) => 'Error: $error'.text.make(),
                                  loading: () => const CircularProgressIndicator(),
                                ),
                            height20,
                            MainButton('Connect'.tr()),
                          ],
                        ),
                      ],
                    ).pSymmetric(h: 20),
                  ),
                );
        },
        error: (error, stackTrace) => StreamError(error, stackTrace),
        //나중에 글로벌 에러 핸들링으로 변경
        loading: () => Center(
          child: Image.asset('assets/images/wakeupbear/wakeupbear.png'),
        ), // Define the 'loading' variable
        // 나ㅇ에 글로벌 로딩 페이지으로 변경
      ),
    );
  }
}

class MyInviteCode extends StatelessWidget {
  final MatchModel match;
  const MyInviteCode(
    this.match, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '내 초대코드 1시간 유효 (${DateFormat('HH:mm').format(match.time).toString()})'.text.medium.make(),
        height5,
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary600,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              match.vertifynumber.toString().selectableText.lg.medium.make().pSymmetric(h: 10, v: 10),
            ],
          ),
        ),
      ],
    );
  }
}
