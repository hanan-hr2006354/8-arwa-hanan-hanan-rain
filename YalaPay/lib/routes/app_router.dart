// app_router.dart

import 'package:go_router/go_router.dart';
import 'package:quickmart/screens/cheques_report_screen.dart';
import 'package:quickmart/screens/customer_editor_screen.dart';
import 'package:quickmart/screens/customers_screen.dart';
import 'package:quickmart/screens/invoice_report_screen.dart';
import 'package:quickmart/screens/invoices_screen.dart';
import 'package:quickmart/screens/login_screen.dart';
import 'package:quickmart/screens/dashboard_screen.dart';
import 'package:quickmart/screens/manage_cashing_screen.dart';
import 'package:quickmart/screens/payments_screen.dart';
import 'package:quickmart/screens/shell_screen.dart';
import 'package:quickmart/screens/start_screen.dart';
import 'package:quickmart/screens/cheque_deposits_screen.dart'; // Import the new deposits screen

class AppRouter {
  static const start = (name: 'start', path: '/');
  static const login = (name: 'login', path: '/login');
  static const main = (name: 'main', path: '/main');
  static const customer = (name: 'customer', path: '/customer');
  static const invoice = (name: 'invoice', path: '/invoice');
  static const payment = (name: 'payment', path: '/payment');
  static const manageCashing = (name: 'manageCashing', path: '/manageCashing');
  static const invoiceReport = (name: 'invoiceReport', path: '/invoiceReport');
  static const chequesReport = (name: 'chequesReport', path: '/chequesReport');
  static const chequeDeposits =
      (name: 'chequeDeposits', path: '/chequeDeposits'); // New route
  static const customerEditor =
      (name: 'customerEditor', path: '/customers/customerEditor/:customerId');
  static final router = GoRouter(
    initialLocation: start.path,
    routes: [
      GoRoute(
          name: start.name,
          path: start.path,
          builder: (context, state) => const StartScreen(),
          routes: [
            GoRoute(
              name: login.name,
              path: login.path,
              builder: (context, state) => LoginScreen(),
            ),
            ShellRoute(
              routes: [
                GoRoute(
                  name: main.name,
                  path: main.path,
                  builder: (context, state) => DashboardScreen(),
                ),
                GoRoute(
                    name: customer.name,
                    path: customer.path,
                    builder: (context, state) => CustomersScreen(),
                    routes: [
                      GoRoute(
                        name: customerEditor.name,
                        path: customerEditor.path,
                        builder: (context, state) {
                          final customerId = state.pathParameters['customerId'];
                          return CustomerEditor(customerId: customerId);
                        },
                      ),
                    ]),
                GoRoute(
                  name: invoice.name,
                  path: invoice.path,
                  builder: (context, state) => InvoicesScreen(),
                ),
                GoRoute(
                  name: payment.name,
                  path: payment.path,
                  builder: (context, state) => PaymentsScreen(),
                ),
                GoRoute(
                  name: manageCashing.name,
                  path: manageCashing.path,
                  builder: (context, state) => ManageCashingsScreen(),
                ),
                GoRoute(
                  name: invoiceReport.name,
                  path: invoiceReport.path,
                  builder: (context, state) => InvoiceReportScreen(),
                ),
                GoRoute(
                  name: chequesReport.name,
                  path: chequesReport.path,
                  builder: (context, state) => ChequesReportScreen(),
                ),
                GoRoute(
                  name: chequeDeposits.name,
                  path: chequeDeposits.path,
                  builder: (context, state) =>
                      ChequeDepositsScreen(), // Add builder for the new route
                ),
              ],
              builder: (context, state, child) => ShellScreen(child: child),
            ),
          ]),
    ],
  );
}
