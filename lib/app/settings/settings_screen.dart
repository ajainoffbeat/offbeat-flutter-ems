import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});



  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),
       appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // ───────── Profile Section ─────────
              _profileSection(),

              const SizedBox(height: 30),

              // ───────── Settings Actions ─────────
              _settingsCard(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, '/editProfile');
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

              // ───────── Logout ─────────
              _logoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── PROFILE UI ─────────
  Widget _profileSection() {
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
            child: Icon(
              Icons.person,
              size: 42,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          "Mukul Tiwari",
          style: TextStyle(
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
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
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
          backgroundColor: Colors.red.shade50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          // TODO: clear token + navigate to login
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
