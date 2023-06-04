import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_service/photo_manager_service.dart';

void main() {
  late PhotoManagerService sut;

  group('PhotoManagerService', () {
    test('can be instantiated', () {
      expect(PhotoManagerService(), isNotNull);
    });

    test('can throw PermissionException when could not request permission',
        () async {
      sut = PhotoManagerService();

      expect(sut.requestPermission(), throwsA(isA<PermissionException>()));
    });

    test('can throw PermissionException when permission access gets denied',
        () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        permissionState: PermissionState.denied,
      );

      expect(sut.requestPermission(), throwsA(isA<PermissionException>()));
    });

    test('can get the permission', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        permissionState: PermissionState.authorized,
      );

      await sut.requestPermission();

      expect(sut.isAuthenticated, true);
    });

    test(
        'can throw PermissionException when getAudios gets called without '
        'authentication', () async {
      sut = PhotoManagerService.test();

      expect(sut.getAudios(), throwsA(isA<PermissionException>()));
    });

    test('can throw GetAudioException when can not get asset paths', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
      );

      expect(sut.getAudios(), throwsA(isA<GetAudioException>()));
    });

    test('can throw GetAudioException when can not get assets', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [
          AssetPathEntity(
            id: 'id',
            name: 'name',
          ),
        ],
      );

      expect(sut.getAudios(), throwsA(isA<GetAudioException>()));
    });

    test('can throw GetAudioException when there are no assets available',
        () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [],
      );

      expect(sut.getAudios(), throwsA(isA<GetAudioException>()));
    });

    test('can get audios when getAudios gets called', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [],
        assets: [],
      );

      expect(sut.getAudios(), isA<Future<List<AssetEntity>>>());
    });

    test(
        'can throw PermissionException when getVideos gets called without '
        'authentication', () async {
      sut = PhotoManagerService.test();

      expect(sut.getVideos(), throwsA(isA<PermissionException>()));
    });

    test('can throw GetVideoException when can not get asset paths', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
      );

      expect(sut.getVideos(), throwsA(isA<GetVideoException>()));
    });

    test('can throw GetVideoException when can not get assets', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [
          AssetPathEntity(
            id: 'id',
            name: 'name',
          ),
        ],
      );

      expect(sut.getVideos(), throwsA(isA<GetVideoException>()));
    });

    test('can throw GetVideoException when there are no assets available',
        () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [],
      );

      expect(sut.getVideos(), throwsA(isA<GetVideoException>()));
    });

    test('can get videos when getVideos gets called', () async {
      sut = PhotoManagerService.test(
        isAuthenticated: true,
        assetPaths: [],
        assets: [],
      );

      expect(sut.getVideos(), isA<Future<List<AssetEntity>>>());
    });

    test('can throw OpenSettingsException when can not open the settings',
        () async {
      sut = PhotoManagerService.test();

      expect(sut.openSettings(), throwsA(isA<OpenSettingsException>()));
    });
  });
}
