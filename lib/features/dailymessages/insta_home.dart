import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StoryArea(),
            FeedList(),
          ],
        ),
      ),
    );
  }
}

class StoryArea extends ConsumerWidget {
  const StoryArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
        10,
        (index) => UserStory(userName: 'User $index'),
      )),
    );
  }
}

class UserStory extends StatelessWidget {
  final String userName;
  const UserStory({
    required this.userName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(40)),
          ),
          Text(userName),
        ],
      ),
    );
  }
}

class FeedData {
  final String userName;
  final int likeCount;
  final String content;

  FeedData(
      {required this.userName, required this.likeCount, required this.content});
}

final feedDataList = [
  FeedData(
      userName: "User1",
      likeCount: 50,
      content:
          " 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다."),
  FeedData(userName: "User2", likeCount: 1253, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User3", likeCount: 32, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User4", likeCount: 50, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User5", likeCount: 24, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User6", likeCount: 535, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User7", likeCount: 57, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User8", likeCount: 6, content: "오늘 점심 맛있었다."),
];

class FeedList extends ConsumerWidget {
  const FeedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true, //scroll imposible
      physics: const NeverScrollableScrollPhysics(),
      itemCount: feedDataList.length,
      itemBuilder: ((context, index) =>
          FeedItem(feedData: feedDataList[index])),
    );
  }
}

class FeedItem extends ConsumerWidget {
  final FeedData feedData;
  const FeedItem({required this.feedData, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(feedData.userName),
                ],
              ),
              const Icon(Icons.more_vert)
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 280,
          color: Colors.indigo.shade300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.chat_bubble)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.paperplane)),
              ],
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '좋아요 ${feedData.likeCount}개',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: feedData.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: feedData.content),
              ],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
