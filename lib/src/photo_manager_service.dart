import 'dart:developer';

import 'package:photo_manager/photo_manager.dart';

/// An exception thrown when the permission is denied.
class PermissionException implements Exception {}

/// An exception thrown when could not get the audio assets.
class GetAudioException implements Exception {}

/// An exception thrown when could not get the video assets.
class GetVideoException implements Exception {}

/// An exception thrown when could not open the settings.
class OpenSettingsException implements Exception {}

/// {@template photo_manager_service}
/// A service that helps to retrieve photos and videos. It also helps to request
/// the permission.
///
/// This service uses the `photo_manager` package.
///
/// ```dart
/// final photoManagerService = PhotoManagerService();
/// ```
/// {@endtemplate}
class PhotoManagerService {
  /// {@macro photo_manager_service}
  PhotoManagerService() : _isAuthenticated = false;

  bool _isAuthenticated;

  /// Whether the permission is granted.
  bool get isAuthenticated => _isAuthenticated;

  /// Requests the permission.
  ///
  /// Throws a [PermissionException] if the permission is denied.
  Future<void> requestPermission() async {
    final PermissionState result;
    try {
      result = await PhotoManager.requestPermissionExtend();
    } catch (_) {
      log('Failed to request permission!', name: 'PhotoManagerService');
      throw PermissionException();
    }

    if (!result.hasAccess) {
      log('Permission denied!', name: 'PhotoManagerService');
      throw PermissionException();
    }

    _isAuthenticated = true;
  }

  /// Gets the audio assets.
  ///
  /// Throws a [PermissionException] if [isAuthenticated] is false.
  ///
  /// Throws a [GetAudioException] if could not get the audio assets.
  Future<List<AssetEntity>> getAudios() async {
    if (!_isAuthenticated) {
      log('Permission denied!', name: 'PhotoManagerService');
      throw PermissionException();
    }

    final List<AssetEntity>? assets;
    try {
      final assetPaths =
          await PhotoManager.getAssetPathList(type: RequestType.audio);
      final recentAssetPath = assetPaths.isNotEmpty ? assetPaths[0] : null;
      assets = await recentAssetPath?.getAssetListRange(
        start: 0,
        end: 1000,
      );
    } catch (_) {
      log('Failed to get audio assets!', name: 'PhotoManagerService');
      throw GetAudioException();
    }

    if (assets == null) {
      log('Failed to get audio assets!', name: 'PhotoManagerService');
      throw GetAudioException();
    }

    return assets;
  }

  /// Gets the video assets.
  ///
  /// Throws a [PermissionException] if [isAuthenticated] is false.
  ///
  /// Throws a [GetVideoException] if could not get the video assets.
  Future<List<AssetEntity>> getVideos() async {
    if (!_isAuthenticated) {
      log('Permission denied!', name: 'PhotoManagerService');
      throw PermissionException();
    }

    final List<AssetEntity>? assets;
    try {
      final assetPaths =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      final recentAssetPath = assetPaths.isNotEmpty ? assetPaths[0] : null;
      assets = await recentAssetPath?.getAssetListRange(start: 0, end: 1000);
    } catch (_) {
      log('Failed to get video assets!', name: 'PhotoManagerService');
      throw GetVideoException();
    }

    if (assets == null) {
      log('Failed to get video assets!', name: 'PhotoManagerService');
      throw GetVideoException();
    }

    return assets;
  }

  /// Opens the settings.
  ///
  /// Throws a [OpenSettingsException] if could not open the settings.
  Future<void> openSettings() async {
    try {
      await PhotoManager.openSetting();
    } catch (_) {
      log('Failed to open settings!', name: 'PhotoManagerService');
      throw OpenSettingsException();
    }
  }
}
