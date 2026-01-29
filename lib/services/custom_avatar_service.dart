import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a custom photo avatar
class CustomAvatar {
  final String id;
  final String name;
  final String fileName; // Store only the filename, not full path
  final DateTime createdAt;

  // Runtime-resolved full path (set by service after loading)
  String? _resolvedPath;

  CustomAvatar({
    required this.id,
    required this.name,
    required this.fileName,
    required this.createdAt,
    String? resolvedPath,
  }) : _resolvedPath = resolvedPath;

  factory CustomAvatar.fromJson(Map<String, dynamic> json) {
    // Handle legacy data that stored full path
    String fileName = json['fileName'] as String? ?? '';
    if (fileName.isEmpty && json['imagePath'] != null) {
      // Extract filename from legacy full path
      final fullPath = json['imagePath'] as String;
      fileName = fullPath.split('/').last;
    }

    return CustomAvatar(
      id: json['id'] as String,
      name: json['name'] as String,
      fileName: fileName,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fileName': fileName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get the full image path (must be set by service)
  String get imagePath => _resolvedPath ?? '';

  /// Set the resolved path
  set resolvedPath(String path) => _resolvedPath = path;

  /// Check if the image file exists
  bool get exists => _resolvedPath != null && File(_resolvedPath!).existsSync();

  /// Get the image file
  File get imageFile => File(_resolvedPath ?? '');
}

/// Service to manage custom photo avatars
class CustomAvatarService {
  static const String _storageKey = 'custom_avatars';
  static CustomAvatarService? _instance;

  final ImagePicker _imagePicker = ImagePicker();
  List<CustomAvatar> _customAvatars = [];
  bool _initialized = false;

  CustomAvatarService._();

  static CustomAvatarService get instance {
    _instance ??= CustomAvatarService._();
    return _instance!;
  }

  /// Initialize the service and load saved avatars
  Future<void> initialize({bool forceReload = false}) async {
    if (_initialized && !forceReload) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    // Get the current avatar directory path
    final avatarDir = await _avatarDirectory;
    final basePath = avatarDir.path;

    debugPrint('CustomAvatarService: Loading avatars from storage...');
    debugPrint('CustomAvatarService: Avatar directory: $basePath');
    debugPrint('CustomAvatarService: Raw JSON: $jsonString');

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        debugPrint('CustomAvatarService: Parsed ${jsonList.length} avatars from JSON');

        _customAvatars = [];
        for (final item in jsonList) {
          final avatar = CustomAvatar.fromJson(item as Map<String, dynamic>);

          // Resolve the full path at runtime
          final fullPath = '$basePath/${avatar.fileName}';
          avatar.resolvedPath = fullPath;

          debugPrint('CustomAvatarService: Avatar ${avatar.id}, fileName: ${avatar.fileName}');
          debugPrint('CustomAvatarService: Resolved path: $fullPath, exists: ${avatar.exists}');

          if (avatar.exists) {
            _customAvatars.add(avatar);
          } else {
            debugPrint('CustomAvatarService: Skipping avatar ${avatar.id} - file not found');
          }
        }

        debugPrint('CustomAvatarService: Loaded ${_customAvatars.length} valid avatars');
      } catch (e) {
        debugPrint('CustomAvatarService: Error loading custom avatars: $e');
        _customAvatars = [];
      }
    } else {
      debugPrint('CustomAvatarService: No saved avatars found');
      _customAvatars = [];
    }

    _initialized = true;
  }

  /// Get all custom avatars
  List<CustomAvatar> get customAvatars => List.unmodifiable(_customAvatars);

  /// Get directory for storing avatar images
  Future<Directory> get _avatarDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final avatarDir = Directory('${appDir.path}/custom_avatars');
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }
    return avatarDir;
  }

  /// Capture a photo from camera and save as custom avatar
  Future<CustomAvatar?> captureFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );

      if (photo == null) return null;

      return await _saveAvatar(photo);
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      return null;
    }
  }

  /// Pick an image from gallery and save as custom avatar
  Future<CustomAvatar?> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _saveAvatar(image);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Save the image file and create a custom avatar
  Future<CustomAvatar> _saveAvatar(XFile imageFile) async {
    final directory = await _avatarDirectory;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final extension = imageFile.path.split('.').last;
    final fileName = 'avatar_$id.$extension';
    final savedPath = '${directory.path}/$fileName';

    debugPrint('CustomAvatarService: Saving image from ${imageFile.path} to $savedPath');

    // Copy the image to our storage location
    await File(imageFile.path).copy(savedPath);

    // Verify the file was copied
    final savedFile = File(savedPath);
    debugPrint('CustomAvatarService: File saved, exists: ${savedFile.existsSync()}, size: ${savedFile.existsSync() ? savedFile.lengthSync() : 0} bytes');

    // Auto-generate name using photo number
    final photoNumber = _customAvatars.length + 1;
    final avatar = CustomAvatar(
      id: 'custom_$id',
      name: 'Photo $photoNumber',
      fileName: fileName,  // Store only filename, not full path
      createdAt: DateTime.now(),
      resolvedPath: savedPath,  // Set the resolved path for immediate use
    );

    _customAvatars.add(avatar);
    await _saveToStorage();

    debugPrint('CustomAvatarService: Avatar ${avatar.id} created and saved');

    return avatar;
  }

  /// Delete a custom avatar
  Future<bool> deleteAvatar(String avatarId) async {
    try {
      final avatarIndex = _customAvatars.indexWhere((a) => a.id == avatarId);
      if (avatarIndex == -1) return false;

      final avatar = _customAvatars[avatarIndex];

      // Delete the image file
      if (avatar.exists) {
        await avatar.imageFile.delete();
      }

      // Remove from list
      _customAvatars.removeAt(avatarIndex);
      await _saveToStorage();

      return true;
    } catch (e) {
      debugPrint('Error deleting avatar: $e');
      return false;
    }
  }

  /// Save avatars to persistent storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(
        _customAvatars.map((a) => a.toJson()).toList(),
      );
      await prefs.setString(_storageKey, jsonString);
      debugPrint('CustomAvatarService: Saved ${_customAvatars.length} avatars to storage');
      debugPrint('CustomAvatarService: Saved JSON: $jsonString');
    } catch (e) {
      debugPrint('CustomAvatarService: Error saving custom avatars: $e');
    }
  }

  /// Get a custom avatar by ID
  CustomAvatar? getById(String id) {
    try {
      return _customAvatars.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
