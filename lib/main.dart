import 'package:field_visit_logger_app/view_model/add_visit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/visit_repository.dart';
import 'services/sync_service.dart';
import 'view_model/visit_auth_view_model.dart';
import 'view_model/visit_list_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final visitRepository = VisitRepository();
  await visitRepository.syncPendingVisits();
  final syncService = SyncService();
  syncService.startListening();

  runApp(FieldVisitLoggerApp(visitRepository: visitRepository));
}

class FieldVisitLoggerApp extends StatelessWidget {
  final VisitRepository visitRepository;

  const FieldVisitLoggerApp({super.key, required this.visitRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitAuthViewModel(),),
        ChangeNotifierProvider( create: (_) => VisitListViewModel(visitRepository),),
        ChangeNotifierProvider(create: (_) => AddVisitViewModel(visitRepository), ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Field Visit Logger',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}