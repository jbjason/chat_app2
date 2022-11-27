import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final _isVisible = ValueNotifier<bool>(true);
  Color textColor = Colors.white, backColor = const Color(0xFF1B1E1F);
  FontStyle fontStyle = FontStyle.normal;
  File? _pickedImage, _snapImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Screenshot(
          controller: _snapController,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // back Color or Image
              AddStoryBackImage(
                  backColor: backColor, pickedImage: _pickedImage),
              // textFiled
              AddStoryTextField(
                textController: _textController,
                textColor: textColor,
                fontStyle: fontStyle,
              ),
              _storyIconsButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storyIconsButtons() {
    return ValueListenableBuilder(
      valueListenable: _isVisible,
      builder: ((context, bool isVisible, _) => Visibility(
            visible: isVisible,
            child: AddStoryIconsButtons(
              pickedImage: pickedImage,
              changeTextStyle: changeTextStyle,
              changeColor: changeColor,
              trySubmit: trySubmit,
              backColor: backColor,
              fontStyle: fontStyle,
            ),
          )),
    );
  }

  void trySubmit() async {
    if (_textController.text.trim().isEmpty && _pickedImage == null) return;
    _isVisible.value = false;
    await Future.delayed(const Duration(seconds: 1));
    // taking Screenshot
    _snapController
        .capture(delay: const Duration(milliseconds: 1))
        .then((Uint8List? capturedImage) async {
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
      getSnackBar(onError.toString(), Colors.redAccent);
    });
    _isVisible.value = true;
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

class AddStoryIconsButtons extends StatelessWidget {
  const AddStoryIconsButtons({
    Key? key,
    required this.pickedImage,
    required this.changeTextStyle,
    required this.changeColor,
    required this.trySubmit,
    required this.backColor,
    required this.fontStyle,
  }) : super(key: key);

  final Function(File image) pickedImage;
  final void Function() changeTextStyle;
  final Function(String isColor, int index) changeColor;
  final void Function() trySubmit;
  final Color backColor;
  final FontStyle fontStyle;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // camera, gallery, text color, text style Icon
        Positioned(
          top: 30,
          right: 15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Camera Icon
                AddStoryImageIcon(
                  source: ImageSource.camera,
                  icon: Icons.camera,
                  pickedImage: pickedImage,
                  textColor: AppColors.textLigth,
                  backColor: backColor,
                ),
                const SizedBox(height: 10),
                // Gallery Icon
                AddStoryImageIcon(
                  source: ImageSource.gallery,
                  icon: Icons.image_outlined,
                  pickedImage: pickedImage,
                  textColor: AppColors.textLigth,
                  backColor: backColor,
                ),
                const SizedBox(height: 10),
                // text color
                AddStoryChngColor(
                  changeColor: changeColor,
                  isColor: 'text',
                  backColor: backColor,
                  child: const Text('A',
                      style:
                          TextStyle(color: AppColors.textLigth, fontSize: 24)),
                ),
                const SizedBox(height: 10),
                // textStyle
                AddStoryTextStyle(
                  fontStyle: fontStyle,
                  textColor: AppColors.textLigth,
                  changeTextStyle: changeTextStyle,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        // backColor Icon
        Positioned(
          right: 80,
          top: 30,
          child: AddStoryChngColor(
            changeColor: changeColor,
            isColor: 'back',
            backColor: backColor,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: backColor.withOpacity(.9),
            ),
          ),
        ),
        // add to story button
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: trySubmit,
            child: const AddStoryShareButton(),
          ),
        ),
      ],
    );
  }
}

class AddStoryShareButton extends StatelessWidget {
  const AddStoryShareButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Share Now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          Icon(Icons.arrow_right_sharp, color: Colors.white),
        ],
      ),
    );
  }
}

class AddStoryImageIcon extends StatelessWidget {
  const AddStoryImageIcon(
      {Key? key,
      required this.source,
      required this.icon,
      required this.pickedImage,
      required this.backColor,
      required this.textColor})
      : super(key: key);
  final Color textColor;
  final Color backColor;
  final ImageSource source;
  final IconData icon;
  final Function(File image) pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: backColor,
        child: IconButton(
          onPressed: () async {
            final pickedImageFile = await ImagePicker().pickImage(
              source: source,
              imageQuality: 100,
              maxHeight: 500,
              maxWidth: 300,
            );
            pickedImage(File(pickedImageFile!.path));
          },
          icon: Icon(icon, color: textColor),
        ),
      ),
    );
  }
}

class AddStoryChngColor extends StatelessWidget {
  const AddStoryChngColor(
      {Key? key,
      required this.changeColor,
      required this.child,
      required this.backColor,
      required this.isColor})
      : super(key: key);
  final String isColor;
  final Color backColor;
  final Widget child;
  final Function(String isColor, int index) changeColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      child: CircleAvatar(
        radius: 23,
        backgroundColor: backColor,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.grey[200],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                title: const Text(
                  "Color",
                  style: TextStyle(
                      color: Colors.brown, fontWeight: FontWeight.w700),
                ),
                content: SizedBox(
                  width: size.width * .8,
                  height: size.height * .055,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colorsList.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () => changeColor(isColor, i),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF1B1E1F),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: colorsList[i],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: child,
        ),
      ),
    );
  }
}

class AddStoryTextStyle extends StatelessWidget {
  const AddStoryTextStyle(
      {Key? key,
      required this.textColor,
      required this.changeTextStyle,
      required this.fontStyle})
      : super(key: key);
  final Color textColor;
  final FontStyle fontStyle;
  final void Function() changeTextStyle;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: changeTextStyle,
      child: Text(
        'AB+',
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontStyle: fontStyle,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class AddStoryBackImage extends StatelessWidget {
  const AddStoryBackImage(
      {Key? key, required this.backColor, required this.pickedImage})
      : super(key: key);

  final Color backColor;
  final File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backColor.withOpacity(.6),
            backColor,
            backColor.withOpacity(.7),
          ],
        ),
      ),
      child: pickedImage != null
          ? Image.file(pickedImage!, fit: BoxFit.cover)
          : const SizedBox(),
    );
  }
}

class AddStoryTextField extends StatelessWidget {
  const AddStoryTextField({
    Key? key,
    required this.textController,
    required this.textColor,
    required this.fontStyle,
  }) : super(key: key);

  final TextEditingController textController;
  final Color textColor;
  final FontStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Write Something.....",
            floatingLabelAlignment: FloatingLabelAlignment.center,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.only(left: 15, right: 15),
          ),
          cursorColor: textColor,
          style:
              TextStyle(fontSize: 24, color: textColor, fontStyle: fontStyle),
          textInputAction: TextInputAction.done,
          minLines: 1,
        ),
      ),
    );
  }
}
