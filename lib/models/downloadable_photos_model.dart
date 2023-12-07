import 'dart:convert';

class PhotoDownloadUrlsModel {
  List<DownloadableImage> downloadableImages;

  PhotoDownloadUrlsModel({
    required this.downloadableImages,
  });

  PhotoDownloadUrlsModel copyWith({
    List<DownloadableImage>? downloadableImages,
  }) =>
      PhotoDownloadUrlsModel(
        downloadableImages: downloadableImages ?? this.downloadableImages,
      );

  factory PhotoDownloadUrlsModel.fromRawJson(String str) =>
      PhotoDownloadUrlsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhotoDownloadUrlsModel.fromJson(Map<String, dynamic> json) =>
      PhotoDownloadUrlsModel(
        downloadableImages: List<DownloadableImage>.from(
            json["downloadableImages"]
                .map((x) => DownloadableImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "downloadableImages":
            List<dynamic>.from(downloadableImages.map((x) => x.toJson())),
      };
}

class DownloadableImage {
  String imagePath;
  String downLoadUrl;

  DownloadableImage({
    required this.imagePath,
    required this.downLoadUrl,
  });

  DownloadableImage copyWith({
    String? imagePath,
    String? downLoadUrl,
  }) =>
      DownloadableImage(
        imagePath: imagePath ?? this.imagePath,
        downLoadUrl: downLoadUrl ?? this.downLoadUrl,
      );

  factory DownloadableImage.fromRawJson(String str) =>
      DownloadableImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DownloadableImage.fromJson(Map<String, dynamic> json) =>
      DownloadableImage(
        imagePath: json["imagePath"],
        downLoadUrl: json["downLoadUrl"],
      );

  Map<String, dynamic> toJson() => {
        "imagePath": imagePath,
        "downLoadUrl": downLoadUrl,
      };
}
