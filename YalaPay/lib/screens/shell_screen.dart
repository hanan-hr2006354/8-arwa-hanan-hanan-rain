import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/routes/app_router.dart';

class ShellScreen extends StatefulWidget {
  // Change to StatefulWidget
  final Widget? child;

  const ShellScreen({super.key, this.child});

  @override
  _ShellScreenState createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0; // state too track current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color(0xFFFEFFF7),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: const Color(0xFFEFD4D4),
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Reports Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 97, 68, 68),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Invoices Report'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                context.go(AppRouter.invoiceReport.path);
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Cheques Report'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                context.go(AppRouter.chequesReport.path);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          widget.child ?? Container(),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEFD4D4),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFEFD4D4),
        currentIndex: _currentIndex, // use the state variable here
        selectedItemColor: const Color.fromARGB(255, 74, 52, 52),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage Cashing',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              context.go(AppRouter.main.path);
              break;
            case 1:
              context.go(AppRouter.customer.path);
              break;
            case 2:
              context.go(AppRouter.invoice.path);
              break;
            case 3:
              context.go(AppRouter.payment.path);
              break;
            case 4:
              context.go(AppRouter.manageCashing.path);
              break;
          }
        },
      ),
    );
  }
}
