import 'package:away_review/core/repositories/review_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewsProvider = FutureProvider.autoDispose((ref) async {
  return ref.read(reviewRepositoryProvider).getReviews();
});
