import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';

class AlarmReplyScreen extends ConsumerWidget {
  static const routeName = 'alarmreply';
  static const routeUrl = '/alarmreply';
  const AlarmReplyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: '답장하기'.text.make(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              height40,
              height40,
              Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
              height10,
              '답장하기'.text.make(),
              height10,
              height20,
              TextFieldWithDelete(controller: controller),
              height20,
              MainButton(
                '답장하기',
                onPressed: () {
                  //답장 로직 지금 내가 답장을 하고 있다는 것을 어떻게 알지 전 게시물을 보고 있을 때 알람에서 넘겨줘야겠다
                  //보내는 사람,
                  final now = DateTime.now();
                  final wakeModel = WakeModel.empty();
                  final wake = ref.read(wakeIdProvider);
                  // wakeModel
                  //   ..senderUid = user?.uid
                  //   ..senderName = user?.displayName
                  //   ..senderPhotoUrl = user?.photoURL
                  //   ..receiverUid = wake
                  //   ..receiverName = wake
                  //   ..receiverPhotoUrl = wake
                  //   ..wakeTime = now
                  //   ..wakeMessage = controller.text;
                  final image = ref.read(imageUrlProvider);
                  final voice = ref.read(voiceUrlProvider);
                  final video = ref.read(videoUrlProvider);
                  ref.read(wakeControllerProvider.notifier).reply(wake, controller.text, image, voice, video);
                  Navigator.of(context).pop();
                },
              )
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }
}
