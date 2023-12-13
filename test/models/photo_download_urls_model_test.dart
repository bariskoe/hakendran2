import 'package:baristodolistapp/models/downloadable_photos_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhotoDownloadUrlsModel', () {
    test('creates model with valid downloadable image data', () {
      // Arrange
      final downloadableImages = [
        DownloadableImage(imagePath: 'imagePath1', downLoadUrl: 'url1'),
        DownloadableImage(imagePath: 'imagePath2', downLoadUrl: 'url2'),
      ];

      // Act
      final photoDownloadUrlsModel = PhotoDownloadUrlsModel(
        downloadableImages: downloadableImages,
      );

      // Assert
      expect(photoDownloadUrlsModel.downloadableImages, downloadableImages);
    });

    test('throws error if creating model with empty downloadable images list',
        () {
      // Arrange
      final downloadableImages = <DownloadableImage>[];

      // Act
      try {
        PhotoDownloadUrlsModel(downloadableImages: downloadableImages);
      } on Exception catch (error) {
        // Assert
        expect(
            error.toString(), contains('downloadableImages cannot be empty'));
      }
    });
  });
}
