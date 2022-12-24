import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/widgets/common_widgets/glowing_action_button.dart';
import 'package:flutter/cupertino.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.selectedIndex, required this.onSelect})
      : super(key: key);
  final int selectedIndex;
  final Function(int select) onSelect;
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void handleItemSelected(int index) {
    setState(() => selectedIndex = index);
    widget.onSelect(index);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeNavItem(
                index: 0,
                lable: 'Messages',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              HomeNavItem(
                index: 1,
                lable: 'People',
                icon: CupertinoIcons.person_2_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GlowingActionButton(
                  color: AppColors.secondary,
                  icon: CupertinoIcons.add,
                  onPressed: () {},
                ),
              ),
              HomeNavItem(
                index: 2,
                lable: 'Notifications',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              // logout Icon
              _logoutIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutIcon() => InkWell(
        onTap: () => FirebaseAuth.instance.signOut(),
        child: SizedBox(
          width: 55,
          height: 45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, size: 22),
              SizedBox(height: 8),
              Text(
                'Logout',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      );
}

class HomeNavItem extends StatelessWidget {
  const HomeNavItem({
    Key? key,
    required this.index,
    required this.lable,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String lable;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 74,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(height: 8),
            Text(
              lable,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
