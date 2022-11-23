import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/story_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stories extends StatelessWidget {
  const Stories({
    Key? key,
    required this.size,
    required this.loggedInUser,
    required this.userDocs,
  }) : super(key: key);
  final Size size;
  final String loggedInUser;
  final List<UserData> userDocs;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: SizedBox(
          height: 146,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // stories title
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 8, bottom: 12),
                child: Text(
                  'Stories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              // story_list
              SizedBox(
                height: 105,
                width: size.width,
                child: Row(
                  children: [
                    // add story button
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 28, left: 8, right: 8),
                        child: SizedBox(
                          width: 60,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[900],
                            radius: 30,
                            child: const Icon(CupertinoIcons.add),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    // story_list
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userDocs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (loggedInUser != userDocs[index].userId) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: SizedBox(
                                width: 60,
                                child: _StoryCard(
                                  storyData: StoryData(
                                    name: userDocs[index].userName,
                                    url: userDocs[index].imageUrl,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key? key,
    required this.storyData,
  }) : super(key: key);

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(storyData.url),
          backgroundColor: Colors.transparent,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              storyData.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
