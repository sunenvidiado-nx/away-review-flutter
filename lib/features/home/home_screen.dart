import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/models/review_scale.dart';
import 'package:away_review/core/models/review.dart';
import 'package:away_review/features/home/reviews_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        actions: [_buildPopupMenuButton(context, ref)],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(reviewsProvider.future),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: state.when(
            data: (reviews) => _buildBody(reviews, context, ref),
            loading: () => const Center(
              key: Key('loading'),
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Center(
              key: const Key('error'),
              child: Text(error.toString()),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddReviewButton(context),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Icon(Icons.more_vert),
      ),
      onSelected: (value) async {
        if (value == 'signOut') {
          // Delay sign out because it's too damn fast
          await Future.delayed(const Duration(milliseconds: 300));
          await ref.read(authServiceProvider).signOut();
          ref.invalidate(signedInProvider);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(value: 'signOut', child: Text('Sign Out')),
        ];
      },
    );
  }

  Widget _buildBody(List<Review> reviews, BuildContext context, WidgetRef ref) {
    if (reviews.isEmpty) {
      return Center(
        key: const Key('empty'),
        child: Text(
          "There's nothing here yet.\nMag-away muna kayo.",
          style: TextStyle(
            color: context.colorScheme.secondary.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      key: ValueKey(reviews.length),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return _buildListItem(reviews[index], context, ref);
      },
    );
  }

  Widget _buildListItem(
    Review review,
    BuildContext context,
    WidgetRef ref,
  ) {
    final currentUser = ref.read(authServiceProvider).currentUser!;
    final author = currentUser.email == review.createdByEmail
        ? '${currentUser.email!} (you)'
        : currentUser.email!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Card(
        color: ReviewScale.getColorByRating(review.average, weight: 100),
        child: InkWell(
          onTap: () => context.push('/review', extra: review),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      review.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      ReviewScale.getEmojiByRating(review.average),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${review.createdAtFormatted} - $author',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  review.notes,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddReviewButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/create-review'),
      label: const Text('Add Review'),
      icon: const Icon(Icons.add),
    );
  }
}
