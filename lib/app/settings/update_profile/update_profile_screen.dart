// lib/app/profile/update_profile_screen.dart
import 'dart:convert';

import 'package:ems_offbeat/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/models/user.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ems_offbeat/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget  {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _alternateMobileCtrl;
  late TextEditingController _tempAddressCtrl;
  late TextEditingController _permAddressCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.user.emailAddress);
    _mobileCtrl = TextEditingController(text: widget.user.mobileNumber);
    _alternateMobileCtrl = TextEditingController(
      text: widget.user.alternateMobileNumber,
    );
    _tempAddressCtrl = TextEditingController(text: widget.user.temporaryAddress);
    _permAddressCtrl = TextEditingController(
      text: widget.user.permanentAddress,
    );

    
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _alternateMobileCtrl.dispose();
    _tempAddressCtrl.dispose();
    _permAddressCtrl.dispose();
    super.dispose();
  }

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

Future<void> _handleImageEdit() async {
  final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return; // user dismissed the sheet

  final XFile? picked = await _picker.pickImage(
    source: source,
    imageQuality: 80,
  );

  if (picked != null) {
    setState(() {
      _selectedImage = File(picked.path);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image selected successfully")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No image selected")),
    );
  }
}

Future<void> _handleSave() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isLoading = true);

  try {
    final Map<String, String> payload = {};

    // Add only changed & non-empty fields
    if (_emailCtrl.text.trim() != widget.user.emailAddress && _emailCtrl.text.trim().isNotEmpty) {
      payload["email"] = _emailCtrl.text.trim();
    }

    if (_mobileCtrl.text.trim() != widget.user.mobileNumber && _mobileCtrl.text.trim().isNotEmpty) {
      payload["mobileNumber"] = _mobileCtrl.text.trim();
    }

    if (_alternateMobileCtrl.text.trim() != widget.user.alternateMobileNumber && _alternateMobileCtrl.text.trim().isNotEmpty) {
      payload["alternateMobileNumber"] = _alternateMobileCtrl.text.trim();
    }

    if (_tempAddressCtrl.text.trim() != widget.user.temporaryAddress && _tempAddressCtrl.text.trim().isNotEmpty) {
      payload["temporaryAddress"] = _tempAddressCtrl.text.trim();
    }

    if (_permAddressCtrl.text.trim() != widget.user.permanentAddress && _permAddressCtrl.text.trim().isNotEmpty) {
      payload["permanentAddress"] = _permAddressCtrl.text.trim();
    }

    // Add image only if selected
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      payload["img"] = base64Encode(bytes);
    }

    // If nothing changed, don't call API
    if (payload.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No changes detected")),
        );
      }
      return;
    }
    print("Update profile payload: $payload");

    final success = await updateProfile(payload);
    print("Update profile response: $success");

   if (success && mounted) {
  ref.read(userProvider.notifier).loadUserProfile(); // refresh profile state
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Profile updated successfully!")),
  );
  Navigator.pop(context);
}

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception:", "").trim())),
      );
    }
  } finally {
    setState(() => _isLoading = false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData.primary500,
      body: Stack(children: [_buildHeader(), _buildContent()]),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  "Update Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 30),
          _buildProfileImage(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // PRINT++++++++++++++++++
    // print(widget.user.imgurl);
    // print(widget.user.imgurl.replaceRange(7, 16, "192.168.1.11"));
    return Stack(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : widget.user.imgurl.isNotEmpty
                ? Image.network(
                   widget.user.imgurl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        // http://192.168.1.11:5220/swagger/index.html
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _handleImageEdit,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: AppThemeData.primary500,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppThemeData.primary400, AppThemeData.primary600],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 60, color: Colors.white),
      ),
    );
  }

  // ───────── CONTENT ─────────
  Widget _buildContent() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.68,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNameSection(),
                const SizedBox(height: 30),
                _buildFormFields(),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      children: [
        Text(
          widget.user.fullName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          widget.user.designationName,
          style: TextStyle(
            color: AppThemeData.primary500,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Update your personal information",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Contact Information", Icons.phone),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _emailCtrl,
          label: "Email Address",
          hint: "Enter your email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter email";
            }
            if (!value.contains('@')) {
              return "Please enter valid email";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        _buildTextField(
          controller: _mobileCtrl,
          label: "Mobile Number",
          hint: "Enter your mobile number",
          icon: Icons.phone_android,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter mobile number";
            }
            if (value.length < 10) {
              return "Please enter valid mobile number";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        _buildTextField(
          controller: _alternateMobileCtrl,
          label: "Alternate Mobile Number",
          hint: "Enter alternate mobile number",
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 30),

        _buildSectionTitle("Address Details", Icons.location_on),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _tempAddressCtrl,
          label: "Temporary Address",
          hint: "Enter your temporary address",
          icon: Icons.home_outlined,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter temporary address";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        _buildTextField(
          controller: _permAddressCtrl,
          label: "Permanent Address",
          hint: "Enter your permanent address",
          icon: Icons.home,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter permanent address";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppThemeData.primary500.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppThemeData.primary500, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppThemeData.primary500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: AppThemeData.primary500),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppThemeData.primary500, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeData.primary500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _handleSave,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
