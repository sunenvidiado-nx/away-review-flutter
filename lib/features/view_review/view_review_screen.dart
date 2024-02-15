import 'package:away_review/core/auth/auth_service.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:away_review/core/models/review.dart';
import 'package:away_review/core/models/review_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewReviewScreen extends ConsumerWidget {
  const ViewReviewScreen(this.review, {super.key});

  final Review review;

  Color get reviewColor =>
      ReviewScale.getColorByRating(review.average, weight: 100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authServiceProvider).currentUser!;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: reviewColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: reviewColor,
        appBar: AppBar(
          title: Text('By ${currentUser.email?.split('@').first}'),
          backgroundColor: reviewColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {}, // TODO Add an action
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _buildOverallRating(context),
            const SizedBox(height: 20),
            _buildScale(context, review.average),
            const SizedBox(height: 20),
            _buildCriteria(context, review),
            const SizedBox(height: 32),
            _buildAddtionalNotes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallRating(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.title,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              review.createdAtFormatted,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: review.average.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: ' / 5',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScale(BuildContext context, num rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Opacity(
              opacity: rating >= 1 && rating < 2 ? 1 : 0.3,
              child: const Text(
                ReviewScale.five,
                style: TextStyle(fontSize: 50),
              ),
            ),
            Opacity(
              opacity: rating >= 2 && rating < 3 ? 1 : 0.3,
              child: const Text(
                ReviewScale.four,
                style: TextStyle(fontSize: 50),
              ),
            ),
            Opacity(
              opacity: rating >= 3 && rating < 4 ? 1 : 0.3,
              child: const Text(
                ReviewScale.three,
                style: TextStyle(fontSize: 50),
              ),
            ),
            Opacity(
              opacity: rating >= 4 && rating < 5 ? 1 : 0.3,
              child: const Text(
                ReviewScale.two,
                style: TextStyle(fontSize: 50),
              ),
            ),
            Opacity(
              opacity: rating == 5 ? 1 : 0.3,
              child: const Text(
                ReviewScale.one,
                style: TextStyle(fontSize: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteria(BuildContext context, Review review) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildCriteriaItemWidgets(
            context,
            title: 'Topic',
            value: review.topic,
          ),
          const SizedBox(height: 12),
          ..._buildCriteriaItemWidgets(
            context,
            title: 'Duration',
            value: review.duration,
          ),
          const SizedBox(height: 12),
          ..._buildCriteriaItemWidgets(
            context,
            title: 'Dramatics',
            value: review.dramatics,
          ),
          const SizedBox(height: 12),
          ..._buildCriteriaItemWidgets(
            context,
            title: 'Emotional Impact',
            value: review.emotionalImpact,
          ),
          const SizedBox(height: 12),
          ..._buildCriteriaItemWidgets(
            context,
            title: 'Aftermath',
            value: review.aftermath,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCriteriaItemWidgets(
    BuildContext context, {
    required String title,
    required num value,
  }) {
    return [
      Row(
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value.toStringAsFixed(1),
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        height: 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value / 5,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildAddtionalNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          review.notes,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
