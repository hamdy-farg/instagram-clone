import "package:image_picker/image_picker.dart";
import "package:flutter/material.dart";

Pickimage(ImageSource source) async {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) return _file.readAsBytes();
  print("mation field");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
