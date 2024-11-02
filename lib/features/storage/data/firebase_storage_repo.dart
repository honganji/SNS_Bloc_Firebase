import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sns_bloc_firebase/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  /* Profile */
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  /* Post */
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }
  /* HELPER METHODS - upload files to storage */

  // mobile platforms (file)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      final file = File(path);
      final fileSize = await file.length();
      print('File size: $fileSize bytes');
      print('file name: $fileName');
      final storageRef = firebaseStorage.ref().child('$folder/${DateTime.now().millisecondsSinceEpoch.toString()}');
      // final storageRef = firebaseStorage.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, stackTrace) {
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
        print("Error code: ${e.code}");
        print("Stack trace: $stackTrace");
      } else {
        print("Unknown error: $e");
        print("Stack trace: $stackTrace");
      }
      return null;
    }
  }

  // web platforms (bytes)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      final storageRef = firebaseStorage.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putData(fileBytes);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
