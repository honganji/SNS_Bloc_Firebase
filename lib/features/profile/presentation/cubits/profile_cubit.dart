import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_bloc_firebase/features/profile/domain/entities/profile_user.dart';
import 'package:sns_bloc_firebase/features/profile/domain/repos/profile_repo.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/cubits/profile_states.dart';
import 'package:sns_bloc_firebase/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // update bio and / or profile picture
  Future<void> updateProfile(
      {required String uid,
      String? bio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    try {
      emit(ProfileLoading());
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      String? imageDownloadUrl;
      if (imageWebBytes != null || imageMobilePath != null) {
        // TODO remove
        print(imageMobilePath);
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
              imageMobilePath,
              DateTime.now().millisecondsSinceEpoch.toString());
        } else if (imageWebBytes != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
              imageWebBytes, DateTime.now().millisecondsSinceEpoch.toString());
        }
        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }
      final updatedProfile = currentUser.copyWith(
        newBio: bio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );
      await profileRepo.updateProfile(updatedProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }

  // toggle follow/unfollow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      await profileRepo.toggleFollow(currentUid, targetUid);
    } catch (e) {
      emit(ProfileError("Error toggling follow: $e"));
    }
  }
}
