import 'package:flutter/material.dart';

class MyStoryPage extends StatelessWidget {
  const MyStoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, title: Text('People')),
        const SliverPadding(padding: EdgeInsets.only(top: 10)),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => MyStoryItem(i: index),
            childCount: 10,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .79,
          ),
        )
      ],
    );
  }
}

class MyStoryItem extends StatelessWidget {
  const MyStoryItem({Key? key, required this.i}) : super(key: key);
  final int i;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.teal[100 * (i % 9)],
        // image: i == 0
        //     ? const DecorationImage(
        //         image: AssetImage('assets/travel/cover2.jpg'),
        //         fit: BoxFit.cover)
        //     : DecorationImage(
        //         image: AssetImage('assets/travel/${3 + i}.jpg'),
        //         fit: BoxFit.cover),
      ),
      child: i == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.add),
                ),
                Text(
                  'Add to Story',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // CircleAvatar(
                //   radius: 22,
                //   backgroundImage: AssetImage('assets/travel/offer1.jpg'),
                // ),
                Text(
                  'Jb Jason',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
