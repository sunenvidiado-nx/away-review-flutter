import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/models/review.dart';
import 'package:away_review/core/repositories/review_repository.dart';
import 'package:away_review/features/home/reviews_provider.dart';
import 'package:flutter/material.dart';
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
  final _titleController = TextEditingController();

  var _isPublishing = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authServiceProvider).currentUser!;
    _review = Review.empty().copyWith(createdBy: currentUser.uid);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create review'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: context.pop,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildTitleTextField(),
          _buildRating(
            rating: _review.topic,
            title: 'Topic',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              setState(() {
                _review = _review.copyWith(topic: rating);
              });
            },
          ),
          _buildRating(
            rating: _review.duration,
            title: 'Duration',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              setState(() {
                _review = _review.copyWith(duration: rating);
              });
            },
          ),
          _buildRating(
            rating: _review.dramatics,
            title: 'Dramatics',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              setState(() {
                _review = _review.copyWith(dramatics: rating);
              });
            },
          ),
          _buildRating(
            rating: _review.emotionalImpact,
            title: 'Emotional Impact',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              setState(() {
                _review = _review.copyWith(emotionalImpact: rating);
              });
            },
          ),
          _buildRating(
            rating: _review.aftermath,
            title: 'Aftermath',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur.',
            onRatingUpdate: (rating) {
              setState(() {
                _review = _review.copyWith(aftermath: rating);
              });
            },
          ),
          SliverToBoxAdapter(
            child: Divider(
              color: context.colorScheme.secondary.withOpacity(0.1),
              thickness: 1,
            ),
          ),
          _buildNotesTextField(),
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

  Widget _buildTitleTextField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Ano pinagawayan nyo",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating({
    required int rating,
    required String title,
    required String subtitle,
    required Function(int) onRatingUpdate,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 60,
                    onPressed: () => onRatingUpdate(1),
                    icon: Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: rating == 1
                          ? Colors.deepOrange
                          : context.colorScheme.secondary.withOpacity(0.35),
                    ),
                  ),
                  IconButton(
                    iconSize: 60,
                    onPressed: () => onRatingUpdate(2),
                    icon: Icon(
                      Icons.sentiment_dissatisfied,
                      color: rating == 2
                          ? Colors.orange
                          : context.colorScheme.secondary.withOpacity(0.35),
                    ),
                  ),
                  IconButton(
                    iconSize: 60,
                    onPressed: () => onRatingUpdate(3),
                    icon: Icon(
                      Icons.sentiment_neutral,
                      color: rating == 3
                          ? Colors.amber
                          : context.colorScheme.secondary.withOpacity(0.35),
                    ),
                  ),
                  IconButton(
                    iconSize: 60,
                    onPressed: () => onRatingUpdate(4),
                    icon: Icon(
                      Icons.sentiment_satisfied,
                      color: rating == 4
                          ? Colors.lime
                          : context.colorScheme.secondary.withOpacity(0.35),
                    ),
                  ),
                  IconButton(
                    iconSize: 60,
                    onPressed: () => onRatingUpdate(5),
                    icon: Icon(
                      Icons.sentiment_very_satisfied,
                      color: rating == 5
                          ? Colors.lightGreen
                          : context.colorScheme.secondary.withOpacity(0.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesTextField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional notes',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sit amet.',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              minLines: 8,
              maxLines: 12,
              decoration: InputDecoration(
                hintText: 'Write here (optional)',
                hintStyle: context.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  color: context.colorScheme.secondary.withOpacity(0.8),
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
                    if (_titleController.text.isEmpty) {
                      throw 'Please specify a title.';
                    }

                    _review = _review.copyWith(
                      notes: _noteController.text,
                      title: _titleController.text,
                    );

                    if (_review.topic == 0 ||
                        _review.duration == 0 ||
                        _review.dramatics == 0 ||
                        _review.emotionalImpact == 0 ||
                        _review.aftermath == 0) {
                      throw 'Please add ratings for all items.';
                    }

                    await ref.read(reviewRepositoryProvider).addReview(_review);

                    // ignore: unused_result
                    await ref.refresh(reviewsProvider.future);

                    // ignore: use_build_context_synchronously
                    context.go('/');
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
