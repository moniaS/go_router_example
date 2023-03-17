import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class Routes {
  static String books = 'books';
  static String booksDetails = 'books_details';
  static String categories = 'categories';
}

void main() {
  usePathUrlStrategy();
  runApp(const GoRouterExampleApp());
}

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/books',
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            key: state.pageKey,
            child: Scaffold(
              body: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Books'),
                          onTap: () => context.goNamed(Routes.books),
                        ),
                        ListTile(
                          title: const Text('Categories'),
                          onTap: () => context.goNamed(Routes.categories),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: child,
                  )
                ],
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: Routes.books,
            path: '/books',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const BooksScreen(),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: Routes.booksDetails,
                path: 'details',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: const BookDetailsScreen(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: Routes.categories,
            path: '/categories',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const CategoriesScreen(),
              );
            },
          ),
        ],
      )
    ],
  );
}

class GoRouterExampleApp extends StatefulWidget {
  /// Creates a [GoRouterExampleApp]
  const GoRouterExampleApp({super.key});

  @override
  State<GoRouterExampleApp> createState() => _GoRouterExampleAppState();
}

class _GoRouterExampleAppState extends State<GoRouterExampleApp> {
  final router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}

class BooksScreen extends StatelessWidget {
  /// Constructs a [BooksScreen] widget.
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final queryParams = GoRouterState.of(context).queryParams;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Books'),
            Text('Books type: ${queryParams['type']}'),
            TextButton(
              onPressed: () {
                context.goNamed(Routes.booksDetails);
              },
              child: const Text('Go to details'),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(Routes.books, queryParams: {'type': 'all'});
              },
              child: const Text('Add type to Query Params'),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(Routes.books, queryParams: {'type': 'single'});
              },
              child: const Text('Change type of Query Params to Single'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  /// Constructs a [BooksScreen] widget.
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final queryParams = GoRouterState.of(context).queryParams;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Categories'),
          ],
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouterState.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Book details'),
          ],
        ),
      ),
    );
  }
}
