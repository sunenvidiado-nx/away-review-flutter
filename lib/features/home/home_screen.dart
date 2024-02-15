import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
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
      itemBuilder: (context, index) => _buildListItem(reviews[index], context),
    );
  }

  Widget _buildListItem(Review review, BuildContext context) {
    final ratingColor = review.average > 4
        ? Colors.lightGreen[100]
        : review.average > 3
            ? Colors.lime[100]
            : review.average > 2
                ? Colors.amber[100]
                : review.average > 1
                    ? Colors.orange[100]
                    : Colors.deepOrange[100];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Card(
        color: ratingColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIcon(review.average, context),
                  const SizedBox(width: 8),
                  Text(
                    review.createdAtFormatted,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                    '${review.average.toStringAsFixed(0)}/5',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
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
    );
  }

  Widget _buildIcon(double rating, BuildContext context) {
    return Icon(
      rating >= 4
          ? Icons.sentiment_very_satisfied
          : rating >= 3
              ? Icons.sentiment_satisfied
              : rating >= 2
                  ? Icons.sentiment_neutral
                  : rating >= 1
                      ? Icons.sentiment_dissatisfied
                      : Icons.sentiment_very_dissatisfied,
      color: context.colorScheme.primary,
      size: 30,
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
