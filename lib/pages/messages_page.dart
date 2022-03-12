import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/story_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/widgets/common_widgets/avatar.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataStore = Provider.of<DataStore>(context, listen: false);
    return StreamBuilder(
      stream: Helpers.getUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapShot.hasError) {
            return const Center(child: Text('Error Occured!'));
          } else {
            final userDocs = snapShot.data!.docs;
            final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            dataStore.setUsers(userDocs);
            final List<UserData> usersList =
                userDocs.isEmpty ? [] : dataStore.usersList;
            final UserData currentUser = dataStore.findUserById(currentUserId);
            return CustomScrollView(
              slivers: [
                //appBar
                CustomAppBar(currentUser: currentUser),
                // Stories
                _Stories(
                  userDocs: usersList,
                  loggedInUser: currentUserId,
                  size: size,
                ),
                // Messages List
                MessageList(userDocs: usersList, currentUser: currentUser),
              ],
            );
          }
        }
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final UserData currentUser;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: kToolbarHeight + 5,
      pinned: true,
      centerTitle: true,
      leadingWidth: 54,
      leading: Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          icon: Icons.search,
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
      title: const Text(
        'Messages',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(currentUser.imageUrl),
          ),
        ),
      ],
    );
  }
}

class _Stories extends StatelessWidget {
  const _Stories({
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
              SizedBox(
                height: 105,
                width: size.width,
                child: Row(
                  children: [
                    InkWell(
                      child: const Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 24, left: 8, right: 8),
                        child: SizedBox(
                          width: 60,
                          child: CircleAvatar(
                            radius: 30,
                            child: Icon(CupertinoIcons.add),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
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

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.userDocs,
    required this.currentUser,
  }) : super(key: key);

  final List<UserData> userDocs;
  final UserData currentUser;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          String s = userDocs[index].lastMsg;
          s = s.isEmpty
              ? 'You are now Friends with ${userDocs[index].userName}. Say Hiii to!'
              : s;
          if (currentUser.userId != userDocs[index].userId) {
            return _MessageTitle(
              currentUser: currentUser,
              messageData: MessageData(
                userId: userDocs[index].userId,
                userName: userDocs[index].userName,
                message: s,
                messageDate:
                    DateTime.parse(userDocs[index].lastMsgTime.toString()),
                dateDifference:
                    Jiffy(userDocs[index].lastMsgTime.toString()).fromNow(),
                img: userDocs[index].imageUrl,
              ),
            );
          } else {
            return Container();
          }
        },
        childCount: userDocs.length,
      ),
    );
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({
    Key? key,
    required this.currentUser,
    required this.messageData,
  }) : super(key: key);
  final UserData currentUser;
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(
                messageData: messageData, currentUser: currentUser)));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: messageData.img),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messageData.userName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.message,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      messageData.dateDifference.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLigth,
                          ),
                        ),
                      ),
                    )
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
