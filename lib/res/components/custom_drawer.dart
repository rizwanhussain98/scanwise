import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../services/navigation_service.dart';
import '../../utils/routes/routes_name.dart';
import '../../view_model/user_view_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, drawerViewModel, child) {
        return Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Profile Section
                    _buildProfileSection(drawerViewModel),
                    const SizedBox(height: 40),
                  ],
                ),
                // Menu Items
                Expanded(
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.home_filled,
                        label: 'Home',
                        iconColor: Colors.red,
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite,
                        label: 'Interest',
                        iconColor: Colors.grey,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.chat_bubble,
                        label: 'Chat',
                        iconColor: Colors.grey,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications,
                        label: 'Notifications',
                        iconColor: Colors.grey,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Icons.person,
                        label: 'Settings',
                        iconColor: Colors.grey,
                        onTap: () {
                          NavigationService.navigateTo(
                              RoutesNames.settingsView);
                        },
                      ),
                      _buildMenuItem(
                        icon: FontAwesomeIcons.crown,
                        label: 'Subscription',
                        iconColor: Colors.grey,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextButton(
                      onPressed: () {
                        drawerViewModel.logout();
                        // Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.logout,
                            color: Colors.black54,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(UserViewModel drawerViewModel) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 18.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          // child: ClipOval(
          //   child: drawerViewModel.userProfile?.basicInfo?.photo != null
          //       ? CachedNetworkImage(
          //           imageUrl: drawerViewModel.userProfile!.basicInfo!.photo!,
          //           fit: BoxFit.cover,
          //           placeholder: (context, url) => Container(
          //             color: Colors.grey.shade100,
          //             child: const Icon(Icons.person,
          //                 size: 40, color: Colors.grey),
          //           ),
          //           errorWidget: (context, url, error) => Container(
          //             color: Colors.grey.shade100,
          //             child: const Icon(Icons.person,
          //                 size: 40, color: Colors.grey),
          //           ),
          //         )
          //       : Container(
          //           color: Colors.grey.shade100,
          //           child:
          //               const Icon(Icons.person, size: 40, color: Colors.grey),
          //         ),
          // ),
        ),
        const SizedBox(height: 15),
        Text(
          "${drawerViewModel.signupData.firstName}${drawerViewModel.signupData.lastName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}
