import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/models/review.dart';
import 'package:away_review/core/repositories/review_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateReviewScreen extends ConsumerStatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateReviewScreenState();
}

class _CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  late Review _review;

  final _noteController = TextEditingController();

  var _isPublishing = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authServiceProvider).currentUser!;
    _review = Review.empty().copyWith(createdBy: currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: context.pop,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          _buildRating(
            title: 'Topic',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              _review = _review.copyWith(topic: rating.toInt());
            },
          ),
          _buildRating(
            title: 'Duration',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              _review = _review.copyWith(duration: rating.toInt());
            },
          ),
          _buildRating(
            title: 'Dramatics',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              _review = _review.copyWith(dramatics: rating.toInt());
            },
          ),
          _buildRating(
            title: 'Emotional Impact',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              _review = _review.copyWith(emotionalImpact: rating.toInt());
            },
          ),
          _buildRating(
            title: 'Aftermath',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              _review = _review.copyWith(aftermath: rating.toInt());
            },
          ),
          SliverToBoxAdapter(
            child: Divider(
              color: context.colorScheme.secondary.withOpacity(0.1),
              thickness: 1,
            ),
          ),
          _buildNotesField(),
          SliverToBoxAdapter(
            child: Divider(
              color: context.colorScheme.secondary.withOpacity(0.1),
              thickness: 1,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildPublishReviewButton(),
          const SliverToBoxAdapter(child: SizedBox(height: 64)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 28.0),
        child: Text(
          'Create a review',
          style: context.textTheme.headlineLarge,
        ),
      ),
    );
  }

  Widget _buildRating({
    required String title,
    required String subtitle,
    required Function(double) onRatingUpdate,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              itemCount: 5,
              glow: false,
              itemSize: 60,
              tapOnlyMode: true,
              unratedColor: context.colorScheme.secondary.withOpacity(0.4),
              itemBuilder: (context, index) => switch (index) {
                0 => const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  ),
                1 => Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.red[300],
                  ),
                2 => const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  ),
                3 => const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  ),
                4 => const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  ),
                _ => throw UnimplementedError(),
              },
              onRatingUpdate: onRatingUpdate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional notes',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sit amet.',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              minLines: 8,
              maxLines: 12,
              decoration: InputDecoration(
                hintText: 'Write your thoughts here...',
                hintStyle: context.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  color: context.colorScheme.secondary.withOpacity(0.6),
                ),
              ),
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishReviewButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isPublishing
              ? null
              : () async {
                  setState(() {
                    _isPublishing = true;
                  });

                  try {
                    _review = _review.copyWith(notes: _noteController.text);

                    if (_review.topic == 0 ||
                        _review.duration == 0 ||
                        _review.dramatics == 0 ||
                        _review.emotionalImpact == 0 ||
                        _review.aftermath == 0) {
                      throw 'Please rate all the topics';
                    }

                    await ref
                        .read(reviewRepositoryProvider)
                        .addReview(_review)
                        .then((_) => context.go('/'));
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    context.showDefaultSnackBar(e.toString());
                  } finally {
                    setState(() {
                      _isPublishing = false;
                    });
                  }
                },
          child: const Text('Publish review'),
        ),
      ),
    );
  }
}
