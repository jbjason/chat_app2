import 'package:chat_app2/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdsShareButton extends StatelessWidget {
  const AdsShareButton(
      {Key? key, required this.trySubmit, required this.isLoading})
      : super(key: key);
  final void Function() trySubmit;
  final ValueNotifier<bool> isLoading;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: GestureDetector(
        onTap: trySubmit,
        child: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, bool isLoading, _) => isLoading
              ? const CircularProgressIndicator(
                  backgroundColor: AppColors.secondary,
                )
              : Container(
                  height: 48,
                  width: 130,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.accent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Share Now',
                        style: GoogleFonts.nerkoOne(
                          color: AppColors.textLigth,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Icon(Icons.arrow_right_sharp,
                          color: AppColors.iconLight),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
