import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class MainButtonDisabled extends StatelessWidget {
  final String buttonName;
  final Function()? onPressed;
  const MainButtonDisabled(
    this.buttonName, {
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                //로그인 버튼 눌렀을때 처리
                showToast(buttonName);
                if (onPressed != null) {
                  onPressed!();
                }
              },
              child: buttonName.text.color(Colors.white).semiBold.lg.make(),
            ).pOnly(top: 5),
          ),
        ),
      ],
    );
  }
}
