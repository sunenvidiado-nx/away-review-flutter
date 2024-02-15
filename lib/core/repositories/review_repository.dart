import 'package:away_review/core/common_providers/firestore_provider.dart';
import 'package:away_review/core/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewRepository {
  const ReviewRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const _collectionName = 'reviews';

  Future<List<Review>> getReviews() async {
    final snapshot = await _firestore.collection(_collectionName).get();

    return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }

  Future<void> addReview(Review review) async {
    await _firestore
        .collection(_collectionName)
        .add(review.toFirestoreObject());
  }
}

final reviewRepositoryProvider = Provider((ref) {
  return ReviewRepository(ref.read(firestoreProvider));
});
