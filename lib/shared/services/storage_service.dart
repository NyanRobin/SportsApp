import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService extends ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload a file to Firebase Storage
  Future<String> uploadFile({
    required File file,
    required String path,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = _storage.ref().child('$path/$fileName');
      
      final uploadTask = ref.putFile(file);
      
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Upload data (e.g., from memory) to Firebase Storage
  Future<String> uploadData({
    required Uint8List data,
    required String path,
    required String fileName,
    String? contentType,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = _storage.ref().child('$path/$fileName');
      
      final metadata = SettableMetadata(
        contentType: contentType,
      );
      
      final uploadTask = ref.putData(data, metadata);
      
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Get download URL for a file
  Future<String> getDownloadURL(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete a file from Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
  
  // List files in a directory
  Future<List<String>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();
      
      final List<String> fileNames = [];
      for (final item in result.items) {
        fileNames.add(item.name);
      }
      
      return fileNames;
    } catch (e) {
      rethrow;
    }
  }
  
  // Get metadata for a file
  Future<Map<String, dynamic>> getMetadata(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = await ref.getMetadata();
      
      return {
        'name': metadata.name,
        'path': metadata.fullPath,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'createdAt': metadata.timeCreated,
        'updatedAt': metadata.updated,
      };
    } catch (e) {
      rethrow;
    }
  }
  
  // Generate a unique filename
  String generateUniqueFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = originalName.split('.').last;
    return '$timestamp.$extension';
  }
  
  // Helper method to get file paths for different types of content
  String getPathForContent(String contentType, String uid) {
    switch (contentType) {
      case 'profile':
        return 'users/$uid/profile';
      case 'game':
        return 'games';
      case 'announcement':
        return 'announcements';
      default:
        return 'misc';
    }
  }
}
