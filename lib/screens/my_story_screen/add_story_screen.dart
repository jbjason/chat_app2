import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_back_image.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_icons_buttons.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_share_button.dart';
import 'package:chat_app2/widgets/add_story_widgets/ads_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  final _isLoading = ValueNotifier<bool>(true);
  Color textColor = Colors.white, backColor = const Color(0xFF1B1E1F);
  FontStyle fontStyle = FontStyle.normal;
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
              fontStyle: fontStyle,
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
              fontStyle: fontStyle,
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
        final ref = FirebaseStorage.instance
            .ref()
            .child('my_story')
            .child(widget.currentUser.userId + '.jpg');
        await ref.putFile(_snapImage!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('mystory').add({
          'userId': widget.currentUser.userId,
          'userName': widget.currentUser.userName,
          'userImg': widget.currentUser.imageUrl,
          'storyImg': url,
        });
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

  void changeTextStyle() {
    setState(() {
      fontStyle =
          fontStyle == FontStyle.normal ? FontStyle.italic : FontStyle.normal;
    });
  }

  void changeColor(String isColor, int index) {
    setState(() {
      isColor == 'back'
          ? backColor = colorsList[index]
          : textColor = colorsList[index];
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
