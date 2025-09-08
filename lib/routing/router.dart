import 'package:go_router/go_router.dart';
import 'package:mastering_tests/routing/routes.dart';
import 'package:mastering_tests/ui/tasks/widgets/todo_list_screen.dart';
import 'package:mastering_tests/ui/video_explore/widget/video_explore.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return FitnessPlusScreen();
      },
    )
  ],
);
