import 'package:go_router/go_router.dart';
import '../../data/models/visit_model.dart';
import '../../view/screens/login/login_screen.dart';
import '../../view/screens/visit_add/add_visit_screen.dart';
import '../../view/screens/visit_detail/visit_detail_screen.dart';
import '../../view/screens/visit_list/visit_list_screen.dart';



final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),


    GoRoute(
      path: '/visit-list',
      builder: (context, state) => const VisitListScreen(),
    ),


    GoRoute(
      path: '/visit-add',
      builder: (context, state) => const AddVisitScreen(),
    ),


    GoRoute(
      path: '/visit-detail',
      builder: (context, state) => VisitDetailScreen(
        visit: state.extra as VisitModel,
      ),
    ),
  ],
);