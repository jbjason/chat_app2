import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';

class AdsChngColor extends StatelessWidget {
  const AdsChngColor(
      {Key? key,
      required this.changeColor,
      required this.child,
      required this.isColor})
      : super(key: key);
  final String isColor;
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
        backgroundColor: AppColors.secondary,
        child: InkWell(
          onTap: () {
            // showing diaLog of Colors
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
                            radius: 22,
                            backgroundColor: const Color(0xFF1B1E1F),
                            child: CircleAvatar(
                              radius: 20,
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
