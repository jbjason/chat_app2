import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/provider/mystory_store.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_back_image.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_icons_buttons.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_share_button.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({Key? key, required this.currentUser}) : super(key: key);
  final UserData currentUser;
  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _textController = TextEditingController();
  final _snapController = ScreenshotController();
  final _isLoading = ValueNotifier<bool>(false);
  final _textStyle = ValueNotifier<int>(0);
  Color backColor = const Color(0xFF1B1E1F);
  Color textColor = Colors.white;
  File? _pickedImage, _snapImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // back Color/image & Textfield
            _snapArea(),
            // image,gallery,text,textStyle & share icons
            AdsIconsButtons(
              pickedImage: pickedImage,
              changeTextStyle: changeTextStyle,
              changeColor: changeColor,
              backColor: backColor,
              textColor: textColor,
              textStyle: _textStyle,
            ),
            // add to story button
            AdsShareButton(trySubmit: trySubmit, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _snapArea() => Screenshot(
        controller: _snapController,
        child: Stack(
          children: [
            // back Color or Image
            AdsBackImage(backColor: backColor, pickedImage: _pickedImage),
            // textFiled
            AdsTextField(
              textController: _textController,
              textColor: textColor,
              textStyle: _textStyle,
            ),
          ],
        ),
      );

  void trySubmit() async {
    if (_textController.text.trim().isEmpty && _pickedImage == null) return;
    final _userId = widget.currentUser.userId;
    _isLoading.value = true;
    // taking Screenshot
    _snapController.capture().then((Uint8List? imageFile) async {
      // saving to local temp-directory
      final tempDir = await getTemporaryDirectory();
      File _file = await File('${tempDir.path}/$_userId.png').create();
      _file.writeAsBytesSync(imageFile!);
      _snapImage = _file;
      // saving to Cloud
      try {
        // saving to Firebase Storage, adding dateTime to imageFile name cz
        // we can make array objects & as we storing date too. easy to delte
        final _date = DateTime.now();
        final _dateTime = _date.toIso8601String();
        final fileName = '${widget.currentUser.userId}$_dateTime.jpg';
        final ref =
            FirebaseStorage.instance.ref().child('my_story').child(fileName);
        await ref.putFile(_snapImage!);
        final url = await ref.getDownloadURL();
        // checking this users story existed or not
        final _item = MyStoryItem(img: url, dateTime: _date, urlPath: fileName);
        final _data = Provider.of<MyStoryStore>(context, listen: false);
        final _story = _data.getStory(widget.currentUser, _item);
        // saving to Firebase Database with url
        final _firebase = FirebaseFirestore.instance.collection('mystory');
        // if this user has no available story then *add new story
        if (_story.storyId.isEmpty) {
          await _firebase.add(_story.mapItem);
        } else {
          // if this user has story then *update the existing story
          await _firebase.doc(_story.storyId).update(_story.mapItem);
        }
        Navigator.pop(context);
      } catch (error) {
        getSnackBar(error.toString(), const Color(0xFF424242));
      }
    }).catchError((onError) async {
      getSnackBar(onError.toString(), AppColors.accent);
    });
    _isLoading.value = true;
  }

  void pickedImage(File image) => setState(() => _pickedImage = image);

  void changeTextStyle() => _textStyle.value = (_textStyle.value + 1) % 8;

  void changeColor(String isColor, int index) {
    final f = isColor == 'back';
    final fColor = colorsList[index];
    final fTextColor = colorsList[index];
    f ? backColor = fColor : textColor = fTextColor;
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
