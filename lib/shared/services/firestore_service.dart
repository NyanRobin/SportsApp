import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
// import '../models/game_model.dart';
// import '../models/announcement_model.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // User Collection
  CollectionReference get usersCollection => _firestore.collection('users');
  
  // Games Collection
  CollectionReference get gamesCollection => _firestore.collection('games');
  
  // Announcements Collection
  CollectionReference get announcementsCollection => _firestore.collection('announcements');
  
  // Statistics Collection
  CollectionReference get statisticsCollection => _firestore.collection('statistics');
  
  // Store user data
  Future<void> storeUserData({
    required String uid,
    required String email,
    required String name,
    String? phone,
    required bool isStudent,
    required String gradeOrSubject,
  }) async {
    try {
      await usersCollection.doc(uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'isStudent': isStudent,
        'gradeOrSubject': gradeOrSubject,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
  
  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return UserModel.fromMap(uid, data);
    } catch (e) {
      rethrow;
    }
  }
  
  // Get user data as Map (for backward compatibility)
  Future<Map<String, dynamic>?> getUserDataAsMap(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }
  
  // Update user data
  Future<void> updateUserData({
    required String uid,
    String? name,
    String? phone,
    String? gradeOrSubject,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (gradeOrSubject != null) data['gradeOrSubject'] = gradeOrSubject;
      
      await usersCollection.doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get all games (using Map for backward compatibility)
  Future<List<Map<String, dynamic>>> getAllGames() async {
    try {
      final snapshot = await gamesCollection.orderBy('date', descending: false).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get game by ID (using Map for backward compatibility)
  Future<Map<String, dynamic>?> getGameById(String gameId) async {
    try {
      final doc = await gamesCollection.doc(gameId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Add or update game (using Map for backward compatibility)
  Future<void> saveGame(Map<String, dynamic> game) async {
    try {
      final gameData = Map<String, dynamic>.from(game);
      gameData['updatedAt'] = FieldValue.serverTimestamp();
      
      final gameId = gameData['id'] as String?;
      if (gameId != null && gameId.isNotEmpty) {
        // Update existing game
        gameData.remove('id');
        await gamesCollection.doc(gameId).update(gameData);
      } else {
        // Add new game
        gameData.remove('id');
        gameData['createdAt'] = FieldValue.serverTimestamp();
        await gamesCollection.add(gameData);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Add or update game using Map (for backward compatibility)
  Future<void> saveGameFromMap(Map<String, dynamic> gameData, [String? gameId]) async {
    try {
      gameData['updatedAt'] = FieldValue.serverTimestamp();
      
      if (gameId != null) {
        // Update existing game
        await gamesCollection.doc(gameId).update(gameData);
      } else {
        // Add new game
        gameData['createdAt'] = FieldValue.serverTimestamp();
        await gamesCollection.add(gameData);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete game
  Future<void> deleteGame(String gameId) async {
    try {
      await gamesCollection.doc(gameId).delete();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get all announcements (using Map for backward compatibility)
  Future<List<Map<String, dynamic>>> getAllAnnouncements() async {
    try {
      final snapshot = await announcementsCollection.orderBy('date', descending: true).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get announcement by ID (using Map for backward compatibility)
  Future<Map<String, dynamic>?> getAnnouncementById(String announcementId) async {
    try {
      final doc = await announcementsCollection.doc(announcementId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Add or update announcement (using Map for backward compatibility)
  Future<void> saveAnnouncement(Map<String, dynamic> announcement) async {
    try {
      final announcementData = Map<String, dynamic>.from(announcement);
      announcementData['updatedAt'] = FieldValue.serverTimestamp();
      
      final announcementId = announcementData['id'] as String?;
      if (announcementId != null && announcementId.isNotEmpty) {
        // Update existing announcement
        announcementData.remove('id');
        await announcementsCollection.doc(announcementId).update(announcementData);
      } else {
        // Add new announcement
        announcementData.remove('id');
        announcementData['createdAt'] = FieldValue.serverTimestamp();
        await announcementsCollection.add(announcementData);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Add or update announcement using Map (for backward compatibility)
  Future<void> saveAnnouncementFromMap(Map<String, dynamic> announcementData, [String? announcementId]) async {
    try {
      announcementData['updatedAt'] = FieldValue.serverTimestamp();
      
      if (announcementId != null) {
        // Update existing announcement
        await announcementsCollection.doc(announcementId).update(announcementData);
      } else {
        // Add new announcement
        announcementData['createdAt'] = FieldValue.serverTimestamp();
        await announcementsCollection.add(announcementData);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await announcementsCollection.doc(announcementId).delete();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get user statistics
  Future<Map<String, dynamic>?> getUserStatistics(String uid) async {
    try {
      final doc = await statisticsCollection.doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }
  
  // Update user statistics
  Future<void> updateUserStatistics(String uid, Map<String, dynamic> statisticsData) async {
    try {
      statisticsData['updatedAt'] = FieldValue.serverTimestamp();
      
      final docRef = statisticsCollection.doc(uid);
      final doc = await docRef.get();
      
      if (doc.exists) {
        // Update existing statistics
        await docRef.update(statisticsData);
      } else {
        // Create new statistics document
        statisticsData['createdAt'] = FieldValue.serverTimestamp();
        await docRef.set(statisticsData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
