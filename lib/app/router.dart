import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/owner/collections_screen.dart';
import '../features/owner/lease_wizard_screen.dart';
import '../features/owner/maintenance_board_screen.dart';
import '../features/owner/owner_home_screen.dart';
import '../features/owner/properties_screen.dart';
import '../features/owner/property_screen.dart';
import '../features/owner/reports_screen.dart';
import '../features/owner/settings_screen.dart';
import '../features/owner/tenants_screen.dart';
import '../features/owner/unit_screen.dart';
import '../features/shared/shells.dart';
import '../features/shared/ticket_screen.dart';
import '../features/tenant/lease_screen.dart';
import '../features/tenant/maintenance_screen.dart';
import '../features/tenant/new_request_screen.dart';
import '../features/tenant/notifications_screen.dart';
import '../features/tenant/pay_screen.dart';
import '../features/tenant/payments_screen.dart';
import '../features/tenant/receipt_screen.dart';
import '../features/tenant/tenant_home_screen.dart';
import '../features/welcome/welcome_screen.dart';
import '../state/providers.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class Routes {
  Routes._();
  static const welcome = '/welcome';

  static const tenantHome = '/t/home';
  static const tenantPayments = '/t/payments';
  static const tenantMaintenance = '/t/maintenance';
  static const tenantLease = '/t/lease';
  static String pay(String installmentId) => '/t/pay/$installmentId';
  static String receipt(String installmentId) => '/t/receipt/$installmentId';
  static const newRequest = '/t/request';
  static String tenantTicket(String id) => '/t/ticket/$id';
  static const notifications = '/t/notifications';

  static const ownerHome = '/o/home';
  static const properties = '/o/properties';
  static const collections = '/o/collections';
  static const board = '/o/maintenance';
  static const reports = '/o/reports';
  static String property(String id) => '/o/property/$id';
  static String unit(String id) => '/o/unit/$id';
  static String ownerTicket(String id) => '/o/ticket/$id';
  static const tenants = '/o/tenants';
  static String lease([String? unitId]) =>
      '/o/lease${unitId == null ? '' : '?unit=$unitId'}';
  static const settings = '/o/settings';

  static String homeFor(UserRole role) =>
      role == UserRole.tenant ? tenantHome : ownerHome;
}

Page<void> _fadeThrough(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, a, _, child) {
        final curved = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );

GoRoute _push(String path, Widget Function(GoRouterState s) build) => GoRoute(
  path: path,
  parentNavigatorKey: rootNavigatorKey,
  pageBuilder: (_, s) => _fadeThrough(s, build(s)),
);

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run redirects whenever the chosen role changes.
  final roleListenable = ValueNotifier<UserRole?>(
    ref.read(settingsProvider).role,
  );
  ref.listen(settingsProvider.select((s) => s.role), (_, next) {
    roleListenable.value = next;
  });
  ref.onDispose(roleListenable.dispose);

  StatefulShellBranch branch(String path, Widget screen) => StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (_, s) => NoTransitionPage(child: screen),
      ),
    ],
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.welcome,
    refreshListenable: roleListenable,
    redirect: (context, state) {
      final role = roleListenable.value;
      final path = state.matchedLocation;
      final onWelcome = path == Routes.welcome;
      if (role == null) return onWelcome ? null : Routes.welcome;
      if (onWelcome) return Routes.homeFor(role);
      if (role == UserRole.tenant && path.startsWith('/o/')) {
        return Routes.tenantHome;
      }
      if (role == UserRole.owner && path.startsWith('/t/')) {
        return Routes.ownerHome;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.welcome),
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (_, s) => _fadeThrough(s, const WelcomeScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => TenantShell(shell: shell),
        branches: [
          branch(Routes.tenantHome, const TenantHomeScreen()),
          branch(Routes.tenantPayments, const PaymentsScreen()),
          branch(Routes.tenantMaintenance, const MaintenanceScreen()),
          branch(Routes.tenantLease, const LeaseScreen()),
        ],
      ),
      _push(
        '/t/pay/:id',
        (s) => PayScreen(installmentId: s.pathParameters['id']!),
      ),
      _push(
        '/t/receipt/:id',
        (s) => ReceiptScreen(
          installmentId: s.pathParameters['id']!,
          justPaid: s.uri.queryParameters['new'] == '1',
        ),
      ),
      _push(Routes.newRequest, (_) => const NewRequestScreen()),
      _push(
        '/t/ticket/:id',
        (s) => TicketScreen(ticketId: s.pathParameters['id']!),
      ),
      _push(Routes.notifications, (_) => const NotificationsScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => OwnerShell(shell: shell),
        branches: [
          branch(Routes.ownerHome, const OwnerHomeScreen()),
          branch(Routes.properties, const PropertiesScreen()),
          branch(Routes.collections, const CollectionsScreen()),
          branch(Routes.board, const MaintenanceBoardScreen()),
          branch(Routes.reports, const ReportsScreen()),
        ],
      ),
      _push(
        '/o/property/:id',
        (s) => PropertyScreen(propertyId: s.pathParameters['id']!),
      ),
      _push('/o/unit/:id', (s) => UnitScreen(unitId: s.pathParameters['id']!)),
      _push(
        '/o/ticket/:id',
        (s) => TicketScreen(ticketId: s.pathParameters['id']!, ownerView: true),
      ),
      _push(Routes.tenants, (_) => const TenantsScreen()),
      _push(
        '/o/lease',
        (s) => LeaseWizardScreen(unitId: s.uri.queryParameters['unit']),
      ),
      _push(Routes.settings, (_) => const SettingsScreen()),
    ],
  );
});
