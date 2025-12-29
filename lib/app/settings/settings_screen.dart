import 'dart:convert';
import 'package:ems_offbeat/state/user_state.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/providers/user_provider.dart';
import 'package:ems_offbeat/app/settings/update_profile/update_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
  @override
  void initState() {
    super.initState();

    /// Load user profile ONCE when screen opens
    Future.microtask(() {
      ref.read(userProvider.notifier).loadUserProfile();
      final userState = ref.watch(userProvider);
      String name = "${userState.user?.firstName} ${userState.user?.lastName}";
      
    });
  }

 @override
Widget build(BuildContext context) {
  final userState = ref.watch(userProvider);

  return Scaffold(
    backgroundColor: const Color(0xfff7f8fc),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // 👇 pass userState here
            _profileSection(userState),

            const SizedBox(height: 30),

            _settingsCard(
              icon: Icons.edit_outlined,
              title: "Edit Profile",
              onTap: () {
                if (userState.user != null) {
                  print("User: ${userState.user}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UpdateProfileScreen(user: userState.user!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User data not available")),
                  );
                }
              },
            ),

            _settingsCard(
              icon: Icons.lock_outline,
              title: "Update Password",
              onTap: () {
                Navigator.pushNamed(context, '/updatePassword');
              },
            ),

            const Spacer(),
            _logoutButton(context),
          ],
        ),
      ),
    ),
  );
}


  // ───────── PROFILE UI ─────────
Widget _profileSection(UserState userState) {
  final user = userState.user;

  final name = user != null
      ? "${user.firstName} ${user.lastName}"
      : "Loading...";

  return Column(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppThemeData.primary400,
              AppThemeData.primary600,
            ],
          ),
        ),
        child: const Center(
          child: Icon(Icons.person, size: 42, color: Colors.white),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        "View & manage your account",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
        ),
      ),
    ],
  );
}


  // ───────── SETTINGS CARD ─────────
  Widget _settingsCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12),
        ],
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppThemeData.primary100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppThemeData.primary500),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // ───────── LOGOUT ─────────
Widget _logoutButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade100,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () async {
        // ✅ Clear token + reporting flag
        await TokenStorage.clearToken();

        // ✅ Navigate to login & clear stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      },
      child: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

}
