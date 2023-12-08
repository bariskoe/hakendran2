// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ImagePickerService {
  final ImagePicker imagePicker;
  ImagePickerService({
    required this.imagePicker,
  });

  factory ImagePickerService.forDi(ImagePicker imagePicker) {
    return ImagePickerService(imagePicker: imagePicker)..initialize();
  }

  XFile? _image;

  Future<XFile?> takePhotoWithCamera() async {
    try {
      _image = await imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 40,
          maxHeight: 500,
          maxWidth: 500);

      return _image;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  initialize() {}
}
