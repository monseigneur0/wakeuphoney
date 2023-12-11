import 'package:flutter/material.dart';

import '../constants/design_constants.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.myPink,
      ),
    );
  }
}
