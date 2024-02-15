import 'package:away_review/app/router.dart';
import 'package:away_review/app/theme.dart';
import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      theme: theme,
      builder: (context, child) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: context.colorScheme.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: KeyboardDismissOnTap(child: child!),
        );
      },
    );
  }
}
