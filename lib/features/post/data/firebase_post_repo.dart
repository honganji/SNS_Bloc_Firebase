import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_bloc_firebase/features/post/domain/entities/post.dart';
import 'package:sns_bloc_firebase/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot =
          await postsCollection.orderBy("timestamp", descending: true).get();
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching post: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where("userId", isEqualTo: userId).get();
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        final hasLiked = post.likes.contains(userId);
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await postsCollection.doc(postId).update({"likes": post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error toggling like: $e");
    }
  }
}
