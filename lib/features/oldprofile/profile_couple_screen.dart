import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/widgets/drawer.dart';

class ProfileCoupleScreen extends ConsumerStatefulWidget {
  const ProfileCoupleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileCoupleScreenState();
}

class _ProfileCoupleScreenState extends ConsumerState<ProfileCoupleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("커플 프로필"),
      ),
      body: const Center(
        child: Text("커플 프로필"),
      ),
      endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
