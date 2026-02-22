import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_model/visit_list_view_model.dart';
import '../../widgets/visit_card.dart';

class VisitListScreen extends StatelessWidget {
  const VisitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VisitListViewModel visitListViewModel =
    context.watch<VisitListViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Field Visits'),
        actions: [

          if (visitListViewModel.isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: visitListViewModel.loadVisits,
            ),
        ],
      ),


      body: RefreshIndicator(
        onRefresh: visitListViewModel.loadVisits,
        color: const Color(0xFF2E7D32),
        child: _buildBody(context, visitListViewModel),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final wasAdded = await context.push('/visit-add');
          if (wasAdded == true && context.mounted) {
            visitListViewModel.loadVisits();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Visit'),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, VisitListViewModel visitListViewModel) {

    if (visitListViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (visitListViewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.error_outline,
                    size: 36, color: Colors.red),
              ),
              const SizedBox(height: 16),
              Text(
                visitListViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: visitListViewModel.loadVisits,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (visitListViewModel.visits.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    size: 52,
                    color: Color(0xFF81C784),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Visits Yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start recording your first\nfield visit by tapping below',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9E9E9E),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Text(
                '${visitListViewModel.visits.length} Visit${visitListViewModel.visits.length > 1 ? 's' : ''} Recorded',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const Spacer(),
              _PendingSyncBadge(
                pendingCount: visitListViewModel.visits
                    .where((v) => !v.isSynced)
                    .length,
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 80),
            itemCount: visitListViewModel.visits.length,
            itemBuilder: (context, index) {
              final visit = visitListViewModel.visits[index];
              return VisitCard(
                visit: visit,
                onTap: () => context.push('/visit-detail', extra: visit),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PendingSyncBadge extends StatelessWidget {
  final int pendingCount;
  const _PendingSyncBadge({required this.pendingCount});

  @override
  Widget build(BuildContext context) {
    if (pendingCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE65100), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_upload_rounded,
              size: 13, color: Color(0xFFE65100)),
          const SizedBox(width: 4),
          Text(
            '$pendingCount Pending',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}