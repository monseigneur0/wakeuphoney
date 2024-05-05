import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class MainButton extends StatelessWidget {
  final String buttonName;
  final Function()? onPressed;
  const MainButton(
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
                backgroundColor: AppColors.primary600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                //로그인 버튼 눌렀을때 처리
                showToast(buttonName);
                onPressed;
              },
              child: buttonName.text.color(Colors.white).bold.size(16).make(),
            ).pOnly(top: 5),
          ),
        ),
      ],
    );
  }
}
